import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  Future<bool> Function(String)? onScanProcess;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Future<bool> Function(String)) {
      onScanProcess = args;
    } else {
      throw Exception('Invalid arguments');
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: <Widget>[
                SizedBox(width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: QRView(
                        key: qrKey, onQRViewCreated: _onQRViewCreated)),
              ],
            );
          }
      ),
      appBar: AppBar(title: const Text('Scan QR Code')),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      await controller.pauseCamera();
      final bool result =
          onScanProcess != null ? await onScanProcess!(scanData.code!) : false;
      if (result) {
        Navigator.of(context).pop();
      } else {
        controller.resumeCamera();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not process the QR code')),
        );
      }
    });
  }
}
