// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart' as lot;
import 'package:provider/provider.dart';
import '../../Exceptions/getRequest_exception.dart';
import '../../assistant/assistantFunction.dart';
import '../../providers/all_memberRegistartions_provider.dart';
import '../other/FourDotsLoading.dart';
import 'feedBackDialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmDeleteRegistrationDialog extends StatefulWidget {
  String registrationId;
  ConfirmDeleteRegistrationDialog(this.registrationId);
  @override
  State<ConfirmDeleteRegistrationDialog> createState() =>
      _ConfirmDeleteRegistrationDialogState();
}

class _ConfirmDeleteRegistrationDialogState
    extends State<ConfirmDeleteRegistrationDialog> {
  bool loading = false;

  Widget button(Color buttonColor, String buttonText, Color textColor,
      Function callBackFunction) {
    return SizedBox(
      width: 150,
      height: 56,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonColor),
            overlayColor: MaterialStateProperty.all(buttonColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Colors.redAccent)))),
        onPressed: callBackFunction,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
          child: Text(
            buttonText,
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ),
      ),
    );
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
            SizedBox(
              width: 170,
              height: 170,
              child: lot.LottieBuilder.asset('assets/gifs/delete.json'),
            ),
            const SizedBox(height: 18.0),
            Text(
              AppLocalizations.of(context).confirmDelete,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Column(
              children: [
                loading == true
                    ? FourDotsLoading()
                    : button(Colors.red, AppLocalizations.of(context).delete,
                        Theme.of(context).scaffoldBackgroundColor, () async {
                        try {
                          setState(() {
                            loading = true;
                          });
                          await Provider.of<AllMemberRegistartionsProvider>(
                                  context,
                                  listen: false)
                              .deleteRegistration(
                                  context: context,
                                  registrationId: widget.registrationId);

                          Navigator.of(context).pop();
                        } on SocketException {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) => FeedBackDialog(
                                titleText: AppLocalizations.of(context)
                                    .connectionStatusMessage,
                                gif: 'assets/gifs/fail.json',
                                enableButton: true,
                                buttonText:
                                    AppLocalizations.of(context).doneTitle,
                                callBackFunction: () {
                                  Navigator.of(context).pop();
                                },
                                buttonColor: Colors.redAccent),
                          );

                          setState(() {
                            loading = false;
                          });
                        } on GetRequestException catch (error) {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) => FeedBackDialog(
                                titleText: error.toStringMessage(),
                                gif: 'assets/gifs/fail.json',
                                enableButton: true,
                                buttonText:
                                    AppLocalizations.of(context).doneTitle,
                                callBackFunction: () {
                                  Navigator.of(context).pop();
                                },
                                buttonColor: Colors.redAccent),
                          );

                          setState(() {
                            loading = false;
                          });
                        } catch (error) {
                          showToast(
                              AppLocalizations.of(context).somethingWentWrong,
                              context);

                          setState(() {
                            loading = false;
                          });
                        }
                      }),
                const SizedBox(
                  height: 15,
                ),
                button(Theme.of(context).scaffoldBackgroundColor,
                    AppLocalizations.of(context).close, Colors.redAccent, () {
                  Navigator.of(context).pop(false);
                }),
              ],
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
