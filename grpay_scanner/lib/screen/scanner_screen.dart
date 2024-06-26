import 'dart:async';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grpay_scanner/const/const.dart';
import 'package:grpay_scanner/core/staff_store_data.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../ext/scanned_barcode_label.dart';
import '../core/qr_core.dart';




class ScannerScreen extends StatefulWidget {
  const ScannerScreen({required this.selectedStore, super.key});
  final String selectedStore;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}



class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller = MobileScannerController(detectionSpeed: DetectionSpeed.unrestricted, formats: [BarcodeFormat.qrCode]);

  // 스캔된 QR 저장
  final ValueNotifier<Set<String>> scannedQRSet = ValueNotifier<Set<String>>({});   // Set이라 중복 제거. "02김재형" 형태로 저장됨
  final Map<String, List<int>> scannedQRrow = {};                                   // {'김재형': [1, 3, 8], '이재환': [10, 11], '정헌옥': []}


  // 현재 카메라에 QR이 있는지 여부를 상태로 저장
  ValueNotifier<bool> isQRpresent = ValueNotifier<bool>(false);   // 현재 카메라에 QR이 있는지 여부(있으면 true, 없으면 false)
  Timer? noQRTimer;

  // 현재 QR이 내 QR인지 여부
  ValueNotifier<bool> isMyQRpresent = ValueNotifier<bool>(false);   // 현재 카메라에 들어온 QR이 내 QR인지 여부(있으면 true, 없으면 false)



  @override
  void initState() {
    super.initState();

    // 현재 카메라에 검출된 QR이 있는지 없는지 판단하기 위한 ValueNotifier에 listener 붙임
    // controller.barcodes는 Stream<BarcodeCapture> 타입이고, 인자로 들어가는 함수는 onData시에 BarcodeCapture 객체가 들어옴
    controller.barcodes.listen(
      (capture) {
        // 직전상태에 QR 없었음 => 현재 QR 들어옴
        if(isQRpresent.value == false) {
          isQRpresent.value = true;
        }
        // 직전상태에 QR 있었음 => 현재 QR 들어옴
        else {
          // 50ms 남은 타이머가 살아있을테니 죽임
          noQRTimer!.cancel();
        }
        // 300ms짜리 새로운 타이머 생성 => 300ms 후에 스트림 안 들어오면 isQRpresent은 false
        noQRTimer = Timer(Duration(milliseconds: controller.detectionTimeoutMs + 50), () => isQRpresent.value = false,);
      },
    );
  }



  // QR코드 주변 그리는 CustomPaint 위젯
  Widget _buildBarcodeOverlay() {
    return ValueListenableBuilder(
      valueListenable: isQRpresent,
      builder: (context, isQR, child) {
        return ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {    // value는 (value.size로만 값을 취하므로) camera로 보면 된다

            // 체크해보니 일단 처음 3번 호출됨
            // value.isInitialized=false, value.isRunning=false, value.error=null -> 카메라 초기화 전(이후 카메라 등록정보 올라감)
            // value.isInitialized=true, value.isRunning=true, value.error=null -> 카메라 초기화됨(id=0인 Camera의 state=OPEN)
            // value.isInitialized=true, value.isRunning=true, value.error=null -> 카메라 캡처 세션 open(Opening capture session)
            // value.isInitialized=true, value.isRunning=true, value.error=null
            // print("일단 컨트롤러 변화 감지됨: value.isInitialized=${value.isInitialized}, value.isRunning=${value.isRunning}, value.error=${value.error}");


            // 꼭 필요함 Not ready.
            if (!value.isInitialized || !value.isRunning || value.error != null) {
              debugPrint("NOT READY");
              return const SizedBox();
            }

            // 화면에 QR 있었다가 없을 때 콘트롤러 값이 바뀌는지 테스트 ==> 안 바뀜(현재 코드 실행 안 됨) ==> 그래서 isQRpresent를 넣었음
            // print("콘트롤러 값 바뀜");

            return StreamBuilder<BarcodeCapture>(
              // Stream<BarcodeCapture> 타입이다. <--다름--> BarcodeCapture.barcodes는 List<Barcode> 타입이다
              stream: controller.barcodes,
              builder: (context, snapshot) {
                final BarcodeCapture? barcodeCapture = snapshot.data;

                // No barcode: 처음 실행될 때 딱 2번만 true
                if (barcodeCapture == null || barcodeCapture.barcodes.isEmpty) {
                  return const SizedBox();
                }

                List<Barcode> scannedBarcodes = barcodeCapture.barcodes;
                print("어떤 QR 발견");

                // No barcode corners, or size, or no camera preview size.
                // 안드로이드일 때는 barcodeCapture.size가 (0,0)으로 안 나온다. 아이폰일 때만 나온다
                // if (scannedBarcode.corners.isEmpty || value.size.isEmpty) {
                //   return const SizedBox();
                // }

                // 아이폰일 때만 barcodeCapture.size를 사용한다
                // if(defaultTargetPlatform == TargetPlatform.iOS && barcodeCapture.size.isEmpty) {
                //   return const SizedBox();
                // }


                // 여러개의 scannedBarcodes 중 내 QR만 골라냄
                List<BarcodeWithColor> myQRs = [];
                bool anyNewQRFound = false;
                for(var eachQR in scannedBarcodes) {

                  // 내 QR이 맞는지 검증
                  String rawQR = eachQR.displayValue!;
                  QRInfo qrInfo = getValidQRInfo(rawQR);
                  isMyQRpresent.value = qrInfo.isMyQR;

                  // 내 QR인 경우만 처리 (리스트에서 삭제하면 안됨: scannedBarcodes 리스트 순서를 1개 건너뛰게 됨)
                  if(qrInfo.isMyQR == true) {

                    // 이제 내 QR이므로 ==> Set에 추가 (리턴값: 새로운 값이면 true)
                    bool isNewQR = scannedQRSet.value.add(qrInfo.getString());

                    // myQRs에 등록
                    BarcodeWithColor qr = BarcodeWithColor();
                    qr.barcode = eachQR;
                    qr.color = isQR ? colorTable[qrInfo.id]! : Colors.transparent;
                    myQRs.add(qr);

                    // 이미 있으면(Set이 바뀌지 않았으면) 녹색, 없으면(바뀌었으면) 빨간색
                    if(isNewQR) {
                      anyNewQRFound = true;

                      // 새로운 QR이 들어올 때마다 Map애 등록
                      if(scannedQRrow[qrInfo.name] == null) {
                        scannedQRrow[qrInfo.name] = [];
                      }
                      scannedQRrow[qrInfo.name]!.add(qrInfo.number);
                    }
                  }
                }

                // 이번 build에서 단 하나라도 새로운 QR이 있었다면 setState() 호출
                if(anyNewQRFound) {
                  // 새로운 QR을 발견할 때 setState()해주되, 당장 아니고 현재 build가 끝났을 때 비동기로 함
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {});
                  });
                }



                // 안드로이드
                // [Offset(237.0, 349.0), Offset(341.0, 370.0), Offset(320.0, 475.0), Offset(217.0, 453.0)], size: Size(0.0, 0.0), camera: Size(480.0, 640.0)
                // 아이폰
                // [Offset(432.0, 714.0), Offset(679.0, 808.0), Offset(586.0, 1050.0), Offset(343.0, 958.0)], size: Size(1128.0, 1504.0), camera: Size(3024.0, 4032.0)
                // debugPrint("[CustomPaint직전] corners: ${scannedBarcode.corners}, size: ${barcodeCapture.size}, camera: ${value.size}");

                return CustomPaint(
                  painter: BarcodeOverlay(
                    myQRs: myQRs,
                    barcodeSize: barcodeCapture.size,
                    boxFit: BoxFit.contain,
                    cameraPreviewSize: value.size,
                  ),
                );
              },
            );
          },
        );
      },);
  }

  /// 상단에 "스캔완료: 0개" 띄우기
  Widget _buildScanCompleted() {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: scannedQRSet,
      builder: (BuildContext context, Set<String> newSet, Widget? child) {
        return Positioned(
          left: 20,
          top: 20,
          width: MediaQuery.of(context).size.width - 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.selectedStore, style: TextStyle(color: Colors.yellow[600], fontSize: 20,),),
              Text("스캔완료 ${newSet.length}개", style: const TextStyle(color: Colors.white, fontSize: 20,),),
            ],
          ),
        );
      },
    );
  }


  /// 스캔한 결과를 아랫쪽에 보여주기
  Widget _buildScannedResult() {
    final scrollController = ScrollController();

    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          // height: 100,
          color: Colors.black,
          child: StreamBuilder(
            stream: controller.barcodes,
            builder: (context, snapshot) {
              final scannedBarcodes = snapshot.data?.barcodes ?? [];

              if (scannedBarcodes.isEmpty) {
                return const Text(
                  '스캔된 QR code가 없습니다',
                  overflow: TextOverflow.fade,
                  style: TextStyle(color: Colors.yellow),
                );
              }

              /// 현재 StreamBulider 실행 후에 스크롤 위치를 맨 마지막으로 이동
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollController.hasClients) {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });

              // 현재 scannedQRSet을 List로 바꾼다
              final scannedQRList = scannedQRSet.value.toList();

              return NotificationListener<ScrollNotification>(
                child: Scrollbar(
                  controller: scrollController,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: scannedQRSet.value.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(child: Text("[${(1 + index).toString().padLeft(2, '0')}]", style: const TextStyle(color: Colors.yellow, fontSize: 16),)),   // [01]
                            Expanded(child: Text(teamTable[scannedQRList[index].substring(2)]!.padLeft(3), style: const TextStyle(color: Colors.yellow, fontSize: 16,),),),   // 행정팀
                            Expanded(child: Text(scannedQRList[index].substring(2), style: const TextStyle(color: Colors.yellow, fontSize: 16),)),               // 김재형
                            Expanded(child: Text(targetYear.toString() + targetMonth.toString().padLeft(2, "0"), style: const TextStyle(color: Colors.yellow, fontSize: 16),)),   // 202406
                            Expanded(child: Text("  # ${scannedQRList[index].substring(0,2)}", style: const TextStyle(color: Colors.yellow, fontSize: 16),)),      // #09
                          ],
                        ),
                      );
                    },
                  ),
                ),
                onNotification: (notification) => false,
              );
            },
          ),
        ),
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
    // 물리적 (W, H) = (1440, 3064)
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double appBarHeight = AppBar().preferredSize.height;
    double cameraPreviewHeight = 512;

    return Scaffold(
      appBar: AppBar(title: const Text('스캔 중', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),), centerTitle: true,),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: 512,
            child: Stack(
              fit: StackFit.expand,
              children: [

                // 검은배경과 카메라프리뷰 합쳐서 MobileScanner임 (앱바를 제외한 모든영역에서 위/아래 검은색 같은 높이)
                MobileScanner(
                  fit: BoxFit.contain,
                  // scanWindow: scanWindow,
                  controller: controller,
                ),

                // QR code 테두리 색칠 (QR 없으면 투명색)
                _buildBarcodeOverlay(),

                // 스캔 윈도
                // _buildScanWindow(scanWindow),

                // 스캔 완료
                _buildScanCompleted(),

                // QR 없을 때 검출을 위한 테스트
                // ValueListenableBuilder(valueListenable: isQRpresent, builder: (context, isQR, child) { if(isQR) print("QR 있음"); else print("QR 없음");  return SizedBox();},),

              ],
            ),
          ),

          // 스캔 결과 보여주는 부분
          _buildScannedResult(),

          // "저장하기" 버튼
          Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.black,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                  side: BorderSide(color: Colors.green[700]!,),
                ),
                onPressed: () {
                  // 현재까지 QR 검출된 data를 pop에 인자로 넘겨주기
                  // scannedQRrow는 Map<String, List<int>> 타입임
                  Navigator.of(context).pop(scannedQRrow);
                },
                child: const Text("저장하기", style: TextStyle(fontSize: 20,),),
              ),
          ),

          // 화면 하단 여백
          const SizedBox(height: 10,),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}



