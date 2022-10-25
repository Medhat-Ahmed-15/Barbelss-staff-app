import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Exceptions/getRequest_exception.dart';
import '../assistant/assistantFunction.dart';
import 'feedBackDialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PickFreezingTimeDialog extends StatefulWidget {
  @override
  State<PickFreezingTimeDialog> createState() => _PickFreezingTimeDialogState();
}

class _PickFreezingTimeDialogState extends State<PickFreezingTimeDialog> {
  List<String> list = <String>['day', 'week', 'month', 'year'];

  final durationController = TextEditingController();

  String durationErrorText = '';
  String dropdownValue = 'day';

  FocusNode durationFocusNode = FocusNode();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 1.0,
      child: Container(
        padding: const EdgeInsets.all(
          20,
        ),
        width: double.infinity,
        height: 450,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).specifyDuration,
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Divider(
                thickness: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Row(
                children: [
                  //Day ******************

                  Expanded(
                    child: TextField(
                      controller: durationController,
                      onTap: () {
                        setState(() {
                          durationErrorText = '';
                        });
                      },
                      focusNode: durationFocusNode,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      cursorColor: Theme.of(context).primaryColor,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: durationFocusNode.hasFocus
                                ? Theme.of(context).primaryColor
                                : Colors.black54,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: durationFocusNode.hasFocus
                                ? Theme.of(context).primaryColor
                                : Colors.black54,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        labelText: AppLocalizations.of(context).duration,
                        hintText: 'ex: 12',
                        errorText:
                            durationErrorText == '' ? null : durationErrorText,
                        labelStyle: TextStyle(
                          color: durationFocusNode.hasFocus
                              ? Theme.of(context).primaryColor
                              : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(
                        Icons.arrow_downward,
                        color: Theme.of(context).primaryColor,
                      ),
                      elevation: 16,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      underline: Container(
                          height: 2, color: Theme.of(context).primaryColor),
                      onChanged: (String value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value;
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value == 'day'
                              ? AppLocalizations.of(context).day
                              : value == 'week'
                                  ? AppLocalizations.of(context).week
                                  : value == 'month'
                                      ? AppLocalizations.of(context).month
                                      : AppLocalizations.of(context).year),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
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
                            overlayColor: MaterialStateProperty.all(
                                Theme.of(context).scaffoldBackgroundColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ))),
                        onPressed: () async {
                          try {
                            setState(() {
                              loading = true;
                            });

                            await freezeRegistration(
                                registrationId: allMemberRegistrationsList[0]
                                    .registrationId,
                                context: context,
                                duration:
                                    '${durationController.text.trim()} $dropdownValue');

                            //   await refresh();
                            Navigator.of(context).pop(true);
                            Navigator.of(context).pop(true);
                            showToast(
                                AppLocalizations.of(context)
                                    .packageHasBeenFreezedSuccessfully,
                                context);

                            setState(() {
                              loading = false;
                            });
                          } on GetRequestException catch (error) {
                            durationErrorText = error.toStringMessage();
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
                          } catch (error) {
                            showToast(
                                AppLocalizations.of(context).somethingWentWrong,
                                context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            AppLocalizations.of(context).submit,
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
      ),
    );
  }
}
