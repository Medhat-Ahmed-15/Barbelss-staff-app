// ignore_for_file: file_names

import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/providers/auth_provider.dart';
import 'package:gym_staff_app/providers/localLanguageProvider.dart';
import 'package:gym_staff_app/widgets/feedBackDialog.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../globalVariables.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode phoneFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool loadingScreen = false;
  bool obscureText = true;

  String phoneErrorMessage = '';
  String passwordErrorMessage = '';
  String phonehHintText = '+20';
  String countryFlag = '🇪🇬';
  String phoneCode = '20';
  bool loading = false;

  Future<void> login(BuildContext context) async {
    if (phoneController.text.trim().isEmpty) {
      setState(() {
        phoneErrorMessage = 'Phone is required';
        passwordErrorMessage = null;
      });
      return;
    }
    if (passwordController.text.trim().isEmpty) {
      setState(() {
        passwordErrorMessage = 'Password is required';
        phoneErrorMessage = null;
      });
      return;
    }

    try {
      setState(() {
        loading = true;
      });
      await Provider.of<AuthProvider>(context, listen: false).userLogin(
          phoneController.text.trim(),
          phoneCode,
          passwordController.text.trim(),
          context);

      setState(() {
        loading = false;
      });
    } on GetRequestException catch (error) {
      var errorMessage = error.toStringMessage();

      if (loginFieldKey == 'phone') {
        setState(() {
          phoneErrorMessage = errorMessage;
          loading = false;
        });
      } else {
        setState(() {
          passwordErrorMessage = errorMessage;
          loading = false;
        });
      }

      setState(() {});
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
  void initState() {
    // TODO: implement initState
    super.initState();

    try {
      setState(() {
        loadingScreen = true;
      });
      getLocalLanguageFromStorage().then((locale) {
        final provider =
            Provider.of<LocaleLanguageProvider>(context, listen: false);

        if (locale == null) {
          setState(() {
            loadingScreen = false;
          });
          localeLanguage = const Locale('en');
          provider.setLocale(localeLanguage);
          return;
        }

        if (locale == 'en') {
          localeLanguage = const Locale('en');
          provider.setLocale(localeLanguage);
        } else if (locale == 'ar') {
          localeLanguage = const Locale('ar');
          provider.setLocale(localeLanguage);
        }

        setState(() {
          loadingScreen = false;
        });
      });
    } catch (error) {
      showToast('Error changing language ', context);

      setState(() {
        loadingScreen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 230, left: 15, right: 15, bottom: 200),
              child: Container(
                padding: const EdgeInsets.only(top: 50, left: 8, right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor,
                      offset: const Offset(10, 15),
                      blurRadius: 1.0,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Phone TextField
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0, right: 22.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              onTap: () {
                                setState(() {
                                  phoneErrorMessage = '';
                                });
                              },
                              focusNode: phoneFocusNode,
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline2.color,
                              ),
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone,
                                    color: phoneFocusNode.hasFocus
                                        ? Theme.of(context).primaryColor
                                        : Colors.black54),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: phoneFocusNode.hasFocus
                                          ? Theme.of(context).primaryColor
                                          : Colors.black54),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: phoneFocusNode.hasFocus
                                          ? Theme.of(context).primaryColor
                                          : Colors.black54),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                ),
                                errorBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.redAccent),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                ),
                                labelText:
                                    AppLocalizations.of(context).phoneTitle,
                                hintText: '$phonehHintText ex: 1282923670',
                                errorText: phoneErrorMessage == ''
                                    ? null
                                    : phoneErrorMessage,
                                labelStyle: TextStyle(
                                  color: phoneFocusNode.hasFocus
                                      ? Theme.of(context).primaryColor
                                      : Colors.black54,
                                  fontWeight: FontWeight.bold,
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
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(30.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
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
                                    labelText: AppLocalizations.of(context)
                                        .searchBarHintTitle,
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
                      height: 20,
                    ),

                    //Password TextField
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0, right: 22.0),
                      child: TextField(
                        obscureText: obscureText,
                        controller: passwordController,
                        onTap: () {
                          setState(() {
                            passwordErrorMessage = '';
                          });
                        },
                        focusNode: passwordFocusNode,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline2.color,
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.remove_red_eye),
                            onPressed: () {
                              setState(() {
                                obscureText = obscureText;
                              });
                            },
                            color: passwordFocusNode.hasFocus
                                ? Theme.of(context).primaryColor
                                : Colors.black54,
                          ),
                          prefixIcon: Icon(Icons.lock,
                              color: passwordFocusNode.hasFocus
                                  ? Theme.of(context).primaryColor
                                  : Colors.black54),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: passwordFocusNode.hasFocus
                                    ? Theme.of(context).primaryColor
                                    : Colors.black54),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: passwordFocusNode.hasFocus
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
                          labelText: AppLocalizations.of(context).passwordTitle,
                          errorText: passwordErrorMessage == ''
                              ? null
                              : passwordErrorMessage,
                          labelStyle: TextStyle(
                            color: passwordFocusNode.hasFocus
                                ? Theme.of(context).primaryColor
                                : Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0, right: 22.0),
                      child: TextButton(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            AppLocalizations.of(context).forgetPasswordTitle,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 250,
                height: 150,
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
                    AppLocalizations.of(context).loginTitle,
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
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
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor),
                            overlayColor: MaterialStateProperty.all(
                                Theme.of(context).scaffoldBackgroundColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ))),
                        onPressed: () async {
                          await login(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Text(
                            AppLocalizations.of(context).loginTitle,
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
        ));
  }
}
