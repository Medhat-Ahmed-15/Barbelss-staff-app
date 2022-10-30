import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/screens/plansScreen.dart';
import 'package:gym_staff_app/widgets/dialogs/qrCodeDialog.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Exceptions/getRequest_exception.dart';
import '../assistant/assistantFunction.dart';
import '../widgets/dialogs/feedBackDialog.dart';

class AddNewMemberScreen extends StatefulWidget {
  static const routeName = '/AddNewMemberScreen';
  @override
  State<AddNewMemberScreen> createState() => _AddNewMemberScreenState();
}

class _AddNewMemberScreenState extends State<AddNewMemberScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final membershipController = TextEditingController();
  final ageController = TextEditingController();

  String emailErrorText = '';
  String nameErrorText = '';
  String phoneErrorText = '';
  String ageErrorText = '';
  String genderErrorText = '';
  String membershipErrorText = '';
  String phonehHintText = '+20';
  String countryFlag = '🇪🇬';
  String phoneCode = '20';
  String gender = '';
  String whatsAppMessageLang = 'en';

  bool isAuthenticate = true;
  bool maleChosen = false;
  bool femaleChosen = false;
  bool arabicChosen = false;
  bool englishChosen = true;
  bool responseFomQrDialog = true;
  bool loading = false;

  FocusNode emailFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode membershipFocusNode = FocusNode();
  FocusNode ageFocusNode = FocusNode();

  int currentStep = 0;

  Widget textField({
    String textFieldName,
    TextEditingController controller,
    TextInputType keyboardType,
    FocusNode focusNode,
    IconData prefixIcon,
    String labelText,
    String hintText,
    String errorText,
  }) {
    return TextField(
      controller: controller,
      onTap: () {
        if (textFieldName == 'name') {
          setState(() {
            nameErrorText = '';
          });
        } else if (textFieldName == 'email') {
          setState(() {
            emailErrorText = '';
          });
        } else if (textFieldName == 'age') {
          setState(() {
            ageErrorText = '';
          });
        } else if (textFieldName == 'membership') {
          setState(() {
            membershipErrorText = '';
          });
        } else {
          setState(() {
            phoneErrorText = '';
          });
        }
      },
      focusNode: focusNode,
      style: TextStyle(color: Theme.of(context).primaryColor),
      cursorColor: Theme.of(context).primaryColor,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIcon,
          color: focusNode.hasFocus
              ? Theme.of(context).primaryColor
              : Colors.black54,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: focusNode.hasFocus
                ? Theme.of(context).primaryColor
                : Colors.black54,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: focusNode.hasFocus
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
        labelText: labelText,
        hintText: hintText,
        errorText: errorText == '' ? null : errorText,
        labelStyle: TextStyle(
          color: focusNode.hasFocus
              ? Theme.of(context).primaryColor
              : Colors.black54,
        ),
      ),
    );
  }

  next() {
    currentStep + 1 != (currentStaffData.hasMembership == true ? 4 : 3)
        ? goTo(currentStep + 1)
        : setState(() {
            currentStep = 0;
          });
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() {
      currentStep = step;
    });
  }

  Future<void> registerMember(BuildContext context) async {
    responseFomQrDialog = true;
    try {
      setState(() {
        loading = true;
      });
      if (nameController.text.trim().isEmpty) {
        setState(() {
          nameErrorText = AppLocalizations.of(context).memberNameIsrequired;
          phoneErrorText = '';
          emailErrorText = '';
          ageErrorText = '';
          membershipErrorText = '';
          loading = false;
          currentStep = 0;
        });

        return;
      }

      if (nameController.text.trim().split(" ").length != 2) {
        setState(() {
          nameErrorText = AppLocalizations.of(context).writeFirstAndSecondName;
          phoneErrorText = '';
          emailErrorText = '';
          ageErrorText = '';
          membershipErrorText = '';
          loading = false;
          currentStep = 0;
        });

        return;
      }

      if (ageController.text.trim().isEmpty) {
        setState(() {
          ageErrorText = AppLocalizations.of(context).ageMustBeSpecified;
          phoneErrorText = '';
          nameErrorText = '';
          loading = false;
          emailErrorText = '';
          membershipErrorText = '';
          currentStep = 0;
        });

        return;
      }

      if (phoneController.text.trim().isEmpty) {
        setState(() {
          phoneErrorText = AppLocalizations.of(context).phoneNumberIsRequired;
          nameErrorText = '';
          ageErrorText = '';
          loading = false;
          emailErrorText = '';
          membershipErrorText = '';
          currentStep = 0;
        });

        return;
      }

      if (phoneController.text.substring(1).trim().length != 10) {
        setState(() {
          phoneErrorText = AppLocalizations.of(context).invalidPhoneNumber;
          nameErrorText = '';
          loading = false;
          ageErrorText = '';
          emailErrorText = '';
          membershipErrorText = '';
          currentStep = 0;
        });

        return;
      }

      if (currentStaffData.hasMembership == true &&
          membershipController.text.trim().isEmpty) {
        setState(() {
          nameErrorText = '';
          phoneErrorText = '';
          emailErrorText = '';
          ageErrorText = '';
          membershipErrorText =
              AppLocalizations.of(context).membershipIsRequired;
          loading = false;
          currentStep = 3;
        });

        return;
      }

      if (isAuthenticate == true) {
        await addNewMember(
            context: context,
            email: emailController.text.trim(),
            gender: gender,
            name: nameController.text.trim(),
            age: int.parse(ageController.text.trim()),
            phone: phoneController.text.substring(1).trim(),
            membership: currentStaffData.hasMembership == true
                ? int.parse(membershipController.text.trim())
                : 0,
            phoneCode: phoneCode,
            whatsAppMessageLang: whatsAppMessageLang);

        var response = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => QrCodeDialog(
            nameController.text.trim(),
            emailController.text.trim(),
            phoneController.text.substring(1).trim(),
            context,
          ),
        );

        if (response == true) {
          await updateMemberVerification(
              context: context,
              verificationStatus: isAuthenticate,
              whatsAppMessageLang: whatsAppMessageLang);
        } else {
          setState(() {
            isAuthenticate = false;
          });
        }

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
                Navigator.of(context).pushNamed(PlansScreen.routeName,
                    arguments: 'addMemberScreen');
              },
              buttonColor: Theme.of(context).primaryColor),
        );
      } else {
        await addNewMember(
            context: context,
            email: emailController.text.trim(),
            gender: gender,
            name: nameController.text.trim(),
            age: int.parse(ageController.text.trim()),
            phone: phoneController.text.substring(1).trim(),
            membership: currentStaffData.hasMembership == true
                ? int.parse(membershipController.text.trim())
                : 0,
            phoneCode: phoneCode,
            whatsAppMessageLang: whatsAppMessageLang);

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
                Navigator.of(context).pushNamed(PlansScreen.routeName,
                    arguments: 'addMemberScreen');
              },
              buttonColor: Theme.of(context).primaryColor),
        );
      }

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
    } on GetRequestException catch (error) {
      var errorMessage = error.toStringMessage();

      if (addNewMemberFieldKey == 'phone') {
        setState(() {
          phoneErrorText = errorMessage;
          nameErrorText = '';
          emailErrorText = '';
          ageErrorText = '';
          genderErrorText = '';
          membershipErrorText = '';
          loading = false;
          currentStep = 0;
        });
      } else if (addNewMemberFieldKey == 'countryCode') {
        setState(() {
          phoneErrorText = errorMessage;
          phoneErrorText = '';
          nameErrorText = '';
          emailErrorText = '';
          genderErrorText = '';
          membershipErrorText = '';
          ageErrorText = '';
          currentStep = 0;
          loading = false;
        });
      } else if (addNewMemberFieldKey == 'name') {
        setState(() {
          nameErrorText = errorMessage;
          emailErrorText = '';
          phoneErrorText = '';
          genderErrorText = '';
          membershipErrorText = '';
          currentStep = 0;
          ageErrorText = '';
          loading = false;
        });
      } else if (addNewMemberFieldKey == 'email') {
        setState(() {
          emailErrorText = errorMessage;
          nameErrorText = '';
          phoneErrorText = '';
          ageErrorText = '';
          genderErrorText = '';
          membershipErrorText = '';
          currentStep = 0;
          loading = false;
        });
      } else if (addNewMemberFieldKey == 'age') {
        setState(() {
          ageErrorText = errorMessage;
          emailErrorText = '';
          nameErrorText = '';
          phoneErrorText = '';
          genderErrorText = '';
          membershipErrorText = '';
          currentStep = 0;
          loading = false;
        });
      } else if (addNewMemberFieldKey == 'gender') {
        setState(() {
          ageErrorText = '';
          emailErrorText = '';
          nameErrorText = '';
          phoneErrorText = '';
          membershipErrorText = '';
          genderErrorText = errorMessage;
          currentStep = 1;
          loading = false;
        });
      } else if (addNewMemberFieldKey == 'membership') {
        setState(() {
          ageErrorText = '';
          emailErrorText = '';
          nameErrorText = '';
          phoneErrorText = '';
          membershipErrorText = errorMessage;
          genderErrorText = '';
          currentStep = 3;
          loading = false;
        });
      } else {
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
    } catch (error) {
      setState(() {
        loading = false;
      });
      showToast(AppLocalizations.of(context).somethingWentWrong, context);
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
    ageController.dispose();
  }

  Widget languageButton(
    String textName,
  ) {
    return InkWell(
      onTap: () {
        if (textName == "English") {
          whatsAppMessageLang = 'en';
          setState(() {
            arabicChosen = false;
            englishChosen = true;
          });
        } else {
          whatsAppMessageLang = 'ar';
          setState(() {
            arabicChosen = true;
            englishChosen = false;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 40,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Theme.of(context).primaryColor),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black54, offset: Offset(0, 1), blurRadius: 1.0)
            ],
            color: textName == 'English' && englishChosen == true
                ? Theme.of(context).primaryColor
                : textName == 'العربية' && arabicChosen == true
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).scaffoldBackgroundColor),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            textName,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  List<Step> getSteps(BuildContext context) {
    List<Step> steps = [
      //Name  Email  Phone age******************
      Step(
        title: Text(AppLocalizations.of(context).personalInformation,
            style: TextStyle(
                color: Theme.of(context).textTheme.headline2.color,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: [
            //Name
            textField(
                controller: nameController,
                errorText: nameErrorText,
                focusNode: nameFocusNode,
                hintText: null,
                keyboardType: TextInputType.text,
                labelText: AppLocalizations.of(context).nameHint,
                prefixIcon: Icons.person,
                textFieldName: 'name'),
            //Email
            textField(
                controller: emailController,
                errorText: emailErrorText,
                focusNode: emailFocusNode,
                hintText: AppLocalizations.of(context).optionalTitle,
                keyboardType: TextInputType.text,
                labelText: AppLocalizations.of(context).emailTitle,
                prefixIcon: Icons.email,
                textFieldName: 'email'),
            //Age
            textField(
                controller: ageController,
                errorText: ageErrorText,
                focusNode: ageFocusNode,
                hintText: null,
                keyboardType: TextInputType.number,
                labelText: AppLocalizations.of(context).age,
                prefixIcon: Icons.numbers,
                textFieldName: 'age'),
            //Phone
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: textField(
                      controller: phoneController,
                      errorText: phoneErrorText,
                      focusNode: phoneFocusNode,
                      hintText: '$phonehHintText ex: 01282923670',
                      keyboardType: TextInputType.phone,
                      labelText: AppLocalizations.of(context).phoneHint,
                      prefixIcon: Icons.phone,
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
                            borderSide: BorderSide(color: Colors.redAccent),
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          labelText:
                              AppLocalizations.of(context).searchBarHintTitle,
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
          ],
        ),
      ),
      //gender
      Step(
        isActive: true,
        state: StepState.indexed,
        title: Text(
          AppLocalizations.of(context).gender,
          style: TextStyle(
              color: Theme.of(context).textTheme.headline2.color,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        content: Column(
          children: [
            Row(
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
                            color: Theme.of(context).scaffoldBackgroundColor,
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: maleChosen == true ? 7 : 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
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
                            color: Theme.of(context).scaffoldBackgroundColor,
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: femaleChosen == true ? 7 : 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
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
            const SizedBox(
              height: 10,
            ),
            genderErrorText != ''
                ? Text(
                    genderErrorText,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  )
                : SizedBox(height: 0),
          ],
        ),
      ),
      //Verification************************************************************************************
      Step(
        title: Text(AppLocalizations.of(context).memberVerification,
            style: TextStyle(
                color: Theme.of(context).textTheme.headline2.color,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: [
            ListTile(
              leading: Text(
                '${AppLocalizations.of(context).verifymember}: ',
                style: const TextStyle(fontSize: 17.0),
              ),
              trailing: Switch(
                onChanged: (bool value) {
                  setState(() {
                    isAuthenticate = value;
                  });
                },
                value: isAuthenticate,
                activeColor: Theme.of(context).scaffoldBackgroundColor,
                activeTrackColor: Colors.green,
                inactiveThumbColor: Theme.of(context).scaffoldBackgroundColor,
                inactiveTrackColor: Colors.grey[300],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isAuthenticate == true ? 50 : 0,
              child: ListTile(
                leading: Text(
                  '${AppLocalizations.of(context).languageTitle}:',
                  style: const TextStyle(fontSize: 17.0),
                ),
                title: Row(
                  children: [
                    Expanded(child: Container()),
                    languageButton('English'),
                    Expanded(child: Container()),
                    languageButton('العربية'),
                    Expanded(child: Container()),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ];

    if (currentStaffData.hasMembership == true) {
      steps.add(
        Step(
          title: Text(AppLocalizations.of(context).memberId,
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline2.color,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          isActive: true,
          state: StepState.indexed,
          content: textField(
              controller: membershipController,
              errorText: membershipErrorText,
              focusNode: membershipFocusNode,
              hintText: 'ex: 19203...',
              keyboardType: TextInputType.number,
              labelText: AppLocalizations.of(context).membership,
              prefixIcon: Icons.assignment_ind_rounded,
              textFieldName: 'membership'),
        ),
      );
    }

    return steps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          AppLocalizations.of(context).addANewMemberTitle,
          style: TextStyle(
              color: Theme.of(context).textTheme.headline1.color,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: Theme(
                data: ThemeData(
                    primarySwatch: primaryColor,
                    colorScheme: ColorScheme.light(
                        primary: Theme.of(context).primaryColor)),
                child: Stepper(
                  steps: getSteps(context),
                  currentStep: currentStep,
                  onStepContinue: next,
                  onStepCancel: cancel,
                  onStepTapped: (step) {
                    goTo(step);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 22, right: 22, bottom: 30, top: 50),
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
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
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
                              color:
                                  Theme.of(context).textTheme.headline1.color,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
