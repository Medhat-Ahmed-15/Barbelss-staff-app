// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:gym_staff_app/models/menuItem.dart';
import 'package:gym_staff_app/providers/auth_provider.dart';
import 'package:gym_staff_app/screens/mainScreen.dart';
import 'package:gym_staff_app/screens/settingsScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/widgets/menuScreenWidgets/loadingUserDataListTile.dart';
import 'package:gym_staff_app/widgets/menuScreenWidgets/userDataListTile.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<MenuItemData> menuItems = [
    MenuItemData('Home', Icons.home),
    MenuItemData('Settings', Icons.settings),
    MenuItemData('About Us', Icons.info),
    MenuItemData('Log Out', Icons.exit_to_app),
  ];

  bool loadingUserData = false;

  bool isInit = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            loadingUserData == true
                ? const loadingUserDataListTile()
                : userDataListTile(),
            const Spacer(),
            ...menuItems.map((item) {
              return buildMenuItemData(item, context);
            }),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItemData(MenuItemData item, BuildContext context) => ListTile(
        minLeadingWidth: 20,
        leading: Icon(
          item.icon,
          color: Theme.of(context).iconTheme.color,
        ),
        title: Text(
          item.title == 'Home'
              ? AppLocalizations.of(context).homeIconTitle
              : item.title == 'Settings'
                  ? AppLocalizations.of(context).settingsIconTitle
                  : item.title == 'About Us'
                      ? AppLocalizations.of(context).aboutUsIconTitle
                      : item.title == 'Log Out'
                          ? AppLocalizations.of(context).logOutIconTitle
                          : '',
          style: TextStyle(
              color: Theme.of(context).textTheme.headline1.color,
              fontWeight: FontWeight.bold),
        ),
        onTap: () {
          if (item.title == 'Home') {
            Navigator.of(context).pushNamed(MainScreen.routeName);
          } else if (item.title == 'Settings') {
            Navigator.of(context).pushNamed(SettingsScreen.routeName);
          } else if (item.title == 'Log Out') {
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<AuthProvider>(context, listen: false).SignOut();
          }
        },
      );
}
