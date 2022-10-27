import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/widgets/FourDotsLoading.dart';
import '../Exceptions/getRequest_exception.dart';
import '../assistant/assistantFunction.dart';
import '../widgets/feedBackDialog.dart';
import '../widgets/memberPersonalDataWidgets/MiddleContent.dart';
import '../widgets/memberPersonalDataWidgets/UpperData.dart';
import '../widgets/qrCodeDialog.dart';

class MemberPersonalDataScreen extends StatefulWidget {
  static const routeName = '/MemberPersonalDataScreen';

  @override
  State<MemberPersonalDataScreen> createState() =>
      _MemberPersonalDataScreenState();
}

class _MemberPersonalDataScreenState extends State<MemberPersonalDataScreen> {
  bool allowVerification = pickedMember.canAuthenticate;
  bool resendQrCodeLoading = false;
  bool blockOrUnBlockLoading = false;

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
    } catch (error) {
      showToast(AppLocalizations.of(context).somethingWentWrong, context);
    }
  }

  Widget button(Function function, var buttonColor, String buttontext) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 56,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black54, offset: Offset(0, 4), blurRadius: 5.0)
          ],
        ),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(buttonColor),
              overlayColor: MaterialStateProperty.all(
                  Theme.of(context).scaffoldBackgroundColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ))),
          onPressed: function,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Text(
              buttontext,
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('STATUS 1');
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            localeLanguage == const Locale('en')
                ? Icons.arrow_back
                : Icons.arrow_forward,
            color: Theme.of(context).iconTheme.color,
            size: 25,
          ),
        ),
        title: Text(
          AppLocalizations.of(context).personalInformation,
          style: TextStyle(
              color: Theme.of(context).textTheme.headline1.color,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Upper content Containing name
                  UpperContent(), //mathotsh constant 3ashan ta5osh gowa el func dee w ta3ml update
                  const SizedBox(
                    height: 30,
                  ),

                  //middle content containing email and phone
                  const MiddleContent(),
                  const SizedBox(
                    height: 50,
                  ),
                  //Verification
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
                            activeTrackColor: Colors.green,
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

                  //Resend Qr Code
                  resendQrCodeLoading == true
                      ? FourDotsLoading()
                      : button(() async {
                          setState(() {
                            resendQrCodeLoading = true;
                          });
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

                              setState(() {
                                resendQrCodeLoading = false;
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
                                  buttonText:
                                      AppLocalizations.of(context).doneTitle,
                                  callBackFunction: () {
                                    Navigator.of(context).pop();
                                  },
                                  buttonColor: Colors.redAccent),
                            );

                            setState(() {
                              resendQrCodeLoading = false;
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
                              resendQrCodeLoading = false;
                            });
                          } catch (error) {
                            showToast(
                                AppLocalizations.of(context).somethingWentWrong,
                                context);
                          }
                        }, Colors.grey,
                          AppLocalizations.of(context).resendQrCode),
                  const SizedBox(
                    height: 20,
                  ),

                  //Block and Unblock Member
                  blockOrUnBlockLoading == true
                      ? FourDotsLoading()
                      : button(
                          () async {
                            try {
                              setState(() {
                                blockOrUnBlockLoading = true;
                              });
                              await blockMember(context);
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) =>
                                    FeedBackDialog(
                                        titleText: pickedMember.isBlocked ==
                                                false
                                            ? AppLocalizations.of(context)
                                                .memberIsUnBlockedSuccessfullly
                                            : AppLocalizations.of(context)
                                                .memberIsBlockedSuccessfullly,
                                        gif: pickedMember.isBlocked == false
                                            ? 'assets/gifs/unblock.json'
                                            : 'assets/gifs/block.json',
                                        enableButton: true,
                                        buttonText: AppLocalizations.of(context)
                                            .doneTitle,
                                        callBackFunction: () {
                                          Navigator.of(context).pop();
                                        },
                                        buttonColor:
                                            Theme.of(context).primaryColor),
                              );
                              blockOrUnBlockLoading = false;
                              setState(() {});
                            } on GetRequestException catch (error) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) =>
                                    FeedBackDialog(
                                        titleText: error.toStringMessage(),
                                        gif: 'assets/gifs/fail.json',
                                        enableButton: true,
                                        buttonText: AppLocalizations.of(context)
                                            .doneTitle,
                                        callBackFunction: () {
                                          Navigator.of(context).pop();
                                        },
                                        buttonColor: Colors.redAccent),
                              );

                              setState(() {
                                blockOrUnBlockLoading = false;
                              });
                            } on SocketException {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) =>
                                    FeedBackDialog(
                                        titleText: AppLocalizations.of(context)
                                            .connectionStatusMessage,
                                        gif: 'assets/gifs/fail.json',
                                        enableButton: true,
                                        buttonText: AppLocalizations.of(context)
                                            .doneTitle,
                                        callBackFunction: () {
                                          Navigator.of(context).pop();
                                        },
                                        buttonColor: Colors.redAccent),
                              );

                              setState(() {
                                blockOrUnBlockLoading = false;
                              });
                            } catch (error) {
                              showToast(
                                  AppLocalizations.of(context)
                                      .somethingWentWrong,
                                  context);
                            }
                          },
                          pickedMember.isBlocked == true
                              ? Colors.green
                              : Colors.redAccent,
                          pickedMember.isBlocked == true
                              ? AppLocalizations.of(context).unblockMember
                              : AppLocalizations.of(context).blockMember,
                        ),

                  const SizedBox(
                    height: 30,
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
