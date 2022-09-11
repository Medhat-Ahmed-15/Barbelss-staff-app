// ignore_for_file: file_names, missing_return

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/models/planData.dart';
import 'package:gym_staff_app/screens/mainScreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../feedBackDialog.dart';

class PlanDataTile extends StatefulWidget {
  PlanData planData;

  PlanDataTile(this.planData);

  @override
  State<PlanDataTile> createState() => _PlanDataTileState();
}

class _PlanDataTileState extends State<PlanDataTile> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: Theme.of(context).primaryColor, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0, 4),
              blurRadius: 5.0,
            )
          ],
          color: Theme.of(context).scaffoldBackgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
            child: Text(
              widget.planData.planTitle,
              style: TextStyle(
                color: Theme.of(context).textTheme.headline2.color,
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.planData.planPrice.toString(),
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline2.color,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'EGP',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline2.color,
                  fontSize: 15,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Divider(
            color: Theme.of(context).textTheme.headline2.color,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context).numberOfSessionsTitle} ',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline2.color,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.planData.planAttendance.toString(),
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline2.color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context).expiresInTitle}: ',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline2.color,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.planData.planExpiresIn,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline2.color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: loading == true
                ? Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Theme.of(context).primaryColor,
                      size: 50,
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                          shadowColor: MaterialStateProperty.all(
                              Theme.of(context).scaffoldBackgroundColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ))),
                      onPressed: () async {
                        try {
                          setState(() {
                            loading = true;
                          });
                          await registerPlan(
                            planId: widget.planData.planId,
                            planPrice: widget.planData.planPrice,
                            context: context,
                          );

                          setState(() {
                            loading = false;
                          });

                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) => FeedBackDialog(
                                titleText: AppLocalizations.of(context)
                                    .registrationDoneTitle,
                                gif: 'assets/gifs/success.json',
                                enableButton: true,
                                buttonText:
                                    AppLocalizations.of(context).doneTitle,
                                callBackFunction: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      MainScreen.routeName,
                                      ModalRoute.withName('/'));
                                },
                                buttonColor: Theme.of(context).primaryColor),
                          );
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
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        child: Text(
                          AppLocalizations.of(context).getPlanTitle,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1.color,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
