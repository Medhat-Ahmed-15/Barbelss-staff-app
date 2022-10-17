// ignore_for_file: file_names
import 'dart:convert';
import 'dart:io';
import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:gym_staff_app/screens/memberPersonalDataScreen.dart';
import 'package:gym_staff_app/screens/plansScreen.dart';
import 'package:gym_staff_app/widgets/feedBackDialog.dart';
import 'package:gym_staff_app/widgets/pickFreezingTimeDialog.dart';
import 'package:gym_staff_app/widgets/scanQrCodeDialog.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart' as lot;
import 'package:flutter/material.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/widgets/memberDetailsScreenWidgets/memberPackageDataTile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vibration/vibration.dart';

import '../widgets/qrCodeDialog.dart';

class MemberDetailsScreen extends StatefulWidget {
  static const routeName = '/MemberDetailsScreen';

  @override
  State<MemberDetailsScreen> createState() => _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends State<MemberDetailsScreen> {
  bool loadingMemberRegistrationsData = true;
  bool connectionError = false;
  bool empty = false;
  bool confirmationLoading = false;
  bool enableConfirming = true;
  bool isInit = true;

  String barcodeData;
  String freezeButtonText = '';

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    try {
      if (isInit == true) {
        await getAllMemberRegistartions();

        if (allMemberRegistrationsList.isEmpty) {
          setState(() {
            loadingMemberRegistrationsData = false;
            connectionError = false;
            empty = true;
          });
        } else {
          setState(() {
            loadingMemberRegistrationsData = false;
            connectionError = false;
            empty = false;
            freezeButtonText = allMemberRegistrationsList[0].isFreezed == false
                ? 'Freeze Package'
                : 'Reactivate';
          });
        }

        isInit = false;
      }
    } on SocketException {
      setState(() {
        connectionError = true;
        loadingMemberRegistrationsData = false;
        empty = false;
      });
    }
  }

  void setBackgroundLoading() {
    setState(() {
      confirmationLoading = true;
    });
  }

  void stopBackgroundLoading() {
    setState(() {
      confirmationLoading = false;
    });
  }

  Future<void> refresh() async {
    try {
      await getAllMemberRegistartions();
      if (allMemberRegistrationsList.isEmpty) {
        setState(() {
          loadingMemberRegistrationsData = false;
          connectionError = false;
          empty = true;
        });
      } else {
        setState(() {
          loadingMemberRegistrationsData = false;
          connectionError = false;
          empty = false;
        });
      }
    } on SocketException {
      setState(() {
        connectionError = true;
        loadingMemberRegistrationsData = false;
        empty = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 270,
                color: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 100),
                  child: connectionError == true
                      ? Column(
                          children: [
                            Expanded(child: Container()),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 250,
                                height: 250,
                                child: lot.LottieBuilder.asset(
                                    'assets/gifs/error.json'),
                              ),
                            ),
                            Text(AppLocalizations.of(context)
                                .connectionStatusMessage),
                            Expanded(child: Container()),
                          ],
                        )
                      : loadingMemberRegistrationsData == true
                          ? Center(
                              child: LoadingAnimationWidget.fourRotatingDots(
                                color: Theme.of(context).primaryColor,
                                size: 50,
                              ),
                            )
                          : empty == true
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      height: 200,
                                      child: lot.LottieBuilder.asset(
                                          'assets/gifs/empty.json'),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 150,
                                      height: 56,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Theme.of(context)
                                                        .scaffoldBackgroundColor),
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.grey[300]),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(18.0),
                                                    side: BorderSide(color: Theme.of(context).primaryColor)))),
                                        onPressed: () async {
                                          Navigator.of(context).pushNamed(
                                            PlansScreen.routeName,
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .enrollNowTitle,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : RefreshIndicator(
                                  color: Theme.of(context).primaryColor,
                                  strokeWidth: 5,
                                  onRefresh: () {
                                    print("enterd refresh 1");
                                    return refresh();
                                  },
                                  child: ListView.separated(
                                    padding: const EdgeInsets.all(0),
                                    itemBuilder: (context, index) {
                                      return MemberPackageDataTile(
                                          allMemberRegistrationsList[index],
                                          refresh,
                                          setBackgroundLoading,
                                          stopBackgroundLoading);
                                    },
                                    itemCount:
                                        allMemberRegistrationsList.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Divider(
                                        thickness: 3,
                                        endIndent: 10,
                                        indent: 10,
                                        color: Colors.grey[400],
                                      );
                                    },
                                  ),
                                ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 150,
            left: 50,
            right: 50,
            child: Container(
              width: 100,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0, 4),
                        blurRadius: 5.0)
                  ],
                  color: Theme.of(context).scaffoldBackgroundColor),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).primaryColor,
                      radius: 45,
                      child: Text(
                        pickedMember.memberName.contains(' ')
                            ? pickedMember.memberName[0].toUpperCase() +
                                pickedMember.memberName
                                    .split(' ')[1][0]
                                    .toUpperCase()
                            : pickedMember.memberName[0].toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline1.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                          size: 16,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          pickedMember.memberName,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline2.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black54,
                              offset: Offset(0, 4),
                              blurRadius: 5.0)
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, MemberPersonalDataScreen.routeName);
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context).showMore,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .color),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
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
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 30,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              onPressed: () async {
                Navigator.of(context).pushNamed(
                  PlansScreen.routeName,
                );
              },
              icon: Icon(
                Icons.add,
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 30,
              ),
            ),
          ),
          confirmationLoading == true
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Theme.of(context).primaryColor,
                      size: 50,
                    ),
                  ),
                  color: Colors.black38,
                )
              : const SizedBox(
                  height: 0,
                ),
        ],
      ),
      floatingActionButton: connectionError == true
          ? Text('')
          : empty == true
              ? Text('')
              : AnimatedFloatingActionButton(
                  fabButtons: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: resendQrCOde(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: cancelArrivalFloatingButton(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: confirmArrivalFLoatingButton(),
                    ),
                  ],
                  colorStartAnimation: Theme.of(context).primaryColor,
                  colorEndAnimation: Theme.of(context).primaryColor,
                  animatedIconData: AnimatedIcons.menu_close,
                ),
    );
  }

