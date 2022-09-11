// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart' as lot;

class FeedBackDialog extends StatelessWidget {
  String titleText;
  String gif;
  String buttonText;
  Function callBackFunction;
  bool enableButton;
  Color buttonColor;

  FeedBackDialog(
      {this.titleText,
      this.gif,
      this.enableButton,
      this.buttonText,
      this.callBackFunction,
      this.buttonColor});

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
              width: 200,
              height: 200,
              child: lot.LottieBuilder.asset(gif),
            ),
            const SizedBox(height: 18.0),
            Text(
              titleText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor),
            ),
            const SizedBox(
              height: 10.0,
            ),
            enableButton == true
                ? Container(
                    width: 150,
                    height: 56,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).scaffoldBackgroundColor),
                          overlayColor: MaterialStateProperty.all(buttonColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: buttonColor)))),
                      onPressed: () async {
                        callBackFunction();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        child: Text(
                          buttonText,
                          style: TextStyle(color: buttonColor, fontSize: 14),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 0,
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
