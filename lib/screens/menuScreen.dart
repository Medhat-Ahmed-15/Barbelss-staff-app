// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:gym_staff_app/models/menuItem.dart';
import 'package:gym_staff_app/providers/auth_provider.dart';
import 'package:gym_staff_app/screens/aboutScreen.dart';
import 'package:gym_staff_app/screens/mainScreen.dart';
import 'package:gym_staff_app/screens/settingsScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/widgets/menuScreenWidgets/loadingUserDataListTile.dart';
import 'package:gym_staff_app/widgets/menuScreenWidgets/userDataListTile.dart';
import 'package:provider/provider.dart';

class MenuItems {
  static MenuItemData home = MenuItemData('Home', Icons.home);
  static MenuItemData settings = MenuItemData('Settings', Icons.settings);
  static MenuItemData aboutUs = MenuItemData('About Us', Icons.info);
  static MenuItemData logOut = MenuItemData('Log Out', Icons.exit_to_app);

  static List<MenuItemData> all = [home, settings, aboutUs, logOut];
}

class MenuScreen extends StatefulWidget {
  MenuItemData currentItem;
  ValueChanged<MenuItemData> onSelectedItem;

  MenuScreen({this.currentItem, this.onSelectedItem});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool loadingUserData = false;

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
            ...MenuItems.all.map((item) {
              return buildMenuItemData(item, context);
            }),
            const Spacer(
              flex: 3,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                'Barbells',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Text(
                'version: 1.0.0+1',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItemData(MenuItemData item, BuildContext context) => ListTile(
      selectedTileColor: Colors.white10,
      selected: widget.currentItem == item,
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
        if (item.title == 'Log Out') {
          Navigator.of(context).pushReplacementNamed('/');
          Provider.of<AuthProvider>(context, listen: false).SignOut();
        } else {
          widget.onSelectedItem(item);
        }
      });
}
