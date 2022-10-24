// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/widgets/feedBackDialog.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

import '../screens/plansScreen.dart';

class QrCodeDialog extends StatefulWidget {
  String name;
  String email;
  String phone;
  BuildContext context;

  QrCodeDialog(this.name, this.email, this.phone, this.context);
  @override
  State<QrCodeDialog> createState() => _QrCodeDialogState();
}

class _QrCodeDialogState extends State<QrCodeDialog> {
  final GlobalKey globalKey = GlobalKey();

  bool loading = false;
  var uuid = const Uuid();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    qrCodeUUID = uuid.v4().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.white,
      elevation: 1.0,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30.0),
            RepaintBoundary(
// Assigning the global key to the repaint boundary widget.
              key: globalKey,
              child: QrImage(
                backgroundColor: Colors.white,
                embeddedImage: const AssetImage(''),
                //${widget.name}  ${widget.email}  ${widget.phone}
                data: jsonEncode({
                  "memberName": widget.name.toString(),
                  "memberEmail": widget.email.toString(),
                  "memberPhone": widget.phone.toString(),
                  "memberId": pickedMember.memberId,
                  "uuid": qrCodeUUID
                }),

                //.toString(),
                version: QrVersions.auto,
                size: 220,
              ),
            ),
            const SizedBox(height: 18.0),
            loading == true
                ? Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Theme.of(context).primaryColor,
                      size: 50,
                    ),
                  )
                : Container(
                    width: 150,
                    height: 56,
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(5),
                        border:
                            Border.all(color: Theme.of(context).primaryColor)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).scaffoldBackgroundColor),
                          overlayColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor)),
                      onPressed: () async {
                        //export image

                        setState(() {
                          loading = true;
                        });

                        var response = await extractImageAndPutInFirebase(
                            globalKey, widget.phone);
                        Navigator.of(context).pop(response);

                        setState(() {
                          loading = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        child: Text(
                          AppLocalizations.of(context).sendQrCode,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }
}
