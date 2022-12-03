// ignore_for_file: file_names
import 'dart:io';
import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:gym_staff_app/providers/all_memberRegistartions_provider.dart';
import 'package:gym_staff_app/providers/all_members_provider.dart';
import 'package:gym_staff_app/screens/addNewNoteScreen.dart';
import 'package:gym_staff_app/screens/plansScreen.dart';
import 'package:gym_staff_app/widgets/dialogs/feedBackDialog.dart';
import 'package:flutter/material.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/widgets/memberDetailsScreenWidgets/memberPackageDataTile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/widgets/memberDetailsScreenWidgets/offlineMemberPackageDataTile.dart';
import 'package:gym_staff_app/widgets/other/EmptyAnimationWidget.dart';
import 'package:gym_staff_app/widgets/other/FourDotsLoading.dart';
import 'package:gym_staff_app/widgets/other/InternetConnectionError.dart';
import 'package:provider/provider.dart';

import '../helper/object_box.dart';
import '../providers/offlineFeature_provider.dart';
import '../widgets/memberDetailsScreenWidgets/memberDetailsCentralCard.dart';

class MemberDetailsScreen extends StatefulWidget {
  static const routeName = '/MemberDetailsScreen';

  @override
  State<MemberDetailsScreen> createState() => _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends State<MemberDetailsScreen> {
  bool loadingMemberRegistrationsData = false;
  bool connectionError = false;
  bool confirmationLoading = false;
  bool enableConfirming = true;
  bool isInit = true;

  String barcodeData;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit == true) {
      if (workConnectionStatus == 'online') {
        try {
          setState(() {
            loadingMemberRegistrationsData = true;
            connectionError = false;
          });
          await Provider.of<AllMemberRegistartionsProvider>(context,
                  listen: false)
              .getAllMemberRegistartions();

          setState(() {
            loadingMemberRegistrationsData = false;
            connectionError = false;
          });
        } on SocketException {
          setState(() {
            connectionError = true;
            loadingMemberRegistrationsData = false;
          });
        } catch (error) {
          showToast(AppLocalizations.of(context).somethingWentWrong, context);
          setState(() {
            connectionError = false;
            loadingMemberRegistrationsData = false;
          });
        }
      } else {
        ObjectBox.getClubData();
        offlinePickedMemberAllRegistrationsList = offlineAllRegistrationsList
            .where(
                (element) => offlinePickedMember.memberId == element.memberId)
            .toList();

        setState(() {
          connectionError = false;
          loadingMemberRegistrationsData = false;
        });
      }

      isInit = false;
    }
  }

  Future<void> refresh() async {
    if (workConnectionStatus == 'online') {
      try {
        setState(() {
          loadingMemberRegistrationsData = true;
          connectionError = false;
        });
        await Provider.of<AllMemberRegistartionsProvider>(context,
                listen: false)
            .getAllMemberRegistartions();
        if (allMemberRegistrationsList.isEmpty) {
          setState(() {
            loadingMemberRegistrationsData = false;
            connectionError = false;
          });
        } else {
          setState(() {
            loadingMemberRegistrationsData = false;
            connectionError = false;
          });
        }
      } on SocketException {
        setState(() {
          connectionError = true;
          loadingMemberRegistrationsData = false;
        });
      } catch (error) {
        showToast(AppLocalizations.of(context).somethingWentWrong, context);
        setState(() {
          connectionError = false;
          loadingMemberRegistrationsData = false;
        });
      }
    } else {
      ObjectBox.getClubData();
      offlinePickedMemberAllRegistrationsList = offlineAllRegistrationsList
          .where((element) => element.memberId == offlinePickedMember.memberId)
          .toList();

      setState(() {
        connectionError = false;
        loadingMemberRegistrationsData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<OfflineFeautureProvider>(context, listen: true);

    Provider.of<AllMemberRegistartionsProvider>(context, listen: true);

    Provider.of<AllMembersProvider>(context, listen: true);

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
                  child: workConnectionStatus == 'offline'
                      ? offlinePickedMemberAllRegistrationsList
                              .where((element) => element.operation != 'DELETE')
                              .toList()
                              .isEmpty
                          ? EmptyAnimationWidget(refresh)
                          : RefreshIndicator(
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 5,
                              onRefresh: () {
                                return refresh();
                              },
                              child: ListView.separated(
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (context, index) {
                                  return OfflineMemberPackageDataTile(
                                      offlinePickedMemberAllRegistrationsList
                                          .where((element) =>
                                              element.operation != 'DELETE')
                                          .toList()[index],
                                      refresh);
                                },
                                itemCount:
                                    offlinePickedMemberAllRegistrationsList
                                        .where((element) =>
                                            element.operation != 'DELETE')
                                        .toList()
                                        .length,
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
                            )
                      : connectionError == true
                          ? InternetConnectionError(refresh)
                          : loadingMemberRegistrationsData == true
                              ? FourDotsLoading()
                              : allMemberRegistrationsList.isEmpty
                                  ? EmptyAnimationWidget(refresh)
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
                                          );
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
          MemberDetailsCentralCard(workConnectionStatus == 'offline'
              ? offlinePickedMemberAllRegistrationsList.isEmpty
              : allMemberRegistrationsList.isEmpty),
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
          : allMemberRegistrationsList.isEmpty &&
                  offlineAllRegistrationsList.isEmpty
              ? const Text('')
              : AnimatedFloatingActionButton(
                  fabButtons: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: addToBlacklistOrRemoveFromBlacklistButton(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: addNoteButton(),
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

          if (workConnectionStatus == 'offline') {
            if (offlinePickedMember.isBlocked == true) {
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
            if (offlinePickedMemberAllRegistrationsList[0].isFreezed == true) {
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

            if (offlinePickedMemberAllRegistrationsList[0]
                    .registrationAttended >=
                offlineAllPlansList
                    .firstWhere((element) =>
                        element.planId ==
                        offlinePickedMemberAllRegistrationsList[0].packageId)
                    .planAttendance) {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) => FeedBackDialog(
                    titleText:
                        AppLocalizations.of(context).sorryPackageHasBeenExpired,
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
            ObjectBox.updateMemberAttandance(
                offlinePickedMemberAllRegistrationsList[0], context, false);
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
            await Provider.of<AllMemberRegistartionsProvider>(context,
                    listen: false)
                .confirmArrival(
                    context: context,
                    registrationId:
                        allMemberRegistrationsList[0].registrationId);

            setState(() {
              confirmationLoading = false;
            });
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
            setState(() {
              confirmationLoading = false;
            });
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
            if (workConnectionStatus == 'offline') {
              if (offlinePickedMember.isBlocked == true) {
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
              if (offlinePickedMemberAllRegistrationsList[0].isFreezed ==
                  true) {
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

              if (offlinePickedMemberAllRegistrationsList[0]
                      .registrationAttended <=
                  0) {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) => FeedBackDialog(
                      titleText: AppLocalizations.of(context)
                          .sorryNoMoreSessionsToCancel,
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
              ObjectBox.removeMemberAttendance(
                  offlinePickedMemberAllRegistrationsList[0], context, false);
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
              return;
            }

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
              await Provider.of<AllMemberRegistartionsProvider>(context,
                      listen: false)
                  .cancelAttendence(
                      context: context,
                      registrationId:
                          allMemberRegistrationsList[0].registrationId,
                      numberOfSessions:
                          allMemberRegistrationsList[0].packageAttendance);

              setState(() {
                confirmationLoading = false;
              });
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

//Add Notes
  Widget addNoteButton() {
    return SizedBox(
      width: 200,
      child: FloatingActionButton.extended(
          heroTag: 'addNoteButton',
          onPressed: () {
            Navigator.pushNamed(context, AddNewNoteScreen.routeName);
          },
          label: Text(
            AppLocalizations.of(context).addNote,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headline1.color),
          ),
          icon: Icon(
            Icons.note_add,
            color: Theme.of(context).iconTheme.color,
          ),
          backgroundColor: Colors.blue),
    );
  }

//add or remove blacklist
  Widget addToBlacklistOrRemoveFromBlacklistButton() {
    return SizedBox(
      width: workConnectionStatus == 'offline'
          ? offlinePickedMember.isBlacklist == false
              ? 200
              : 250
          : pickedMember.isBlacklist == false
              ? 200
              : 250,
      child: FloatingActionButton.extended(
          heroTag: 'addToBlackListButton',
          onPressed: () async {
            if (workConnectionStatus == 'offline') {
              ObjectBox.addtoBlackListOrRemoveFromBlacklist(
                  offlinePickedMember.memberId, false, context);
            } else {
              setState(() {
                confirmationLoading = true;
              });
              await Provider.of<AllMembersProvider>(context, listen: false)
                  .addtoBlackListOrRemoveFromBlacklist(context);
              setState(() {
                confirmationLoading = false;
              });
            }
          },
          label: Text(
            workConnectionStatus == 'offline'
                ? offlinePickedMember.isBlacklist == true
                    ? AppLocalizations.of(context).removefromBlacklist
                    : AppLocalizations.of(context).addToBlackList
                : pickedMember.isBlacklist == true
                    ? AppLocalizations.of(context).removefromBlacklist
                    : AppLocalizations.of(context).addToBlackList,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headline1.color),
          ),
          icon: Icon(
            workConnectionStatus == 'offline'
                ? offlinePickedMember.isBlacklist == true
                    ? Icons.person
                    : Icons.person_off_sharp
                : pickedMember.isBlacklist == true
                    ? Icons.person
                    : Icons.person_off_sharp,
            color: Theme.of(context).iconTheme.color,
          ),
          backgroundColor: Colors.black54),
    );
  }
}
