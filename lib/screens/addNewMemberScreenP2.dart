// ignore_for_file: file_names

import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/screens/plansScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/widgets/feedBackDialog.dart';
import 'package:gym_staff_app/widgets/qrCodeDialog.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddNewMemberScreenP2 extends StatefulWidget {
  static const routeName = '/AddNewMemberScreenP2';

  @override
  State<AddNewMemberScreenP2> createState() => _AddNewMemberScreenP2State();
}

class _AddNewMemberScreenP2State extends State<AddNewMemberScreenP2> {
  bool loading = false;

  final ageController = TextEditingController();

  String ageErrorText = '';

  String errortext = '';
  String gender = '';
  bool maleChosen = false;
  bool femaleChosen = false;
  bool responseFomQrDialog = true;

  FocusNode ageFocusNode = FocusNode();

  Future<void> registerMember(BuildContext context) async {
    try {
      if (gender == '') {
        setState(() {
          errortext = 'Please specify a gender';
        });
        return;
      }
      setState(() {
        loading = true;
      });

      if (addedVerifyMember == true) {
        responseFomQrDialog = await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) => QrCodeDialog(
            addedName,
            addedEmail,
            addedPhone,
            context,
          ),
        );
      }
      if (responseFomQrDialog == true) {
        await addNewMember(
            context: context,
            email: addedEmail,
            gender: gender,
            name: addedName,
            age: int.parse(ageController.text),
            phone: addedPhone,
            isAuthenticate: addedVerifyMember,
            phoneCode: addedPhoneCode);

        print('PHONEEEE CODEEE::: ${addedPhoneCode}');

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => FeedBackDialog(
              titleText:
                  AppLocalizations.of(context).memberAddedSuccessfullyTitle,
              gif: 'assets/gifs/success.json',
              enableButton: true,
              buttonText: AppLocalizations.of(context).enrollNowTitle,
              callBackFunction: () {
                Navigator.of(context).pushNamed(
                  PlansScreen.routeName,
                );
              },
              buttonColor: Theme.of(context).primaryColor),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) => FeedBackDialog(
              titleText: 'Something went wrong',
              gif: 'assets/gifs/fail.json',
              enableButton: true,
              buttonText: AppLocalizations.of(context).doneTitle,
              callBackFunction: () {
                Navigator.of(context).pop();
              },
              buttonColor: Colors.redAccent),
        );
      }

      setState(() {
        loading = false;
      });
    } on SocketException catch (error) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => FeedBackDialog(
            titleText: error.toString(),
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
    } on GetRequestException catch (error) {
      var errorMessage = error.toStringMessage();
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => FeedBackDialog(
            titleText: errorMessage,
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // appBar: AppBar(
      //   title: Text('Add a new member 🚀'),
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 100, bottom: 50, right: 15),
                  child: Text(
                    AppLocalizations.of(context).moreMemberDetails,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline2.color,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                  child: Text(
                    AppLocalizations.of(context).gender,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: InkWell(
                            onTap: () {
                              gender = 'male';

                              setState(() {
                                femaleChosen = false;
                                maleChosen = true;
                              });
                            },
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  border: Border.all(
                                      color: maleChosen == true
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).primaryColor,
                                      width: maleChosen == true ? 5 : 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black54,
                                        offset: Offset(0, 4),
                                        blurRadius: 2.0)
                                  ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/male.png',
                                    width: 150,
                                    height: 150,
                                  ),
                                  Text(AppLocalizations.of(context).male)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: InkWell(
                            onTap: () {
                              gender = 'female';
                              setState(() {
                                femaleChosen = true;
                                maleChosen = false;
                              });
                            },
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  border: Border.all(
                                      color: femaleChosen == true
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).primaryColor,
                                      width: femaleChosen == true ? 5 : 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black54,
                                        offset: Offset(0, 4),
                                        blurRadius: 2.0)
                                  ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/female.png',
                                    width: 150,
                                    height: 150,
                                  ),
                                  Text(AppLocalizations.of(context).female)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                  child: Text(
                    AppLocalizations.of(context).membersAge,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 50),
                  child: TextField(
                    controller: ageController,
                    onTap: () {
                      setState(() {
                        ageErrorText = '';
                      });
                    },
                    focusNode: ageFocusNode,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ageFocusNode.hasFocus
                              ? Theme.of(context).primaryColor
                              : Colors.black54,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ageFocusNode.hasFocus
                              ? Theme.of(context).primaryColor
                              : Colors.black54,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      labelText: AppLocalizations.of(context).age,
                      errorText: ageErrorText == '' ? null : ageErrorText,
                      labelStyle: TextStyle(
                        color: ageFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.black54,
                      ),
                    ),
                  ),
                ),

                // //error text
                errortext != ''
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, bottom: 50),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            errortext,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                          ),
                        ),
                      )
                    : const SizedBox(height: 0),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 22, right: 22, bottom: 30),
                  child: loading == true
                      ? Center(
                          child: LoadingAnimationWidget.fourRotatingDots(
                            color: Theme.of(context).primaryColor,
                            size: 50,
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 56,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                  const TextStyle(fontSize: 18.0),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor),
                                shadowColor: MaterialStateProperty.all(
                                    Theme.of(context).scaffoldBackgroundColor),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ))),
                            onPressed: () async {
                              await registerMember(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                              ),
                              child: Text(
                                AppLocalizations.of(context).addMemberTitle,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .color,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
            // Positioned(
            //   bottom: -100,
            //   child: ClipPath(
            //     clipper: HexagonalClipper(reverse: true),
            //     child: Container(
            //       height: 300,
            //       width: MediaQuery.of(context).size.width,
            //       decoration: BoxDecoration(
            //         color: Theme.of(context).primaryColor,
            //       ),
            //     ),
            //   ),
            // ),
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
          ],
        ),
      ),
    );
  }
}
