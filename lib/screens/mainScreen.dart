// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/models/menuItem.dart';
import 'package:gym_staff_app/screens/aboutScreen.dart';
import 'package:gym_staff_app/screens/searchScreen.dart';
import 'package:gym_staff_app/screens/settingsScreen.dart';
import 'PackagesScreen.dart';
import 'PaymentsScreen.dart';
import 'menuScreen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/MainScreen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MenuItemData currentItem = MenuItems.home;
  final drawerController = ZoomDrawerController();
  bool isInit = true;

  Widget getScreen() {
    if (currentItem == MenuItems.home) {
      return SearchScreen();
    } else if (currentItem == MenuItems.settings) {
      return SettingsScreen();
    } else if (currentItem == MenuItems.packages) {
      return PackagesScreen();
    } else if (currentItem == MenuItems.payments) {
      return PaymentsScreen();
    } else {
      return AboutScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ZoomDrawer(
        menuScreen: Builder(builder: (context) {
          return MenuScreen(
              currentItem: currentItem,
              onSelectedItem: (item) {
                setState(() {
                  currentItem = item;
                });
                ZoomDrawer.of(context).close();
              });
        }),
        mainScreen: getScreen(),
        showShadow: true,
        controller: drawerController,
        angle: 0,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.bounceIn,
        isRtl: localeLanguage == const Locale('en') ? false : true,
        borderRadius: 10.0,
        mainScreenTapClose: true,
      ),
    );
  }
}
