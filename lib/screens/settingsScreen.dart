// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/helper/object_box.dart';
import 'package:gym_staff_app/providers/offlineFeature_provider.dart';
import 'package:gym_staff_app/widgets/other/FourDotsLoading.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart' as lot;
import '../assistant/assistantFunction.dart';
import '../widgets/dialogs/feedBackDialog.dart';
import 'changeLanguageScreen.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/SettingsScreen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool switchModeLoading = false;
  bool syncLoading = false;

  Widget button({
    Function function,
    Color buttonColor,
    String buttontext,
    IconData iconData,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 56,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black54, offset: Offset(0, 4), blurRadius: 5.0)
          ],
        ),
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(buttonColor),
              overlayColor: MaterialStateProperty.all(
                  Theme.of(context).scaffoldBackgroundColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            onPressed: function,
            child: ListTile(
              leading: Text(
                buttontext,
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline1.color,
                    fontSize: 16),
              ),
              trailing: Icon(
                iconData,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<OfflineFeautureProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          onPressed: () {
            ZoomDrawer.of(context).toggle();
          },
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).iconTheme.color,
            size: 30,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Icon(
              workConnectionStatus == 'offline'
                  ? Icons.cloud_off_outlined
                  : Icons.cloud,
            ),
          )
        ],
        title: Text(
          AppLocalizations.of(context).settingsIconTitle,
          style: TextStyle(
              color: Theme.of(context).textTheme.headline1.color,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 15,
                    right: 15,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 36.0,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: Text(
                            currentStaffData.staffName.contains(' ')
                                ? currentStaffData.staffName[0] +
                                    currentStaffData.staffName.split(' ')[1][0]
                                : currentStaffData.staffName[0],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Theme.of(context).primaryColor),
                          ),
                          radius: 34.0,
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).nameHint,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            currentStaffData.staffName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),

                //Phone Nummber
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              AppLocalizations.of(context).phoneHint,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              '+${currentStaffData.staffCountryCode} ${currentStaffData.staffPhone}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  endIndent: 10,
                  indent: 10,
                  color: Colors.grey[300],
                ),

                //Id
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              AppLocalizations.of(context).id,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              currentStaffData.staffId,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 1,
                  endIndent: 10,
                  indent: 10,
                  color: Colors.grey[300],
                ),
                //Club Name
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              AppLocalizations.of(context).club,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              currentStaffData.clubName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Divider(
                  thickness: 1,
                  endIndent: 10,
                  indent: 10,
                  color: Colors.grey[300],
                ),
                //Language
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: InkWell(
                        splashColor: Colors.blue,
                        hoverColor: Colors.blue,
                        highlightColor: Colors.blue,
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ChangeLanguageScreen.routeName);
                        },
                        child: ListTile(
                          leading: Text(
                            AppLocalizations.of(context).languageTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          trailing: Icon(Icons.navigate_next,
                              size: 30, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  endIndent: 10,
                  indent: 10,
                  color: Colors.grey[300],
                ),

                const SizedBox(
                  height: 25,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ListTile(
                    leading: Text(
                      AppLocalizations.of(context).workOffline,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    trailing: Switch(
                      onChanged: (bool value) async {
                        if (workConnectionStatus == 'offline') {
                          switchModeLoading = false;

                          if (ObjectBox.checkDatabaseIsEmpty() == false) {
                            // showToast(
                            //     AppLocalizations.of(context)
                            //         .dataMustBeSyncedFirst,
                            //     context);
                            return;
                          }

                          await Provider.of<OfflineFeautureProvider>(context,
                                  listen: false)
                              .setWorkStatusInStorage('online');

                          // showSimpleNotification(
                          //   Text(AppLocalizations.of(context).backOnline),
                          //   background: Colors.green,
                          // );
                        } else {
                          switchModeLoading = false;
                          await Provider.of<OfflineFeautureProvider>(context,
                                  listen: false)
                              .setWorkStatusInStorage('offline');

                          ObjectBox.getClubData();

                          // showSimpleNotification(
                          //   Text(AppLocalizations.of(context)
                          //       .switchedToOfflineMode),
                          //   background: Colors.grey,
                          // );
                        }
                      },
                      value: workConnectionStatus == 'offline' ? true : false,
                      activeColor: Theme.of(context).scaffoldBackgroundColor,
                      activeTrackColor: Colors.green,
                      inactiveThumbColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      inactiveTrackColor: Colors.grey[300],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                button(
                  buttonColor: Colors.redAccent,
                  buttontext: AppLocalizations.of(context).sync,
                  iconData: Icons.sync_outlined,
                  function: () async {
                    if (ObjectBox.checkDatabaseIsEmpty() == true) {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) => FeedBackDialog(
                            titleText: AppLocalizations.of(context)
                                .dataIsAlreadySynced,
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

                    setState(() {
                      syncLoading = true;
                    });

                    ObjectBox.deleteClubData();

                    // await Future.delayed(const Duration(seconds: 10));

                    setState(() {
                      syncLoading = false;
                    });

                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) => FeedBackDialog(
                          titleText: AppLocalizations.of(context)
                              .datahasBeensyncedSuccessfully,
                          gif: 'assets/gifs/success.json',
                          enableButton: true,
                          buttonText: AppLocalizations.of(context).close,
                          callBackFunction: () {
                            Navigator.of(context).pop();
                          },
                          buttonColor: Theme.of(context).primaryColor),
                    );
                  },
                ),

                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
          syncLoading == true
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: lot.LottieBuilder.asset(
                              'assets/gifs/loadingSync.json'),
                        ),
                        Text(
                          AppLocalizations.of(context).syncingData,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.black38,
                )
              : const SizedBox(
                  height: 0,
                ),
        ],
      ),
    );
  }
}
