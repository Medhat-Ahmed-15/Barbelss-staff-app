import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart' as lot;

import '../Exceptions/getRequest_exception.dart';
import '../widgets/feedBackDialog.dart';
import '../widgets/memberPackageDetailsScreenWidgets/memberAttendencesDataTile.dart';

class MemberPackageDetailsScreen extends StatefulWidget {
  static const routeName = '/MemberPackageDetailsScreen';

  @override
  State<MemberPackageDetailsScreen> createState() =>
      _MemberPackageDetailsScreenState();
}

class _MemberPackageDetailsScreenState
    extends State<MemberPackageDetailsScreen> {
  bool loadingMemberAttendencesData = true;
  bool connectionError = false;
  bool empty = false;
  String freezeButtonText = '';
  bool confirmationLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    try {
      freezeButtonText = allMemberRegistrationsList[0].isFreezed == false
          ? 'Freeze'
          : 'Reactivate';
      getAllMemberAttendences(pickedMemberPackage.registrationId).then((value) {
        if (allMemberAttendencesList.isEmpty) {
          setState(() {
            loadingMemberAttendencesData = false;
            connectionError = false;
            empty = true;
          });
        } else {
          print('msh empty');
          setState(() {
            loadingMemberAttendencesData = false;
            connectionError = false;
            empty = false;
          });
        }
      });
    } on SocketException {
      setState(() {
        connectionError = true;
        loadingMemberAttendencesData = false;
        empty = false;
      });
    }
  }

  // Future<void> refresh() async {
  //   try {
  //   getAllMemberAttendences(pickedMemberPackage.registrationId)
  //           .then((value) {
  //         if (allMemberAttendencesList.isEmpty) {
  //           setState(() {
  //             loadingMemberAttendencesData = false;
  //             connectionError = false;
  //             empty = true;
  //           });
  //         } else {
  //           setState(() {
  //             loadingMemberAttendencesData = false;
  //             connectionError = false;
  //             empty = false;
  //           });
  //         }
  //       });
  //   } on SocketException {
  //     setState(() {
  //       connectionError = true;
  //       loadingMemberAttendencesData = false;
  //       empty = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            Positioned(
              top: 40,
              left: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Package Details',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 120, left: 22, right: 22, bottom: 30),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0, 4),
                            blurRadius: 5.0)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Text(
                                '${pickedMemberPackage.packageTitle} Package',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              pickedMemberPackage.isFreezed == true
                                  ? const Text(
                                      '(Freezed)',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 11),
                                    )
                                  : const Text('')
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${pickedMemberPackage.registrationAttended}/${pickedMemberPackage.packageAttendance}',
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline1.color,
                                fontWeight: FontWeight.w900,
                                fontSize: 52,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
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
                      : loadingMemberAttendencesData == true
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
                                  ],
                                )
                              : RefreshIndicator(
                                  color: Theme.of(context).primaryColor,
                                  strokeWidth: 5,
                                  onRefresh: () {
                                    // return refresh();
                                  },
                                  child: ListView.separated(
                                    padding: const EdgeInsets.all(0),
                                    itemBuilder: (context, index) {
                                      return MemberAttendencesDataTile(
                                          allMemberAttendencesList[index]);
                                    },
                                    itemCount: allMemberAttendencesList.length,
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Divider(
                                        thickness: 3,
                                        endIndent: 10,
                                        indent: 100,
                                        color: Colors.grey[400],
                                      );
                                    },
                                  ),
                                ),
                ),
              ],
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
        floatingActionButton: freezeFloatingButton());
  }

  Widget freezeFloatingButton() {
    return SizedBox(
      width: 150,
      child: FloatingActionButton.extended(
          heroTag: 'btn7',
          onPressed: () async {
            try {
              setState(() {
                confirmationLoading = true;
              });

              if (allMemberRegistrationsList[0].isFreezed == false) {
                await freezeRegistration(
                    registrationId:
                        allMemberRegistrationsList[0].registrationId,
                    context: context);
                freezeButtonText = 'Reactivate';

                //   await refresh();
                Navigator.of(context).pop(true);
                showToast('Package has been freezed successfully', context);
              } else {
                await reactivateRegestration(
                    registrationId:
                        allMemberRegistrationsList[0].registrationId,
                    context: context);
                freezeButtonText = 'Freeze';
                //   await refresh();
                Navigator.of(context).pop(true);

                showToast('Package has been reactivated successfully', context);
              }

              setState(() {
                confirmationLoading = false;
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
            }
          },
          label: Text(
            freezeButtonText,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headline1.color),
          ),
          icon: Icon(
            pickedMemberPackage.isFreezed == true ? Icons.task : Icons.pause,
            color: Theme.of(context).iconTheme.color,
          ),
          backgroundColor: Theme.of(context).primaryColor),
    );
  }
}
