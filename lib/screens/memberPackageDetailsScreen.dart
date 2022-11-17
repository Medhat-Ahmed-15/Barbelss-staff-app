import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/models/memberAttendencesData.dart';
import 'package:gym_staff_app/providers/all_memberRegistartions_provider.dart';
import 'package:gym_staff_app/widgets/memberPackageDetailsScreenWidgets/MemberPackageDetailsScreenCentralCard.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../Exceptions/getRequest_exception.dart';
import '../providers/offlineFeature_provider.dart';
import '../widgets/dialogs/feedBackDialog.dart';
import 'package:lottie/lottie.dart' as lot;
import '../widgets/dialogs/pickFreezingTimeDialog.dart';
import '../widgets/memberPackageDetailsScreenWidgets/BackButtonAndScreenTitle.dart';
import '../widgets/memberPackageDetailsScreenWidgets/memberAttendencesDataTile.dart';

class MemberPackageDetailsScreen extends StatefulWidget {
  static const routeName = '/MemberPackageDetailsScreen';

  @override
  State<MemberPackageDetailsScreen> createState() =>
      _MemberPackageDetailsScreenState();
}

class _MemberPackageDetailsScreenState
    extends State<MemberPackageDetailsScreen> {
  bool confirmationLoading = false;
  bool isInit = true;

  List<MemberAttendencesData> memberAttendencesOfflineData = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (isInit == true) {
      if (workConnectionStatus == 'offline') {
        memberAttendencesOfflineData =
            allAttendencesOfflineData.where((element) {
          return element.registrationId ==
                  offlinePickedMemberPackage.registrationId &&
              element.memberId == offlinePickedMemberPackage.memberId;
        }).toList();
      }

      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AllMemberRegistartionsProvider>(context, listen: true);
    Provider.of<OfflineFeautureProvider>(context, listen: true);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            //Atendences list
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  color: Theme.of(context).primaryColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: workConnectionStatus == 'offline'
                        ? memberAttendencesOfflineData.isEmpty
                            ? Center(
                                child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: lot.LottieBuilder.asset(
                                      'assets/gifs/empty.json'),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (context, index) {
                                  return MemberAttendencesDataTile(
                                      memberAttendencesOfflineData[index]);
                                },
                                itemCount: memberAttendencesOfflineData.length,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider(
                                    thickness: 1,
                                    endIndent: 10,
                                    indent: 10,
                                    color: Colors.grey[300],
                                  );
                                },
                              )
                        : pickedMemberPackage.memberAttendencesData.isEmpty
                            ? Center(
                                child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: lot.LottieBuilder.asset(
                                      'assets/gifs/empty.json'),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (context, index) {
                                  return MemberAttendencesDataTile(
                                      pickedMemberPackage
                                          .memberAttendencesData[index]);
                                },
                                itemCount: pickedMemberPackage
                                    .memberAttendencesData.length,
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
              ],
            ),

            //Back Button And Screen title
            const BackButtonAndScreenTitle(),
            //Central Card and list count
            MemberPackageDetailsScreenCentralCard(),
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
        floatingActionButton: workConnectionStatus == 'offline'
            ? memberAttendencesOfflineData.isEmpty
                ? const Text('')
                : freezeOrReactivateFloatingButton()
            : pickedMemberPackage.memberAttendencesData.isEmpty
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
                await Provider.of<AllMemberRegistartionsProvider>(context,
                        listen: false)
                    .reactivateRegestration(
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
            } else {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) => PickFreezingTimeDialog());
            }
          },
          label: Text(
            workConnectionStatus == 'offline'
                ? allRegistrationsOfflineData[0].isFreezed == false
                    ? AppLocalizations.of(context).freeze
                    : AppLocalizations.of(context).reactivate
                : allMemberRegistrationsList[0].isFreezed == false
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
