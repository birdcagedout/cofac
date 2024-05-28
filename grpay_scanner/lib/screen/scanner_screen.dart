import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../ext/scanned_barcode_label.dart';
import '../core/qr_core.dart';


Path? lastDrawnPath;


class ScannerScreen extends StatefulWidget {
  const ScannerScreen({required this.selectedStore, super.key});
  final selectedStore;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}



class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller = MobileScannerController(detectionSpeed: DetectionSpeed.unrestricted, formats: [BarcodeFormat.qrCode]);
  final ValueNotifier<Set<String>> scannedQRSet = ValueNotifier<Set<String>>({});
  // final ValueNotifier<int> scannedQRcount = ValueNotifier<int>(0);
  Color color4this = Colors.red;


  // 스캔 윈도(사각형)을 제외한 배경을 리턴하는 CustomPaint 위젯
  Widget _buildScanWindow(Rect scanWindowRect) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        // Not ready.
        if (!value.isInitialized ||
            !value.isRunning ||
            value.error != null ||
            value.size.isEmpty) {
          return const SizedBox();
        }

        return CustomPaint(
          painter: ScannerOverlay(scanWindowRect),
        );
      },
    );
  }



  // QR코드 주변 그리는 CustomPaint 위젯
  Widget _buildBarcodeOverlay() {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {    // value는 (value.size로만 값을 취하므로) camera로 보면 된다

        // Not ready.
        if (!value.isInitialized || !value.isRunning || value.error != null) {
          debugPrint("NOT READY");
          return const SizedBox();
        }

        // 화면에 QR 있었다가 없을 때 콘트롤러 값이 바뀌는지 테스트 ==> 안 바뀜(현재 코드 실행 안 됨)
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

            final scannedBarcode = barcodeCapture.barcodes.first;
            print("바코드 발견");

            // No barcode corners, or size, or no camera preview size.
            // 안드로이드일 때는 barcodeCapture.size가 (0,0)으로 안 나온다. 아이폰일 때만 나온다
            // if (scannedBarcode.corners.isEmpty || value.size.isEmpty) {
            //   return const SizedBox();
            // }

            // 아이폰일 때만 barcodeCapture.size를 사용한다
            // if(defaultTargetPlatform == TargetPlatform.iOS && barcodeCapture.size.isEmpty) {
            //   return const SizedBox();
            // }


            // 내 QR이 맞는지 검증
            String rawQR = scannedBarcode.displayValue!;
            if(isValidQR(rawQR)) {
              // 검증 통과하면 Set에 추가 (리턴값: 새로운 값이면 true)
              bool isNewQR = scannedQRSet.value.add(rawQR);

              // 이미 있으면(Set이 바뀌지 않았으면) 녹색, 없으면(바뀌었으면) 빨간색
              if(isNewQR) {
                color4this = Colors.red;
                // 새로운 QR을 발견할 때 setState()해주되, 당장 아니고 현재 build가 끝났을 때 비동기로 함
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {});
                });
              } else {
                color4this = Colors.green;
              }
            }


            // 안드로이드
            // [Offset(237.0, 349.0), Offset(341.0, 370.0), Offset(320.0, 475.0), Offset(217.0, 453.0)], size: Size(0.0, 0.0), camera: Size(480.0, 640.0)
            // 아이폰
            // [Offset(432.0, 714.0), Offset(679.0, 808.0), Offset(586.0, 1050.0), Offset(343.0, 958.0)], size: Size(1128.0, 1504.0), camera: Size(3024.0, 4032.0)
            // debugPrint("[CustomPaint직전] corners: ${scannedBarcode.corners}, size: ${barcodeCapture.size}, camera: ${value.size}");

            return CustomPaint(
              painter: BarcodeOverlay(
                barcodeCorners: scannedBarcode.corners,
                barcodeSize: barcodeCapture.size,
                boxFit: BoxFit.contain,
                cameraPreviewSize: value.size,
                timelyColor: color4this,
              ),
            );
          },
        );
      },
    );
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
              Text("${widget.selectedStore}", style: TextStyle(color: Colors.yellow[600], fontSize: 20,),),
              Text("스캔완료: ${newSet.length}개", style: TextStyle(color: Colors.white, fontSize: 20,),
              ),
            ],
          ),
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double appBarHeight = AppBar().preferredSize.height;
    double cameraPreviewHeight = 512;


    // 물리적 (W, H) = (1440, 3064)
    final scanWindow = Rect.fromCenter(
      // center: MediaQuery.sizeOf(context).center(Offset.zero) - Offset(0, (statusBarHeight + appBarHeight)) /*- Offset(0, 50)*/,
      center: Offset(MediaQuery.of(context).size.width / 2,  cameraPreviewHeight / 2),
      width: 200,
      height: 200,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('스캔 중'), centerTitle: true,),
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
                  scanWindow: scanWindow,
                  controller: controller,
                ),

                // QR code 색칠
                _buildBarcodeOverlay(),

                // 스캔 윈도
                _buildScanWindow(scanWindow),

                // 스캔 완료
                _buildScanCompleted(),

              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                // height: 100,
                color: Colors.black.withOpacity(0.4),
                child: ScannedBarcodeLabel(barcodeCapture: controller.barcodes, scannedQRSet: scannedQRSet.value,),
              ),
            ),
          ),
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
class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return false;
  }
}





// 스캔된 바코드 주변을 그리는 CustomPainer
class BarcodeOverlay extends CustomPainter {
  BarcodeOverlay({
    required this.barcodeCorners,
    required this.barcodeSize,
    required this.boxFit,
    required this.cameraPreviewSize,
    required this.timelyColor,
  });

  final List<Offset> barcodeCorners;
  final Size barcodeSize;
  final BoxFit boxFit;
  final Size cameraPreviewSize;
  Color timelyColor = Colors.red;
  Path qrEdgePath = Path();

  @override
  void paint(Canvas canvas, Size size) {

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

    qrEdgePath = Path()..addPolygon(adjustedOffset, true);

    final qrEdgePainter = Paint()
      ..color = timelyColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    // ..style = PaintingStyle.stroke;
    // ..blendMode = BlendMode.dst;

    // 전역변수에 넣는다
    lastDrawnPath = qrEdgePath;

    canvas.drawPath(qrEdgePath, qrEdgePainter);
  }

  @override
  bool shouldRepaint(BarcodeOverlay oldDelegate) {
    return qrEdgePath != oldDelegate.qrEdgePath;
  }
}


/// 직전에 색칠된 QR code의 테두리를 지우는 역할
class EraseOverlay extends CustomPainter {
  final transparentPainter = Paint()
    ..color = Colors.blue
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(lastDrawnPath!, transparentPainter);
    print("투명색으로 지워줌");
    lastDrawnPath = null;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}