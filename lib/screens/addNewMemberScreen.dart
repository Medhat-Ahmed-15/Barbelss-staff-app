// ignore_for_file: file_names

import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/screens/addNewMemberScreenP2.dart';
import 'package:gym_staff_app/screens/plansScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/widgets/feedBackDialog.dart';
import 'package:gym_staff_app/widgets/qrCodeDialog.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddNewMemberScreen extends StatefulWidget {
  static const routeName = '/AddNewMemberScreen';

  @override
  State<AddNewMemberScreen> createState() => _AddNewMemberScreenState();
}

class _AddNewMemberScreenState extends State<AddNewMemberScreen> {
  bool loading = false;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final membershipController = TextEditingController();

  String emialErrorText = '';
  String errortext = '';
  String nameErrorText = '';
  String phoneErrorText = '';
  String membershipErrorText = '';
  String phonehHintText = '+20';
  String countryFlag = '🇪🇬';
  String phoneCode = '20';
  bool isAuthenticate = false;

  FocusNode emailFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode membershipFocusNode = FocusNode();

  Future<void> checkData(BuildContext context) async {
    try {
      setState(() {
        loading = true;
      });

      if (nameController.text.isEmpty) {
        setState(() {
          nameErrorText = AppLocalizations.of(context).memberNameIsrequired;
          phoneErrorText = null;
          emialErrorText = null;
          loading = false;
        });

        return;
      }

      if (nameController.text.trim().split(" ").length != 2) {
        setState(() {
          nameErrorText = 'You must write your first and second name';
          phoneErrorText = null;
          emialErrorText = null;
          loading = false;
        });

        return;
      }

      await getAllMembersFromStorage();

      if (emailController.text.trim().isNotEmpty) {
        var result = checkEmailIsUnique(emailController.text.trim());

        if (result == false) {
          setState(() {
            phoneErrorText = null;
            nameErrorText = null;
            loading = false;
            emialErrorText = 'This email is already used';
          });

          return;
        }
      }

      if (phoneController.text.isEmpty) {
        setState(() {
          phoneErrorText = AppLocalizations.of(context).phoneNumberIsRequired;
          nameErrorText = null;
          loading = false;
          emialErrorText = null;
        });

        return;
      }

      if (phoneController.text.length != 10) {
        setState(() {
          phoneErrorText = 'Phone number must be 10 digit';
          nameErrorText = null;
          loading = false;
          emialErrorText = null;
        });

        return;
      }

      var result = checkPhoneIsUnique(phoneController.text.trim());

      if (result == false) {
        setState(() {
          phoneErrorText = 'This phone number is already used';
          nameErrorText = null;
          loading = false;
          emialErrorText = null;
        });

        return;
      }

      print('PHONEEEE CODEEE::: ${phoneCode}');

      await checkAddedNewMemberData(
          context: context,
          email: emailController.text.trim(),
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          phoneCode: phoneCode);

      addedName = nameController.text.trim();
      addedEmail = emailController.text.trim();
      addedMembership = membershipController.text.trim();
      addedPhone = phoneController.text.trim();
      addedPhoneCode = phoneCode;
      addedVerifyMember = isAuthenticate;

      print('PHONEEEE CODEEE::: ${addedPhoneCode}');

      setState(() {
        loading = false;
      });

      Navigator.pushNamed(context, AddNewMemberScreenP2.routeName);
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

      print('Entered GetRequestException');

      if (addNewMemberFieldKey == 'phone') {
        setState(() {
          phoneErrorText = errorMessage;
          nameErrorText = null;
          emialErrorText = null;
          errortext = '';
          loading = false;
        });
      } else if (addNewMemberFieldKey == 'countryCode') {
        setState(() {
          errortext = errorMessage;
          phoneErrorText = null;
          nameErrorText = null;
          emialErrorText = null;

          loading = false;
        });
      } else if (addNewMemberFieldKey == 'name') {
        setState(() {
          nameErrorText = errorMessage;
          emialErrorText = null;
          phoneErrorText = null;
          errortext = '';
          loading = false;
        });
      } else if (addNewMemberFieldKey == 'email') {
        setState(() {
          emialErrorText = errorMessage;
          nameErrorText = null;
          phoneErrorText = null;
          errortext = '';
          loading = false;
        });
      } else {
        setState(() {
          errortext = errorMessage;
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    membershipController.dispose();
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 100, right: 15, bottom: 50),
                  child: Text(
                    AppLocalizations.of(context).addANewMemberTitle,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline2.color,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                //Name ******************
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
                  child: TextField(
                    controller: nameController,
                    onTap: () {
                      setState(() {
                        nameErrorText = '';
                      });
                    },
                    focusNode: nameFocusNode,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: nameFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.black54,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: nameFocusNode.hasFocus
                              ? Theme.of(context).primaryColor
                              : Colors.black54,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: nameFocusNode.hasFocus
                              ? Theme.of(context).primaryColor
                              : Colors.black54,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      labelText: AppLocalizations.of(context).nameHint,
                      errorText: nameErrorText == '' ? null : nameErrorText,
                      labelStyle: TextStyle(
                        color: nameFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.black54,
                      ),
                    ),
                  ),
                ),

                //Email TextField
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
                  child: TextField(
                    controller: emailController,
                    onTap: () {
                      setState(() {
                        emialErrorText = '';
                      });
                    },
                    focusNode: emailFocusNode,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: emailFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.black54,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: emailFocusNode.hasFocus
                              ? Theme.of(context).primaryColor
                              : Colors.black54,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: emailFocusNode.hasFocus
                              ? Theme.of(context).primaryColor
                              : Colors.black54,
                        ),
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
                      errorText: emialErrorText == '' ? null : emialErrorText,
                      hintText: AppLocalizations.of(context).optionalTitle,
                      labelStyle: TextStyle(
                        color: emailFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.black54,
                      ),
                    ),
                  ),
                ),

