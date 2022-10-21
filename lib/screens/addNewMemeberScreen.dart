import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/screens/plansScreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../Exceptions/getRequest_exception.dart';
import '../assistant/assistantFunction.dart';
import '../widgets/feedBackDialog.dart';
import '../widgets/qrCodeDialog.dart';

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

  bool isAuthenticate = false;
  bool maleChosen = false;
  bool femaleChosen = false;
  bool responseFomQrDialog = true;
  bool loading = false;

  FocusNode emailFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode membershipFocusNode = FocusNode();
  FocusNode ageFocusNode = FocusNode();

  int currentStep = 0;
  bool complete = false;
  StepperType stepperType = StepperType.vertical;

  next() {
    currentStep + 1 != 5
        ? goTo(currentStep + 1)
        : setState(() {
            complete = true;
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
      if (nameController.text.isEmpty) {
        setState(() {
          nameErrorText = AppLocalizations.of(context).memberNameIsrequired;
          phoneErrorText = '';
          emailErrorText = '';
          ageErrorText = '';
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
          loading = false;
          currentStep = 0;
        });

        return;
      }

      if (ageController.text.isEmpty) {
        setState(() {
          ageErrorText = AppLocalizations.of(context).ageMustBeSpecified;
          phoneErrorText = '';
          nameErrorText = '';
          loading = false;
          emailErrorText = '';
          currentStep = 0;
        });

        return;
      }

      if (phoneController.text.isEmpty) {
        setState(() {
          phoneErrorText = AppLocalizations.of(context).phoneNumberIsRequired;
          nameErrorText = '';
          ageErrorText = '';
          loading = false;
          emailErrorText = '';
          currentStep = 0;
        });

        return;
      }

      if (phoneController.text.length != 10) {
        setState(() {
          phoneErrorText =
              AppLocalizations.of(context).phoneNumberMustBe10Digit;
          nameErrorText = '';
          loading = false;
          ageErrorText = '';
          emailErrorText = '';
          currentStep = 0;
        });

        return;
      }

      if (isAuthenticate == true) {
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
            email: emailController.text,
            gender: gender,
            name: nameController.text,
            age: int.parse(ageController.text),
            phone: phoneController.text,
            isAuthenticate: isAuthenticate,
            phoneCode: phoneCode);

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
        isAuthenticate = false;
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

      if (addNewMemberFieldKey == 'phone') {
        setState(() {
          phoneErrorText = errorMessage;
          nameErrorText = '';
          emailErrorText = '';
          ageErrorText = '';
          genderErrorText = '';
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
          currentStep = 0;
          ageErrorText = '';
          loading = false;
        });
      } else if (addNewMemberFieldKey == 'email') {
        print("catch email:::   $errorMessage ");

        setState(() {
          emailErrorText = errorMessage;
          nameErrorText = '';
          phoneErrorText = '';
          ageErrorText = '';
          genderErrorText = '';
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
          currentStep = 0;
          loading = false;
        });
      } else if (addNewMemberFieldKey == 'gender') {
        setState(() {
          ageErrorText = '';
          emailErrorText = '';
          nameErrorText = '';
          phoneErrorText = '';
          genderErrorText = errorMessage;
          currentStep = 1;
          loading = false;
        });
      } else {
        setState(() {
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
    ageController.dispose();
  }

  List<Step> steps(BuildContext context) {
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
            TextField(
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
            // //Email
            TextField(
              controller: emailController,
              onTap: () {
                setState(() {
                  emailErrorText = '';
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
                errorText: emailErrorText == '' ? null : emailErrorText,
                hintText: AppLocalizations.of(context).optionalTitle,
                labelStyle: TextStyle(
                  color: emailFocusNode.hasFocus
                      ? Theme.of(context).primaryColor
                      : Colors.black54,
                ),
              ),
            ),

            //Age
            TextField(
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
                prefixIcon: Icon(
                  Icons.numbers,
                  color: ageFocusNode.hasFocus
                      ? Theme.of(context).primaryColor
                      : Colors.black54,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: ageFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.black54,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: ageFocusNode.hasFocus
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
                labelText: AppLocalizations.of(context).age,
                errorText: ageErrorText == '' ? null : ageErrorText,
                labelStyle: TextStyle(
                  color: ageFocusNode.hasFocus
                      ? Theme.of(context).primaryColor
                      : Colors.black54,
                ),
              ),
            ),
            //Phone
            Row(
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
                      errorText: phoneErrorText == '' ? null : phoneErrorText,
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
                                color: maleChosen == true
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).primaryColor,
                                width: maleChosen == true ? 5 : 1),
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
                                color: femaleChosen == true
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).primaryColor,
                                width: femaleChosen == true ? 5 : 1),
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
      //Membership TextField
      Step(
        title: Text(AppLocalizations.of(context).memberId,
            style: TextStyle(
                color: Theme.of(context).textTheme.headline2.color,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        isActive: true,
        state: StepState.indexed,
        content: TextField(
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
            errorText: membershipErrorText == '' ? null : membershipErrorText,
            labelStyle: TextStyle(
              color: membershipFocusNode.hasFocus
                  ? Theme.of(context).primaryColor
                  : Colors.black54,
            ),
          ),
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
        content: Row(
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
              inactiveThumbColor: Theme.of(context).scaffoldBackgroundColor,
              inactiveTrackColor: Colors.grey[300],
            )
          ],
        ),
      ),
    ];

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
                    accentColor: Theme.of(context).primaryColor,
                    primarySwatch: primaryColor,
                    colorScheme: ColorScheme.light(
                        primary: Theme.of(context).primaryColor)),
                child: Stepper(
                  steps: steps(context),
                  type: stepperType,
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
