// ignore_for_file: file_names, missing_return

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/models/planData.dart';
import 'package:gym_staff_app/screens/mainScreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../feedBackDialog.dart';

class PlanDataTile extends StatefulWidget {
  PlanData planData;
  String screenComingFrom;

  PlanDataTile(this.planData, this.screenComingFrom);

  @override
  State<PlanDataTile> createState() => _PlanDataTileState();
}

class _PlanDataTileState extends State<PlanDataTile> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(206, 206, 206, 1),
              offset: Offset(1, 3),
              blurRadius: 5.0,
            )
          ],
          color: Theme.of(context).scaffoldBackgroundColor),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 170,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0, 4),
                        blurRadius: 5.0)
                  ],
                  color: Theme.of(context).primaryColor),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.planData.planTitle,
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.planData.planPrice.toString(),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline2.color,
                        fontSize: 70,
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
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .numberOfSessionsTitle,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                widget.planData.planAttendance.toString(),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold),
                              ),
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
                              AppLocalizations.of(context).expiresInTitle,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.planData.planExpiresIn,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
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
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ))),
                            onPressed: () async {
                              if (pickedMember.isBlocked == true) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) =>
                                      FeedBackDialog(
                                          titleText:
                                              AppLocalizations.of(context)
                                                  .sorryMemberIsBlocked,
                                          gif: 'assets/gifs/fail.json',
                                          enableButton: true,
                                          buttonText:
                                              AppLocalizations.of(context)
                                                  .doneTitle,
                                          callBackFunction: () {
                                            Navigator.of(context).pop();
                                          },
                                          buttonColor: Colors.redAccent),
                                );
                                return;
                              }
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
                                  builder: (BuildContext context) =>
                                      FeedBackDialog(
                                          titleText:
                                              AppLocalizations.of(context)
                                                  .registrationDoneTitle,
                                          gif: 'assets/gifs/success.json',
                                          enableButton: true,
                                          buttonText:
                                              AppLocalizations.of(context)
                                                  .doneTitle,
                                          callBackFunction: () {
                                            if (widget.screenComingFrom ==
                                                'addMemberScreen') {
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      MainScreen.routeName,
                                                      ModalRoute.withName('/'));
                                            } else {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          buttonColor:
                                              Theme.of(context).primaryColor),
                                );
                              } on GetRequestException catch (error) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) =>
                                      FeedBackDialog(
                                          titleText: error.toStringMessage(),
                                          gif: 'assets/gifs/fail.json',
                                          enableButton: true,
                                          buttonText:
                                              AppLocalizations.of(context)
                                                  .doneTitle,
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
                                  builder: (BuildContext context) =>
                                      FeedBackDialog(
                                          titleText:
                                              AppLocalizations.of(context)
                                                  .connectionStatusMessage,
                                          gif: 'assets/gifs/fail.json',
                                          enableButton: true,
                                          buttonText:
                                              AppLocalizations.of(context)
                                                  .doneTitle,
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
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