//Confirm Arrival /////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget confirmArrivalFLoatingButton() {
    return SizedBox(
      width: 200,
      child: FloatingActionButton.extended(
        heroTag: 'btn3',
        key: UniqueKey(),
        onPressed: () async {
          if (enableConfirming == false) {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) => FeedBackDialog(
                  titleText: 'Sorry you can\'t confirm arrival twice in a row',
                  gif: 'assets/gifs/fail.json',
                  enableButton: true,
                  buttonText: AppLocalizations.of(context).doneTitle,
                  callBackFunction: () {
                    Navigator.of(context).pop();
                  },
                  buttonColor: Colors.redAccent),
            );
            return;
          }

          if (pickedMember.canAuthenticate == true) {
            String value = await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) => ScanQrCodeDialog(),
            );

            if (value == null) {
              print('Null Value');
              return;
            } else {
              print('Value Not Null');
              barcodeData = value;

              if (barcodeData == 'Failed To Scan') {
                print('Entered Failed To Scan');
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) => FeedBackDialog(
                      titleText: barcodeData,
                      gif: 'assets/gifs/fail.json',
                      enableButton: true,
                      buttonText: AppLocalizations.of(context).doneTitle,
                      callBackFunction: () {
                        Navigator.of(context).pop();
                      },
                      buttonColor: Colors.redAccent),
                );
              } else {
                print('Scannned tmam');

                Map decodedBarcodeData = json.decode(barcodeData);

                print('DECODED DATA:: $decodedBarcodeData');

                if (decodedBarcodeData['memberName'] ==
                        pickedMember.memberName &&
                    decodedBarcodeData['memberPhone'] ==
                        pickedMember.memberPhone &&
                    decodedBarcodeData['uuid'] == pickedMember.qrCodeUUID) {
                  try {
                    setState(() {
                      confirmationLoading = true;
                    });
                    await confirmArrival(
                        context: context,
                        registrationId:
                            allMemberRegistrationsList[0].registrationId);

                    confirmationLoading = false;
                    await refresh();
                    enableConfirming = false;

                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) => FeedBackDialog(
                          titleText: AppLocalizations.of(context)
                              .updatedAttendenceSuccessfully,
                          gif: 'assets/gifs/success.json',
                          enableButton: true,
                          buttonText: AppLocalizations.of(context).doneTitle,
                          callBackFunction: () {
                            Navigator.of(context).pop();
                          },
                          buttonColor: Theme.of(context).primaryColor),
                    );
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
                      confirmationLoading = false;
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
                          buttonText: AppLocalizations.of(context).doneTitle,
                          callBackFunction: () {
                            Navigator.of(context).pop();
                          },
                          buttonColor: Colors.redAccent),
                    );

                    setState(() {
                      confirmationLoading = false;
                    });
                  }
                } else {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) => FeedBackDialog(
                        titleText: 'Users Don\'t Match',
                        gif: 'assets/gifs/fail.json',
                        enableButton: true,
                        buttonText: AppLocalizations.of(context).doneTitle,
                        callBackFunction: () {
                          Navigator.of(context).pop();
                        },
                        buttonColor: Colors.redAccent),
                  );
                }
              }
            }
          } else {
            try {
              setState(() {
                confirmationLoading = true;
              });
              await confirmArrival(
                  context: context,
                  registrationId: allMemberRegistrationsList[0].registrationId);

              confirmationLoading = false;
              await refresh();
              enableConfirming = false;

              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) => FeedBackDialog(
                    titleText: AppLocalizations.of(context)
                        .updatedAttendenceSuccessfully,
                    gif: 'assets/gifs/success.json',
                    enableButton: true,
                    buttonText: AppLocalizations.of(context).doneTitle,
                    callBackFunction: () {
                      Navigator.of(context).pop();
                    },
                    buttonColor: Theme.of(context).primaryColor),
              );
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
                confirmationLoading = false;
              });
            } on SocketException {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) => FeedBackDialog(
                    titleText:
                        AppLocalizations.of(context).connectionStatusMessage,
                    gif: 'assets/gifs/fail.json',
                    enableButton: true,
                    buttonText: AppLocalizations.of(context).doneTitle,
                    callBackFunction: () {
                      Navigator.of(context).pop();
                    },
                    buttonColor: Colors.redAccent),
              );

              setState(() {
                confirmationLoading = false;
              });
            }
          }
        },
        label: Text(
          AppLocalizations.of(context).confirmArrivalTitle,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headline1.color),
        ),
        icon: Icon(
          Icons.check_circle,
          color: Theme.of(context).iconTheme.color,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
//Cancel Arrival /////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget cancelArrivalFloatingButton() {
    return SizedBox(
      width: 200,
      child: FloatingActionButton.extended(
          heroTag: 'btn2',
          onPressed: () async {
            try {
              setState(() {
                confirmationLoading = true;
              });
              await cancelAttendence(
                  context: context,
                  registrationId: allMemberRegistrationsList[0].registrationId);

              confirmationLoading = false;
              await refresh();
              enableConfirming = true;

              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) => FeedBackDialog(
                    titleText: AppLocalizations.of(context)
                        .cancelledAttendenceSuccessfully,
                    gif: 'assets/gifs/sad.json',
                    enableButton: true,
                    buttonText: AppLocalizations.of(context).doneTitle,
                    callBackFunction: () {
                      Navigator.of(context).pop();
                    },
                    buttonColor: Theme.of(context).primaryColor),
              );
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
                confirmationLoading = false;
              });
            } on SocketException {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) => FeedBackDialog(
                    titleText:
                        AppLocalizations.of(context).connectionStatusMessage,
                    gif: 'assets/gifs/fail.json',
                    enableButton: true,
                    buttonText: AppLocalizations.of(context).doneTitle,
                    callBackFunction: () {
                      Navigator.of(context).pop();
                    },
                    buttonColor: Colors.redAccent),
              );

              setState(() {
                confirmationLoading = false;
              });
            }
          },
          label: Text(
            AppLocalizations.of(context).cancelArrivalTitle,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headline1.color),
          ),
          icon: Icon(
            Icons.cancel,
            color: Theme.of(context).iconTheme.color,
          ),
          backgroundColor: Colors.redAccent),
    );
  }

