import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  bool loading = false;

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
          await updateMemberVerification(
              context: context, verificationStatus: value);
          setState(() {
            allowVerification = value;
          });
        }
      } else {
        await updateMemberVerification(
            context: context, verificationStatus: value);
        setState(() {
          allowVerification = value;
        });
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
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0, 4),
                        blurRadius: 5.0)
                  ],
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0))),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).iconTheme.color,
                      size: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    AppLocalizations.of(context).personalInformation,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1.color,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 170),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 36.0,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 34.0,
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 50,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).nameHint,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              pickedMember.memberName,
                              style: const TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: pickedMember.isBlocked == true
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                pickedMember.isBlocked == true
                                    ? AppLocalizations.of(context).inActiveTitle
                                    : AppLocalizations.of(context).activeTitle,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .color,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(
                                pickedMember.isBlocked == true
                                    ? Icons.cancel_outlined
                                    : Icons.check,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              )
                            ],
                          ),
                        ),
                      ],
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
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black54,
                                offset: Offset(0, 0.5),
                                blurRadius: 5.0)
                          ],
                          color: Theme.of(context).scaffoldBackgroundColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).emailTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            pickedMember.memberEmail,
                            style: const TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.grey),
                          ),

                          const Divider(
                            endIndent: 20,
                            indent: 20,
                          ),

                          ////////////////////////

                          Text(
                            AppLocalizations.of(context).phoneTitle,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Theme.of(context).primaryColor),
                          ),
                          Text(
                            pickedMember.memberPhone,
                            style: const TextStyle(
                                //  fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.grey),
                          ),
                          const Divider(
                            endIndent: 20,
                            indent: 20,
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
                        right: 22,
                        top: 22,
                        bottom: 22,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black54,
                                offset: Offset(0, 0.5),
                                blurRadius: 5.0)
                          ],
                          color: Theme.of(context).scaffoldBackgroundColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).allowVerification,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.grey),
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
                                MaterialStateProperty.all(Colors.grey),
                            overlayColor: MaterialStateProperty.all(
                                Theme.of(context).scaffoldBackgroundColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                        onPressed: () async {
                          try {
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

                            print('RESPONSE:::  ${response}');

                            if (response == true) {
                              await updateMemberQrCode(context: context);

                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) =>
                                    FeedBackDialog(
                                        titleText: AppLocalizations.of(context)
                                            .updateQrCodeSuccessfully,
                                        gif: 'assets/gifs/success.json',
                                        enableButton: true,
                                        buttonText: AppLocalizations.of(context)
                                            .doneTitle,
                                        callBackFunction: () {
                                          Navigator.of(context).pop();
                                        },
                                        buttonColor:
                                            Theme.of(context).primaryColor),
                              );
                            }
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
                          } on SocketException catch (error) {
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
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            AppLocalizations.of(context).resendQrCode,
                            style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline1.color,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  loading == true
                      ? Center(
                          child: LoadingAnimationWidget.fourRotatingDots(
                            color: Theme.of(context).primaryColor,
                            size: 50,
                          ),
                        )
                      : Padding(
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
                                  backgroundColor: MaterialStateProperty.all(
                                      pickedMember.isBlocked == true
                                          ? Colors.green
                                          : Colors.redAccent),
                                  overlayColor: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .scaffoldBackgroundColor),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ))),
                              onPressed: () async {
                                try {
                                  setState(() {
                                    loading = true;
                                  });
                                  await blockMember(context);
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) =>
                                        FeedBackDialog(
                                            titleText:
                                                'Member is blocked successfully',
                                            gif: 'assets/gifs/success.json',
                                            enableButton: true,
                                            buttonText:
                                                AppLocalizations.of(context)
                                                    .doneTitle,
                                            callBackFunction: () {
                                              Navigator.of(context).pop();
                                            },
                                            buttonColor:
                                                Theme.of(context).primaryColor),
                                  );

                                  setState(() {
                                    loading = false;
                                  });
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
                                } on SocketException catch (error) {
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
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Text(
                                  pickedMember.isBlocked == true
                                      ? 'Unblock Member'
                                      : AppLocalizations.of(context)
                                          .blockMember,
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
          ),
        ],
      ),
    );
  }
}
