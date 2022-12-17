// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScanQrCodeDialog extends StatefulWidget {
  @override
  State<ScanQrCodeDialog> createState() => _ScanQrCodeDialogState();
}

class _ScanQrCodeDialogState extends State<ScanQrCodeDialog> {
  final qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
              allowDuplicates: false,
              //controller: MobileScannerController(),
              onDetect: (barcode, args) async {
                if (barcode.rawValue == null) {
                  Navigator.of(context).pop('Failed To Scan');
                } else {
                  if (await Vibration.hasCustomVibrationsSupport()) {
                    Vibration.vibrate();
                  }
                  final String data = barcode.rawValue;
                  Navigator.of(context).pop(data);
                }
              }),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 3),
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 30,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context).exit,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    decoration: TextDecoration.underline),
              ),
            ),
          )
        ],
      ),
    );
  }
}
