// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/widgets/FOurDotsLoading.dart';
import '../assistant/assistantFunction.dart';
import '../widgets/feedBackDialog.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgotPasswordScreen';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool loading = false;

  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  String emailErrorMessage;

  Future<void> sendResetPasswordMail(String email) async {
    if (emailController.text.isEmpty) {
      setState(() {
        emailErrorMessage = AppLocalizations.of(context).emailIsrRequired;
      });
      return;
    }
    try {
      setState(() {
        loading = true;
      });
      await memberForgetPassword(email, context);

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => FeedBackDialog(
            titleText:
                AppLocalizations.of(context).updatedAttendenceSuccessfully,
            gif: 'assets/gifs/success.json',
            enableButton: true,
            buttonText: AppLocalizations.of(context).doneTitle,
            callBackFunction: () {
              Navigator.of(context).pop();
            },
            buttonColor: Theme.of(context).primaryColor),
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
            buttonText: AppLocalizations.of(context).doneTitle,
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
            titleText: AppLocalizations.of(context).connectionStatusMessage,
            gif: 'assets/gifs/fail.json',
            enableButton: true,
            buttonText: AppLocalizations.of(context).doneTitle,
            callBackFunction: () {
              Navigator.of(context).pop();
            },
            buttonColor: Colors.redAccent),
      );

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
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
            AppLocalizations.of(context).forgotYourPassword,
            style: TextStyle(
                color: Theme.of(context).textTheme.headline1.color,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                AppLocalizations.of(context).forgotYourPasswordSubtitle,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.grey[600]),
              ),
              const SizedBox(
                height: 30,
              ),
              //Email TextField
              TextField(
                controller: emailController,
                onTap: () {
                  setState(() {
                    emailErrorMessage = '';
                  });
                },
                focusNode: emailFocusNode,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline2.color,
                ),
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email,
                      color: emailFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.black54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: emailFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.black54),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: emailFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.black54),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  labelText: AppLocalizations.of(context).emailTitle,
                  errorText: emailErrorMessage == '' ? null : emailErrorMessage,
                  labelStyle: TextStyle(
                    color: emailFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              loading == true
                  ? FourDotsLoading()
                  : Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 56,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                              overlayColor: MaterialStateProperty.all(
                                  Theme.of(context).scaffoldBackgroundColor),
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
                              await memberForgetPassword(
                                  emailController.text.trim(), context);
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) =>
                                    FeedBackDialog(
                                        titleText: AppLocalizations.of(context)
                                            .emailIssentSuccessfully,
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
                                loading = false;
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
                                        buttonText: AppLocalizations.of(context)
                                            .doneTitle,
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
                                  AppLocalizations.of(context)
                                      .somethingWentWrong,
                                  context);

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
                              AppLocalizations.of(context).send,
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
        ));
  }
}
