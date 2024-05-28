import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannedBarcodeLabel extends StatelessWidget {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodeCapture,
    required this.scannedQRSet,
  });

  final Stream<BarcodeCapture> barcodeCapture;
  final Set<String> scannedQRSet;

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return StreamBuilder(
      stream: barcodeCapture,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        if (scannedBarcodes.isEmpty) {
          return const Text(
            '스캔된 QR code가 없습니다',
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
          );
        }

        // return Text(
        //   scannedBarcodes.first.displayValue ?? 'No display value.',
        //   overflow: TextOverflow.fade,
        //   style: const TextStyle(color: Colors.white),
        // );

        // return ListView.builder(
        //   itemCount: scannedBarcodes.length,
        //   itemBuilder: (context, index) {
        //     return Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Text(
        //         scannedBarcodes[index].rawValue ?? '값 없음',
        //         overflow: TextOverflow.fade,
        //         style: const TextStyle(color: Colors.white),
        //       ),
        //     );
        //   },
        // );

        return NotificationListener(
          child: Scrollbar(
            controller: scrollController,
            child: ListView.builder(
              controller: scrollController,
              itemCount: scannedQRSet.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    scannedQRSet.map((e) => e).toList()[index] ?? '',
                    overflow: TextOverflow.fade,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          onNotification: (event) {
            if(scrollController.offset != scrollController.position.maxScrollExtent) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 100),
                curve: Curves.fastOutSlowIn,
              );
            }
            return false;
          },
        );


      },
    );
  }
}