// 스캔 윈도(중간 사각형)을 제외한 나머지 배경을 그리는 CustomPainer
// class ScannerOverlay extends CustomPainter {
//   ScannerOverlay(this.scanWindow);
//
//   final Rect scanWindow;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     // TODO: use `Offset.zero & size` instead of Rect.largest
//     // we need to pass the size to the custom paint widget
//     final backgroundPath = Path()..addRect(Rect.largest);
//     final cutoutPath = Path()..addRect(scanWindow);
//
//     final backgroundPaint = Paint()
//       ..color = Colors.black.withOpacity(0.5)
//       ..style = PaintingStyle.fill
//       ..blendMode = BlendMode.dstOut;
//
//     final backgroundWithCutout = Path.combine(
//       PathOperation.difference,
//       backgroundPath,
//       cutoutPath,
//     );
//     canvas.drawPath(backgroundWithCutout, backgroundPaint);
//   }
//
//   @override
//   bool shouldRepaint(ScannerOverlay oldDelegate) {
//     return false;
//   }
// }





// 스캔된 바코드 주변을 그리는 CustomPainer
class BarcodeOverlay extends CustomPainter {
  BarcodeOverlay({
    required this.myQRs,
    required this.barcodeSize,
    required this.boxFit,
    required this.cameraPreviewSize,
  });

