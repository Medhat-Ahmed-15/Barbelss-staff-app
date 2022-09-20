import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Exceptions/getRequest_exception.dart';
import '../assistant/assistantFunction.dart';
import '../widgets/feedBackDialog.dart';
import '../widgets/qrCodeDialog.dart';

class MemberPersonalDataScreen extends StatefulWidget {
  static const routeName = '/MemberPersonalDataScreen';

  @override
  State<MemberPersonalDataScreen> createState() =>
      _MemberPersonalDataScreenState();
}

class _MemberPersonalDataScreenState extends State<MemberPersonalDataScreen> {
  bool allowVerification = pickedMember.canAuthenticate;

  void toggleSwitch(bool value) async {
    try {
      if (value == true) {
        var response = await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) => QrCodeDialog(
            pickedMember.memberName,
            pickedMember.memberEmail,
            pickedMember.memberPhone,
            context,
          ),
        );
        if (response == true) {
          setState(() {
            allowVerification = value;
          });
          await updateMemberVerification(
              context: context, verificationStatus: value);
        }
      } else {
        setState(() {
          allowVerification = value;
        });
        await updateMemberVerification(
            context: context, verificationStatus: value);
      }
    } on GetRequestException catch (error) {
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
    } on SocketException {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => FeedBackDialog(
            titleText: AppLocalizations.of(context).connectionStatusMessage,
            gif: 'assets/gifs/fail.json',
            enableButton: true,
            buttonText: AppLocalizations.of(context).doneTitle,
            callBackFunction: () {
              Navigator.of(context).pop();
            },
            buttonColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                localeLanguage == const Locale('en')
                    ? Icons.arrow_back
                    : Icons.arrow_forward,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Text(
                      AppLocalizations.of(context).personalInformation,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline2.color,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 22,
                        right: 22,
                        top: 22,
                        bottom: 22,
                      ),
                      width: MediaQuery.of(context).size.width,
                      //height: 200,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black54,
                                offset: Offset(0, 4),
                                blurRadius: 5.0)
                          ],
                          color: Theme.of(context).scaffoldBackgroundColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).nameHint,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.0,
                                color: Colors.grey[600]),
                          ),
                          Text(
                            pickedMember.memberName,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .color),
                          ),

                          const Divider(
                            endIndent: 20,
                            indent: 20,
                          ),

                          ///////////////////////////////////

                          Text(
                            AppLocalizations.of(context).emailTitle,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.0,
                                color: Colors.grey[600]),
                          ),
                          Text(
                            pickedMember.memberEmail,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .color),
                          ),

                          const Divider(
                            endIndent: 20,
                            indent: 20,
                          ),

                          ////////////////////////

                          Text(
                            AppLocalizations.of(context).phoneTitle,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.0,
                                color: Colors.grey[600]),
                          ),
                          Text(
                            pickedMember.memberPhone,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .color),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 22,
                        top: 22,
                        bottom: 22,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black54,
                                offset: Offset(0, 4),
                                blurRadius: 5.0)
                          ],
                          color: Theme.of(context).scaffoldBackgroundColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).allowVerification,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: Colors.grey[600]),
                          ),
                          Switch(
                            onChanged: toggleSwitch,
                            value: allowVerification,
                            activeColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            activeTrackColor: Theme.of(context).primaryColor,
                            inactiveThumbColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            inactiveTrackColor: Colors.grey[300],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 56,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black54,
                              offset: Offset(0, 4),
                              blurRadius: 5.0)
                        ],
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.redAccent),
                            overlayColor: MaterialStateProperty.all(
                                Theme.of(context).scaffoldBackgroundColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                        onPressed: () async {},
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            AppLocalizations.of(context).blockMember,
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
          ),
        ],
      ),
    );
  }
}