                //Membership TextField
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: TextField(
                    controller: membershipController,
                    onTap: () {
                      setState(() {
                        membershipErrorText = '';
                      });
                    },
                    focusNode: membershipFocusNode,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    cursorColor: Theme.of(context).primaryColor,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.assignment_ind_rounded,
                        color: membershipFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.black54,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: membershipFocusNode.hasFocus
                              ? Theme.of(context).primaryColor
                              : Colors.black54,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: membershipFocusNode.hasFocus
                              ? Theme.of(context).primaryColor
                              : Colors.black54,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      labelText: AppLocalizations.of(context).membership,
                      hintText: 'ex: 19203...',
                      errorText: membershipErrorText == ''
                          ? null
                          : membershipErrorText,
                      labelStyle: TextStyle(
                        color: membershipFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.black54,
                      ),
                    ),
                  ),
                ),

                //phone textfield************************************************************************************

                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          obscureText: false,
                          onTap: () {
                            setState(() {
                              phoneErrorText = '';
                            });
                          },
                          focusNode: phoneFocusNode,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          cursorColor: Theme.of(context).primaryColor,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color: phoneFocusNode.hasFocus
                                  ? Theme.of(context).primaryColor
                                  : Colors.black54,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: phoneFocusNode.hasFocus
                                    ? Theme.of(context).primaryColor
                                    : Colors.black54,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: phoneFocusNode.hasFocus
                                    ? Theme.of(context).primaryColor
                                    : Colors.black54,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.redAccent,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            labelText: AppLocalizations.of(context).phoneHint,
                            hintText: phonehHintText,
                            errorText:
                                phoneErrorText == '' ? null : phoneErrorText,
                            labelStyle: TextStyle(
                              color: phoneFocusNode.hasFocus
                                  ? Theme.of(context).primaryColor
                                  : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                            exclude: <String>['IL'],
                            favorite: <String>['EG'],
                            //Optional. Shows phone code before the country name.
                            showPhoneCode: true,
                            onSelect: (Country country) {
                              setState(() {
                                countryFlag = country.flagEmoji;
                                phonehHintText = '+${country.phoneCode}';
                                phoneCode = country.phoneCode;
                              });
                            },
                            // Optional. Sets the theme for the country list picker.
                            countryListTheme: CountryListThemeData(
                              inputDecoration: InputDecoration(
                                prefixIcon: Icon(Icons.search,
                                    color: Theme.of(context).primaryColor),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.redAccent),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                ),
                                labelText: 'Search',
                                labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Optional. Sets the border radius for the bottomsheet.
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40.0),
                                topRight: Radius.circular(40.0),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          countryFlag,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, right: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${AppLocalizations.of(context).verifymember}: ',
                        style: const TextStyle(fontSize: 17.0),
                      ),
                      Switch(
                        onChanged: (bool value) {
                          setState(() {
                            isAuthenticate = value;
                          });
                        },
                        value: isAuthenticate,
                        activeColor: Theme.of(context).scaffoldBackgroundColor,
                        activeTrackColor: Theme.of(context).primaryColor,
                        inactiveThumbColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        inactiveTrackColor: Colors.grey[300],
                      )
                    ],
                  ),
                ),

                // //error text
                errortext != ''
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, top: 15, bottom: 50),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            errortext,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                          ),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15, top: 15, bottom: 50),
                        child: SizedBox(height: 0),
                      ),

                Padding(
                  padding: const EdgeInsets.only(left: 22, right: 22),
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
                              await checkData(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                              ),
                              child: Text(
                                AppLocalizations.of(context).next,
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
    );
  }
}
