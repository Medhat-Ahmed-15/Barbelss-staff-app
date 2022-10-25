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
import '../widgets/pickFreezingTimeDialog.dart';

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
  bool confirmationLoading = false;
  bool isInit = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (isInit == true) {
      try {
        freezeButtonText = allMemberRegistrationsList[0].isFreezed == false
            ? AppLocalizations.of(context).freeze
            : AppLocalizations.of(context).reactivate;
        getAllMemberAttendences(pickedMemberPackage.registrationId, context)
            .then((value) {
          if (allMemberAttendencesList.isEmpty) {
            setState(() {
              loadingMemberAttendencesData = false;
              connectionError = false;
              empty = true;
            });
          } else {
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
      isInit = false;
    }
  }

  Future<void> refresh(BuildContext context) async {
    try {
      freezeButtonText = allMemberRegistrationsList[0].isFreezed == false
          ? AppLocalizations.of(context).freeze
          : AppLocalizations.of(context).reactivate;
      await getAllMemberAttendences(
          pickedMemberPackage.registrationId, context);
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
    } on SocketException {
      setState(() {
        connectionError = true;
        loadingMemberAttendencesData = false;
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
                    padding: const EdgeInsets.only(top: 130),
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
                                      return refresh(context);
                                    },
                                    child: Scrollbar(
                                      thumbVisibility: true,
                                      interactive: true,
                                      child: ListView.separated(
                                        padding: const EdgeInsets.all(0),
                                        itemBuilder: (context, index) {
                                          return MemberAttendencesDataTile(
                                              allMemberAttendencesList[index]);
                                        },
                                        itemCount:
                                            allMemberAttendencesList.length,
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider(
                                            thickness: 1,
                                            endIndent: 10,
                                            indent: 10,
                                            color: Colors.grey[300],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                  ),
                ),
              ],
            ),
            Positioned(
              child: Padding(
                  padding: EdgeInsets.only(
                    top: 370,
                    left: localeLanguage == const Locale('en') ? 60 : 0,
                    right: localeLanguage != const Locale('en') ? 55 : 0,
                  ),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context).searchResultsContains,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${empty == true || allMemberAttendencesList == null ? 0 : allMemberAttendencesList.length}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppLocalizations.of(context).attendences,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )),
            ),
            Positioned(
              top: 40,
              left: localeLanguage == const Locale('en') ? 10 : 0,
              right: localeLanguage != const Locale('en') ? 10 : 0,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).iconTheme.color,
                      size: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    AppLocalizations.of(context).packageDetails,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1.color,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 150,
              left: 50,
              right: 50,
              child: Container(
                width: 100,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(0, 4),
                          blurRadius: 5.0)
                    ],
                    color: Theme.of(context).scaffoldBackgroundColor),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Text(
                              '${pickedMemberPackage.packageTitle} Package',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            pickedMemberPackage.isFreezed == true
                                ? Text(
                                    '(${AppLocalizations.of(context).freezed})',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 13),
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
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 60,
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
            if (allMemberRegistrationsList[0].isFreezed == true) {
              try {
                setState(() {
                  confirmationLoading = true;
                });
                await reactivateRegestration(
                    registrationId:
                        allMemberRegistrationsList[0].registrationId,
                    context: context);

                setState(() {
                  confirmationLoading = false;
                });
                freezeButtonText = AppLocalizations.of(context).freeze;
                //   await refresh();
                Navigator.of(context).pop(true);

                showToast(
                    AppLocalizations.of(context)
                        .packageHasBeenReactivatedSuccessfully,
                    context);
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
            } else {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) => PickFreezingTimeDialog());
            }
          },
          label: Text(
            freezeButtonText,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headline1.color),
          ),
          backgroundColor: Theme.of(context).primaryColor),
    );
  }
}