  // final List<Offset> barcodeCorners;
  final List<BarcodeWithColor> myQRs;
  final Size barcodeSize;
  final BoxFit boxFit;
  final Size cameraPreviewSize;


  @override
  void paint(Canvas canvas, Size size) {

    for(var eachQRwithColor in myQRs) {
      final List<Offset> barcodeCorners = eachQRwithColor.barcode.corners;

      // android/ios 공통
      if (barcodeCorners.isEmpty || cameraPreviewSize.isEmpty) {
        debugPrint("[android] 바코드corner가 없거나, 카메라프리뷰size가 없다");
        return;
      }

      // iOS인 경우만 barcodeSize가 필요하다
      if(defaultTargetPlatform == TargetPlatform.iOS && barcodeSize.isEmpty) {
        debugPrint("[iOS] 바코드corner가 없거나, 바코드size가 없거나, 카메라프리뷰size가 없다");
        return;
      }

      // applyBoxFit(BoxFit.contain, sourceSize, destSize)
      // ==> 원본사이즈(카메라프리뷰)가 화면표시가능한최대사이즈(size)로 BoxFit.contain 스케일링될 때 FittedSize 타입의 adjustedSize를 리턴한다
      // FittedSize 타입은 2개의 속성을 가진다 (adjustedSize.source, adjustedSize.destination)
      // 예) source=Size(120, 80)가 dest=(300, 300) 영역에 BoxFit.contain으로 그려지면
      //    adjustedSize.source는 Size(120,80)으로 원본과 동일하고, adjustedSize.destination=Size(300, 200)이 된다
      //    이때 widthRatio=300/120=2.5, heightRatio=200/80=2.5
      final adjustedSize = applyBoxFit(boxFit, cameraPreviewSize, size);

      double verticalPadding = size.height - adjustedSize.destination.height;
      double horizontalPadding = size.width - adjustedSize.destination.width;

      if (verticalPadding > 0) {
        verticalPadding = verticalPadding / 2;
      } else {
        verticalPadding = 0;
      }

      if (horizontalPadding > 0) {
        horizontalPadding = horizontalPadding / 2;
      } else {
        horizontalPadding = 0;
      }

      final double ratioWidth;
      final double ratioHeight;

      // 아이폰일 때
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        ratioWidth = barcodeSize.width / adjustedSize.destination.width;
        ratioHeight = barcodeSize.height / adjustedSize.destination.height;
      }
      // 안드로이드일 때
      else {
        ratioWidth = cameraPreviewSize.width / adjustedSize.destination.width;
        ratioHeight = cameraPreviewSize.height / adjustedSize.destination.height;
      }

      final List<Offset> adjustedOffset = [
        for (final offset in barcodeCorners)
          Offset(
            offset.dx / ratioWidth + horizontalPadding,
            offset.dy / ratioHeight + verticalPadding,
          ),
      ];

      final qrEdgePath = Path()..addPolygon(adjustedOffset, true);

      final qrEdgePainter = Paint()
        ..color = eachQRwithColor.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke;

      canvas.drawPath(qrEdgePath, qrEdgePainter);
    }
  }

  @override
  bool shouldRepaint(BarcodeOverlay oldDelegate) {
    // return qrEdgePath != oldDelegate.qrEdgePath;
    return true;
  }
}
