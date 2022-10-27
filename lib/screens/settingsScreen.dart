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
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
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
      body: SingleChildScrollView(
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
                            fontSize: 37,
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
                            fontSize: 18.0,
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
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(206, 206, 206, 1),
                      offset: Offset(1, 3),
                      blurRadius: 1.0,
                    )
                  ],
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
            const SizedBox(
              height: 20,
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
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(206, 206, 206, 1),
                      offset: Offset(1, 3),
                      blurRadius: 1.0,
                    )
                  ],
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

            //Language
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(206, 206, 206, 1),
                      offset: Offset(1, 3),
                      blurRadius: 1.0,
                    )
                  ],
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

            const SizedBox(
              height: 20,
            ),

            //Terms and Conditions
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(206, 206, 206, 1),
                      offset: Offset(1, 3),
                      blurRadius: 1.0,
                    )
                  ],
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
                        AppLocalizations.of(context).termsAndConditionsTitle,
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
          ],
        ),
      ),
    );
  }
}
