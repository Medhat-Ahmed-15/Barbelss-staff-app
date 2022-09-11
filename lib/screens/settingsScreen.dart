// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'changeLanguageScreen.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/SettingsScreen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // String orderDate;
  // String convertedTime;

  bool loading;

  void toggleSwitchNotification(bool) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0, 4),
                        blurRadius: 5.0)
                  ],
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Search title
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 100, right: 15),
                child: Text(
                  AppLocalizations.of(context).settingsIconTitle,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1.color,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
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
                              fontSize: 27,
                              color: Theme.of(context).primaryColor),
                        ),
                        radius: 33.0,
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
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: Colors.grey[600]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          currentStaffData.staffName,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //Phone Nummber
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListTile(
                              leading: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).phoneHint,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.0,
                                        color: Colors.grey[600]),
                                  ),
                                  Text(
                                    currentStaffData.staffPhone,
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

                      //Location
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListTile(
                              leading: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).clubTitle,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.0,
                                        color: Colors.grey[600]),
                                  ),
                                  Text(
                                    currentStaffData.staffClubId,
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

                      //Language
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.5,
                            ),
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
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                      color: Colors.grey[600]),
                                ),
                                trailing: Icon(Icons.navigate_next,
                                    size: 30,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      //Terms and Conditions
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.5,
                            ),
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
                                // Navigator.of(context)
                                //     .pushNamed(ChangeLanguageScreen.routeName);
                              },
                              child: ListTile(
                                leading: Text(
                                  AppLocalizations.of(context)
                                      .termsAndConditionsTitle,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                      color: Colors.grey[600]),
                                ),
                                trailing: Icon(Icons.navigate_next,
                                    size: 30,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              onPressed: () {
                // ZoomDrawer.of(context).toggle();
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).iconTheme.color,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
