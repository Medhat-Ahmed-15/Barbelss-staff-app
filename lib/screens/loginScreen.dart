// ignore_for_file: file_names

import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/providers/auth_provider.dart';
import 'package:gym_staff_app/providers/localLanguageProvider.dart';
import 'package:gym_staff_app/screens/forgotPassword_screen.dart';
import 'package:gym_staff_app/widgets/dialogs/feedBackDialog.dart';
import 'package:gym_staff_app/widgets/dialogs/policyDialog.dart';
import 'package:gym_staff_app/widgets/dialogs/qrCodeDialog.dart';
import 'package:gym_staff_app/widgets/other/FourDotsLoading.dart';
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
  double containerheight;
  double titleHeight;
  bool isInit = true;

  Future<void> login(BuildContext context) async {
    if (phoneController.text.trim().isEmpty) {
      setState(() {
        phoneErrorMessage = AppLocalizations.of(context).phoneNumberIsRequired;
        passwordErrorMessage = null;
      });
      return;
    }
    if (phoneController.text.trim().isEmpty) {
      setState(() {
        phoneErrorMessage = AppLocalizations.of(context).phoneNumberIsRequired;
        passwordErrorMessage = null;
      });
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
          phoneController.text.substring(1).trim(),
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

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (isInit == true) {
  //     containerheight = MediaQuery.of(context).size.height * 0.6;
  //     titleHeight = MediaQuery.of(context).size.height * 0.1;
  //     Fluttertoast.showToast(
  //         msg:
  //             ' \n \n Screen Width:  ${MediaQuery.of(context).size.width} \n \n Screen Height:  ${MediaQuery.of(context).size.height}  \n \n',
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.CENTER,
  //         backgroundColor: Colors.grey,
  //         textColor: Colors.white,
  //         fontSize: 20.0);

  //     isInit = false;
  //   }
  // }

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
        hintText: hintText,
        labelStyle: TextStyle(
          color: focusNode.hasFocus
              ? Theme.of(context).primaryColor
              : Colors.black54,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget rowWidget(Widget widget1, Widget widget2) {
    return Row(
      mainAxisAlignment: localeLanguage == const Locale('en')
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      children: [
        widget1,
        widget2,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      setState(() {
        containerheight = MediaQuery.of(context).size.height * 0.7;
        titleHeight = 0;
      });
    } else {
      setState(() {
        containerheight = MediaQuery.of(context).size.height * 0.6;
        titleHeight = MediaQuery.of(context).size.height * 0.1;
      });
    }
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.only(top: titleHeight, left: 15),
              child: Column(
                crossAxisAlignment: localeLanguage == const Locale('en')
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  localeLanguage == const Locale('en')
                      ? rowWidget(
                          Image.asset('assets/images/b8.png',
                              height: 50, width: 50),
                          const Text(
                            'arbells',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : rowWidget(
                          const Text(
                            'arbells',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset('assets/images/b8.png',
                              height: 50, width: 50),
                        ),
                  Text(
                    'Manage and track',
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'your member registartions with us',
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: containerheight,
                padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                    hintText:
                                        '$phonehHintText ex: 01 282923670',
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
                          alignment: localeLanguage == const Locale('en')
                              ? Alignment.topRight
                              : Alignment.topLeft,
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

                      SizedBox(
                        height:
                            MediaQuery.of(context).size.height < 700 ? 10 : 60,
                      ),
                      loading == true
                          ? FourDotsLoading()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 20),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 56,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Theme.of(context).primaryColor),
                                      overlayColor: MaterialStateProperty.all(
                                          Theme.of(context)
                                              .scaffoldBackgroundColor),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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

                      Padding(
                          padding: const EdgeInsets.only(bottom: 22),
                          child: InkWell(
                            onTap: () {},
                            child: RichText(
                              textAlign: TextAlign.center,

                              // Whether the text should break at soft line breaks
                              softWrap: true,

                              // Maximum number of lines for the text to span
                              maxLines: 4,

                              text: TextSpan(
                                text:
                                    'By logging into the application, you are agreeing to our\n',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                      text: 'Terms and Conditions ',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (BuildContext context) =>
                                                  PolicyDialog(
                                                      mdFileName:
                                                          'terms_and_conditions.md'));
                                        }),
                                  const TextSpan(
                                    text: 'and ',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (BuildContext context) =>
                                                  PolicyDialog(
                                                      mdFileName:
                                                          'privacy_policy.md'));
                                        }),
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
