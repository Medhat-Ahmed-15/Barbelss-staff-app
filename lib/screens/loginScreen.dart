// ignore_for_file: file_names

import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/providers/auth_provider.dart';
import 'package:gym_staff_app/providers/localLanguageProvider.dart';
import 'package:gym_staff_app/screens/forgotPassword_screen.dart';
import 'package:gym_staff_app/widgets/feedBackDialog.dart';
import 'package:provider/provider.dart';

import '../globalVariables.dart';
import '../widgets/FourDotsLoading.dart';

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
  double containerheight = 500;
  bool isInit = true;

  Future<void> login(BuildContext context) async {
    if (phoneController.text.trim().isEmpty) {
      setState(() {
        phoneErrorMessage = AppLocalizations.of(context).phoneNumberIsRequired;
        passwordErrorMessage = null;
      });
      return;
    }
    if (passwordController.text.trim().isEmpty) {
      setState(() {
        passwordErrorMessage = AppLocalizations.of(context).passwordIsRequired;
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
          passwordErrorMessage = '';

          loading = false;
        });
      } else {
        setState(() {
          passwordErrorMessage = errorMessage;
          phoneErrorMessage = '';
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
    } catch (error) {
      showToast(AppLocalizations.of(context).somethingWentWrong, context);

      setState(() {
        loadingScreen = false;
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
      showToast(AppLocalizations.of(context).somethingWentWrong, context);

      setState(() {
        loadingScreen = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (isInit == true) {
      Fluttertoast.showToast(
          msg:
              ' \n \n Screen Width:  ${MediaQuery.of(context).size.width} \n \n Screen Height:  ${MediaQuery.of(context).size.height}  \n \n',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 20.0);

      isInit = false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }

  Widget textField({
    bool passwordText,
    String textFieldName,
    TextEditingController controller,
    TextInputType keyboardType,
    FocusNode focusNode,
    IconData prefixIcon,
    Widget sufixIcon,
    String labelText,
    String hintText,
    String errorText,
  }) {
    return TextField(
      obscureText: passwordText,
      keyboardType:
          textFieldName == 'phone' ? TextInputType.phone : TextInputType.text,
      controller: controller,
      onTap: () {
        setState(() {
          textFieldName == 'phone'
              ? phoneErrorMessage = ''
              : passwordErrorMessage = '';
        });
      },
      focusNode: focusNode,
      style: TextStyle(
        color: Theme.of(context).textTheme.headline2.color,
      ),
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        suffixIcon: sufixIcon,
        prefixIcon: Icon(prefixIcon,
            color: focusNode.hasFocus
                ? Theme.of(context).primaryColor
                : Colors.black54),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: focusNode.hasFocus
                  ? Theme.of(context).primaryColor
                  : Colors.black54),
          borderRadius: const BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: focusNode.hasFocus
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
        labelText: labelText,
        errorText: errorText == '' ? null : errorText,
        labelStyle: TextStyle(
          color: focusNode.hasFocus
              ? Theme.of(context).primaryColor
              : Colors.black54,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      setState(() {
        containerheight = 600;
      });
    } else {
      setState(() {
        containerheight = 500;
      });
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: containerheight,
                padding: const EdgeInsets.only(top: 50, left: 8, right: 8),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(206, 206, 206, 1),
                      offset: Offset(1, 3),
                      blurRadius: 1.0,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Phone TextField
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child:
                              //phone textField

                              textField(
                                  controller: phoneController,
                                  errorText: phoneErrorMessage,
                                  focusNode: phoneFocusNode,
                                  hintText: '$phonehHintText ex: 1282923670',
                                  keyboardType: TextInputType.phone,
                                  labelText:
                                      AppLocalizations.of(context).phoneTitle,
                                  passwordText: false,
                                  prefixIcon: Icons.phone,
                                  sufixIcon: null,
                                  textFieldName: 'phone'),
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

                    const SizedBox(
                      height: 20,
                    ),

                    //Password TextField
                    textField(
                        controller: passwordController,
                        errorText: passwordErrorMessage,
                        focusNode: passwordFocusNode,
                        hintText: '',
                        keyboardType: TextInputType.text,
                        labelText: AppLocalizations.of(context).passwordTitle,
                        passwordText: obscureText,
                        prefixIcon: Icons.lock,
                        sufixIcon: IconButton(
                          icon: const Icon(Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          color: passwordFocusNode.hasFocus
                              ? Theme.of(context).primaryColor
                              : Colors.black54,
                        ),
                        textFieldName: 'password'),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          AppLocalizations.of(context).forgetPasswordTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ForgotPasswordScreen.routeName);
                      },
                    ),

                    const SizedBox(
                      height: 80,
                    ),
                    loading == true
                        ? FourDotsLoading()
                        : Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 56,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor),
                                    overlayColor: MaterialStateProperty.all(
                                        Theme.of(context)
                                            .scaffoldBackgroundColor),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
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
            Positioned(
              top: 100,
              left: localeLanguage == const Locale('en') ? 15 : 0,
              right: localeLanguage != const Locale('en') ? 15 : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/b8.png',
                        height: 50,
                        width: 50,
                      ),
                      Text(
                        AppLocalizations.of(context).appName,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    AppLocalizations.of(context).loginSubtitleOne,
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: localeLanguage == const Locale('en') ? 15 : 20,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).loginSubtitleTwo,
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: localeLanguage == const Locale('en') ? 15 : 20,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
