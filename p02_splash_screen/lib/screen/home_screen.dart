import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:p02_splash_screen/const/const.dart';

import '../ext/scanned_barcode_label.dart';
import '../ext/scanner_error_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );
  Barcode? lastBarcode;
  List<Offset>? corners;

  @override
  void initState() {
    super.initState();
    controller.start();
  }

  @override
  Widget build(BuildContext context) {

    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),   // Offset(192.0, 408.5) ==> 스크린 크기: (384, 817)
      width: 200,
      height: 200,
    );
    // TopLeft:Offset(92.0, 308.5), TopRight:Offset(292.0, 308.5), BottomLeft:Offset(92.0, 508.5), BottomRight: Offset(292.0, 508.5)

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text(
          APP_TITLE_FULL,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple[700],
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        child: Stack(
          // fit: StackFit.expand,
          children: [

            MobileScanner(
              // fit: BoxFit.contain,
              controller: controller,
              // scanWindow: scanWindow,
              // errorBuilder: (context, error, child) {
              //   return ScannerErrorWidget(error: error);
              // },
              // overlayBuilder: (context, constraints) {
              //   return Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Align(
              //       alignment: Alignment.bottomCenter,
              //       child: ScannedBarcodeLabel(barcodes: controller.barcodes),
              //     ),
              //   );
              // },
              onDetect: (barcodeCapture) {
                final barcode = barcodeCapture.barcodes.first;
                if (barcode.rawValue != null) {
                  setState(() {
                    lastBarcode = barcode;
                    print(barcode.corners);
                    corners = barcode.corners;
                    corners = corners!.map((e) => e - Offset(80,0)).toList();
                  });
                }
              },
            ),

            if (lastBarcode != null)
            Positioned(
              left: 0,
              top: 0,
              child: CustomPaint(
                painter: BorderPainter(corners!),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}


class BorderPainter extends CustomPainter {
  final List<Offset> corners;

  BorderPainter(this.corners);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path()
      ..addPolygon(corners, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}


class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    // final backgroundPath = Path()..addRect(Rect.largest);
    final backgroundPath = Path()..addRect(Offset.zero & size);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}



class BarcodeBorderPainter extends CustomPainter {
  final List<Offset> corners;

  BarcodeBorderPainter(this.corners);

  @override
  void paint(Canvas canvas, Size size) {
    if (corners.isEmpty) return;

    var paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    var path = Path();
    path.moveTo(corners.first.dx, corners.first.dy);
    for (var corner in corners) {
      path.lineTo(corner.dx, corner.dy);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}