//Resend Code  /////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget resendQrCOde() {
    return SizedBox(
      width: localeLanguage == const Locale('en') ? 200 : 300,
      child: FloatingActionButton.extended(
        heroTag: 'btn4',
        key: UniqueKey(),
        onPressed: () async {
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

              showToast('Update Qr Code Successfully', context);
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
          } on SocketException catch (error) {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) => FeedBackDialog(
                  titleText:
                      AppLocalizations.of(context).connectionStatusMessage,
                  gif: 'assets/gifs/fail.json',
                  enableButton: true,
                  buttonText: AppLocalizations.of(context).doneTitle,
                  callBackFunction: () {
                    Navigator.of(context).pop();
                  },
                  buttonColor: Colors.redAccent),
            );
          }
        },
        label: Text(
          AppLocalizations.of(context).resendQrCode,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headline1.color),
        ),
        icon: Icon(
          Icons.qr_code_rounded,
          color: Theme.of(context).iconTheme.color,
        ),
        backgroundColor: Colors.grey,
      ),
    );
  }
//Freeze /////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget freeze() {
    return SizedBox(
      width: 200,
      child: FloatingActionButton.extended(
        heroTag: 'btn5',
        key: UniqueKey(),
        onPressed: () async {
          print('pressed');
          var response = await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => PickFreezingTimeDialog(),
          );
        },
        label: Text(
          freezeButtonText,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headline1.color),
        ),
        icon: Icon(
          Icons.pause_circle_filled_outlined,
          color: Theme.of(context).iconTheme.color,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
