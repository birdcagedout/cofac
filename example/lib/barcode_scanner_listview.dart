import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobile_scanner_example/scanner_button_widgets.dart';
import 'package:mobile_scanner_example/scanner_error_widget.dart';

class BarcodeScannerListView extends StatefulWidget {
  const BarcodeScannerListView({super.key});

  @override
  State<BarcodeScannerListView> createState() => _BarcodeScannerListViewState();
}


/// STATE
class _BarcodeScannerListViewState extends State<BarcodeScannerListView> {

  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.unrestricted,
    torchEnabled: false,
  );
  double? statusBarHeight;
  double? appBarHeight;
  double? screenWidth;
  double? screenHeight;


  // 하단 리스트뷰
  Widget _buildBarcodesListView() {
    return StreamBuilder<BarcodeCapture>(
      stream: controller.barcodes,
      builder: (context, snapshot) {
        final barcodes = snapshot.data?.barcodes;

        if (barcodes == null || barcodes.isEmpty) {
          return const Center(
            child: Text(
              'Scan Something!',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          );
        }

        return ListView.builder(
          itemCount: barcodes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                barcodes[index].rawValue ?? 'No raw value',
                overflow: TextOverflow.fade,
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    statusBarHeight = statusBarHeight ?? MediaQuery.of(context).padding.top;    // 27.733333333333334  (상태바 높이)
    appBarHeight = appBarHeight ?? AppBar().preferredSize.height;               // 56 (상태바를 제외한 앱바 높이)

    screenWidth = screenWidth ?? MediaQuery.of(context).size.width;     // 384
    screenHeight = screenHeight ?? MediaQuery.of(context).size.height;  // 817.0666666666667

    return Scaffold(
      appBar: AppBar(title: const Text('With ListView')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          SizedBox(
            height: 512,
            child: MobileScanner(
              controller: controller,
              fit: BoxFit.contain,
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: (screenHeight! - statusBarHeight! - appBarHeight! - 512),
              color: Colors.black.withOpacity(0.4),
              child: Column(
                children: [
                  Expanded(
                    child: _buildBarcodesListView(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ToggleFlashlightButton(controller: controller),
                      StartStopMobileScannerButton(controller: controller),
                      const Spacer(),
                      SwitchCameraButton(controller: controller),
                      AnalyzeImageFromGalleryButton(controller: controller),
                    ],
                  ),
                ],
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
