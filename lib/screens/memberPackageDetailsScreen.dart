import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/widgets/FourDotsLoading.dart';
import 'package:gym_staff_app/widgets/InternetConnectionError.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Exceptions/getRequest_exception.dart';
import '../widgets/EmptyAnimationWidget.dart';
import '../widgets/ListCountSubTitle.dart';
import '../widgets/feedBackDialog.dart';
import '../widgets/memberDetailsScreenWidgets/CentralCard.dart';
import '../widgets/memberPackageDetailsScreenWidgets/BackButtonAndScreenTitle.dart';
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
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (isInit == true) {
      try {
        await getAllMemberAttendences(pickedMemberPackage.registrationId);
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
      } on SocketException {
        setState(() {
          connectionError = true;
          loadingMemberAttendencesData = false;
          empty = false;
        });
      } catch (error) {
        showToast(AppLocalizations.of(context).somethingWentWrong, context);
      }
      isInit = false;
    }
  }

  Future<void> refresh() async {
    try {
      setState(() {
        loadingMemberAttendencesData = true;
        connectionError = false;
        empty = false;
      });
      await getAllMemberAttendences(pickedMemberPackage.registrationId);
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
            //Atendences list
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
                        ? InternetConnectionError(refresh)
                        : loadingMemberAttendencesData == true
                            ? FourDotsLoading()
                            : empty == true
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      EmptyAnimationWidget(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )
                                : RefreshIndicator(
                                    color: Theme.of(context).primaryColor,
                                    strokeWidth: 5,
                                    onRefresh: () {
                                      return refresh();
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

            //List count subtuitle
            Positioned(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 370,
                  left: localeLanguage == const Locale('en') ? 60 : 0,
                  right: localeLanguage != const Locale('en') ? 55 : 0,
                ),
                child: ListCountSubTitle(empty, 'attendences'),
              ),
            ),
            //Back Button And Screen title
            const BackButtonAndScreenTitle(),
            //Central Card
            const CentralCard(),
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
            ? const Text('')
            : empty == true
                ? const Text('')
                : freezeOrReactivateFloatingButton());
  }

  Widget freezeOrReactivateFloatingButton() {
    return SizedBox(
      width: 150,
      child: FloatingActionButton.extended(
          heroTag: 'FreezeOrReactivateButton',
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
              } catch (error) {
                showToast(
                    AppLocalizations.of(context).somethingWentWrong, context);
              }
            } else {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) => PickFreezingTimeDialog());
            }
          },
          label: Text(
            allMemberRegistrationsList[0].isFreezed == false
                ? AppLocalizations.of(context).freeze
                : AppLocalizations.of(context).reactivate,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headline1.color),
          ),
          backgroundColor: Theme.of(context).primaryColor),
    );
  }
}
