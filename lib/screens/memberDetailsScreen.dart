// ignore_for_file: file_names
import 'dart:io';
import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:gym_staff_app/screens/plansScreen.dart';
import 'package:gym_staff_app/widgets/dialogs/feedBackDialog.dart';
import 'package:flutter/material.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/widgets/memberDetailsScreenWidgets/memberPackageDataTile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/widgets/other/EmptyAnimationWidget.dart';
import 'package:gym_staff_app/widgets/other/FourDotsLoading.dart';
import 'package:gym_staff_app/widgets/other/InternetConnectionError.dart';

import '../widgets/memberDetailsScreenWidgets/memberDetailsCentralCard.dart';

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

  @override
  void didChangeDependencies() async {
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
    } catch (error) {
      showToast(AppLocalizations.of(context).somethingWentWrong, context);
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
      setState(() {
        loadingMemberRegistrationsData = true;
        connectionError = false;
        empty = false;
      });
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
    } catch (error) {
      showToast(AppLocalizations.of(context).somethingWentWrong, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          //registartions list
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                color: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 150),
                  child: connectionError == true
                      ? InternetConnectionError(refresh)
                      : loadingMemberRegistrationsData == true
                          ? FourDotsLoading()
                          : empty == true
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const EmptyAnimationWidget(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
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
                                                        BorderRadius.circular(10.0),
                                                    side: BorderSide(color: Theme.of(context).primaryColor)))),
                                        onPressed: () async {
                                          await Navigator.of(context).pushNamed(
                                            PlansScreen.routeName,
                                          );
                                          await refresh();
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
            ],
          ),
          //central card and list count
          MemberDetailsCentralCard(empty),
          //back arrow
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
          //add button
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              onPressed: () async {
                await Navigator.of(context).pushNamed(PlansScreen.routeName);
                await refresh();
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
                  child: FourDotsLoading(),
                  color: Colors.black38,
                )
              : const SizedBox(
                  height: 0,
                ),
        ],
      ),
      floatingActionButton: connectionError == true
          ? const Text('')
          : empty == true
              ? const Text('')
              : AnimatedFloatingActionButton(
                  fabButtons: <Widget>[
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
                  animatedIconData: AnimatedIcons.list_view,
                ),
    );
  }

//Confirm Arrival /////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget confirmArrivalFLoatingButton() {
    return SizedBox(
      width: 200,
      child: FloatingActionButton.extended(
        heroTag: 'confirmButton',
        key: UniqueKey(),
        onPressed: () async {
          if (enableConfirming == false) {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) => FeedBackDialog(
                  titleText: AppLocalizations.of(context).cantConfirmTwice,
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

          if (pickedMember.isBlocked == true) {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) => FeedBackDialog(
                  titleText: AppLocalizations.of(context).sorryMemberIsBlocked,
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

          if (allMemberRegistrationsList[0].isFreezed == true) {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) => FeedBackDialog(
                  titleText: AppLocalizations.of(context).packageIsfreezed,
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
          } catch (error) {
            showToast(AppLocalizations.of(context).somethingWentWrong, context);
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
          heroTag: 'cancelButton',
          onPressed: () async {
            if (pickedMember.isBlocked == true) {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) => FeedBackDialog(
                    titleText:
                        AppLocalizations.of(context).sorryMemberIsBlocked,
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

            if (allMemberRegistrationsList[0].isFreezed == true) {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) => FeedBackDialog(
                    titleText: AppLocalizations.of(context).packageIsfreezed,
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
            } catch (error) {
              showToast(
                  AppLocalizations.of(context).somethingWentWrong, context);
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
}
