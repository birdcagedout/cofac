import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannedBarcodeLabel extends StatefulWidget {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodeCapture,
    required this.scannedQRSet,
    required this.fontColor,
  });

  final Stream<BarcodeCapture> barcodeCapture;
  final Set<String> scannedQRSet;
  final Color fontColor;

  @override
  State<ScannedBarcodeLabel> createState() => _ScannedBarcodeLabelState();
}

class _ScannedBarcodeLabelState extends State<ScannedBarcodeLabel> {
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return StreamBuilder(
      stream: widget.barcodeCapture,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        if (scannedBarcodes.isEmpty) {
          return Text(
            '스캔된 QR code가 없습니다',
            overflow: TextOverflow.fade,
            style: TextStyle(color: widget.fontColor),
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

        return NotificationListener<ScrollNotification>(
          child: Scrollbar(
            controller: scrollController,
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.scannedQRSet.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    widget.scannedQRSet.map((e) => "[${(1 + index).toString().padLeft(2, '0')}]    사용자: ${e.substring(2)}    식권번호: ${e.substring(0,2)}").toList()[index],
                    overflow: TextOverflow.fade,
                    style: TextStyle(color: widget.fontColor, fontSize: 16),
                  ),
                );
              },
            ),
          ),
          onNotification: (notification) => false,
        );


      },
    );
  }
}
