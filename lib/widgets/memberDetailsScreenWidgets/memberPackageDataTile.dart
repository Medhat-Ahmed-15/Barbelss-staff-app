// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/models/memberRegistrationsResponseData.dart';
import 'package:gym_staff_app/screens/memberDetailsScreen.dart';
import 'package:gym_staff_app/screens/memberPackageDetailsScreen.dart';

import '../../Exceptions/getRequest_exception.dart';
import '../feedBackDialog.dart';

class MemberPackageDataTile extends StatelessWidget {
  MemberRegistrationsResponseData memberRegistrationsResponseData;
  Function refresh;
  Function setBackgroundLoading;
  Function stopBackgroundLoading;
  MemberPackageDataTile(
    this.memberRegistrationsResponseData,
    this.refresh,
    this.setBackgroundLoading,
    this.stopBackgroundLoading,
  );
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        pickedMemberPackage = memberRegistrationsResponseData;
        var response = await Navigator.pushNamed(
            context, MemberPackageDetailsScreen.routeName);
        if (response == true) {
          await refresh();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        width: MediaQuery.of(context).size.width,
        height: 190,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Dismissible(
                key: UniqueKey(),
                background: Container(
                  margin: const EdgeInsets.all(15),
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.delete,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  try {
                    setBackgroundLoading();
                    await deleteRegistration(
                        context: context,
                        registrationId:
                            memberRegistrationsResponseData.registrationId);

                    stopBackgroundLoading();
                  } on SocketException {
                    stopBackgroundLoading();

                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) => FeedBackDialog(
                          titleText: AppLocalizations.of(context)
                              .connectionStatusMessage,
                          gif: 'assets/gifs/fail.json',
                          enableButton: true,
                          buttonText: AppLocalizations.of(context).doneTitle,
                          callBackFunction: () {
                            Navigator.of(context).pop();
                          },
                          buttonColor: Colors.redAccent),
                    );
                  } on GetRequestException catch (error) {
                    stopBackgroundLoading();
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) => FeedBackDialog(
                          titleText: error.toStringMessage(),
                          gif: 'assets/gifs/fail.json',
                          enableButton: true,
                          buttonText: AppLocalizations.of(context).doneTitle,
                          callBackFunction: () {
                            Navigator.of(context).pop();
                          },
                          buttonColor: Colors.redAccent),
                    );
                  }

                  await refresh();
                },
                confirmDismiss: (direction) async {
                  return true;
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: ListTile(
                    title: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              )),
                          child: Text(
                            memberRegistrationsResponseData.packageTitle,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline2.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalizations.of(context).attendedTitle,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${memberRegistrationsResponseData.registrationAttended}/${memberRegistrationsResponseData.packageAttendance}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.lock_clock,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalizations.of(context).expirationDateTitle,
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline2.color,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          convertDateToDayInNumberMonthInText(
                                  memberRegistrationsResponseData
                                      .registrationExpiresAt) +
                              " " +
                              convertTimeTo12HFormat(
                                  memberRegistrationsResponseData
                                      .registrationExpiresAt),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.all(4),
                    trailing: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: memberRegistrationsResponseData.isFreezed == true
                            ? Colors.blue
                            : memberRegistrationsResponseData
                                        .registrationIsActive ==
                                    false
                                ? Colors.redAccent
                                : Colors.green,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black54,
                              offset: Offset(0, 4),
                              blurRadius: 5.0)
                        ],
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        memberRegistrationsResponseData.isFreezed == true
                            ? AppLocalizations.of(context).freezed
                            : memberRegistrationsResponseData
                                        .registrationIsActive ==
                                    false
                                ? AppLocalizations.of(context).inActiveTitle
                                : AppLocalizations.of(context).activeTitle,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
