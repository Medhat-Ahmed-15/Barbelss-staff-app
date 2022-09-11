// ignore_for_file: file_names

import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
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

  String emialErrorText = '';
  String errortext = '';
  String nameErrorText = '';
  String phoneErrorText = '';
  String phonehHintText = '+20';
  String countryFlag = '🇪🇬';
  String phoneCode = '20';
  bool isAuthenticate = false;

  FocusNode emailFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();

  Future<void> register(BuildContext context) async {
    try {
      setState(() {
        loading = true;
      });

      if (nameController.text.isEmpty) {
        setState(() {
          nameErrorText = 'Member Name is required';
          phoneErrorText = null;
          emialErrorText = null;
          loading = false;
        });

        return;
      }

      if (phoneController.text.isEmpty) {
        setState(() {
          phoneErrorText = 'Phone number is required';
          nameErrorText = null;
          loading = false;
          emialErrorText = null;
        });

        return;
      }

      // if (phoneController.text.length > 11 ||
      //     phoneController.text.length < 11) {
      //   setState(() {
      //     phoneErrorText = 'Phone number must be 11 digit';
      //     nameErrorText = null;
      //     loading = false;
      //     emialErrorText = null;
      //   });

      //   return;
      // }

      var response = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => QrCodeDialog(
          nameController.text.trim(),
          emailController.text.trim(),
          phoneController.text.trim(),
          context,
        ),
      );

      if (response == true) {
        await addNewMember(
            context: context,
            email: emailController.text.trim(),
            name: nameController.text.trim(),
            phone: phoneController.text.trim(),
            isAuthenticate: isAuthenticate,
            phoneCode: phoneCode);

        showDialog(
          context: context,
          barrierDismissible: true,
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

      print('Entered GetRequestException');

      if (errorMessage == 'phone is required' ||
          errorMessage == 'phone formate is invalid' ||
          errorMessage == 'phone number already registered in the club') {
        setState(() {
          phoneErrorText = errorMessage;
          nameErrorText = null;
          emialErrorText = null;
          errortext = '';
          loading = false;
        });
      } else if (errorMessage == 'country code is required' ||
          errorMessage == 'invalid country Code') {
        setState(() {
          errortext = errorMessage;
          phoneErrorText = null;
          nameErrorText = null;
          emialErrorText = null;

          loading = false;
        });
      } else if (errorMessage == 'invalid name formate' ||
          errorMessage == 'name is required' ||
          errorMessage == 'name must be 2 words') {
        setState(() {
          nameErrorText = errorMessage;
          emialErrorText = null;
          phoneErrorText = null;
          errortext = '';
          loading = false;
        });
      } else if (errorMessage == 'email formate is invalid' ||
          errorMessage == 'email is already registered in the club') {
        setState(() {
          emialErrorText = errorMessage;
          nameErrorText = null;
          phoneErrorText = null;
          errortext = '';
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // appBar: AppBar(
      //   title: Text('Add a new member 🚀'),
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 100, right: 15),
                child: Text(
                  AppLocalizations.of(context).addANewMemberTitle,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(
                height: 50,
              ),

              //Name ******************
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
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

              const SizedBox(
                height: 15,
              ),

              //Email TextField
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
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

              const SizedBox(
                height: 15,
              ),

              //phone textfield************************************************************************************

              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
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
                        style: TextStyle(color: Theme.of(context).primaryColor),
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
                                borderSide: BorderSide(color: Colors.redAccent),
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

              const SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Verify Member: ',
                      style: TextStyle(fontSize: 17.0),
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

              const SizedBox(
                height: 10,
              ),

              // //error text
              errortext != ''
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 15.0, right: 15, top: 15),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          errortext,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    )
                  : const SizedBox(height: 0),

              const SizedBox(
                height: 50,
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
                            await register(context);
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
                                color:
                                    Theme.of(context).textTheme.headline1.color,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              Expanded(child: Container()),
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
                Icons.arrow_back,
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
