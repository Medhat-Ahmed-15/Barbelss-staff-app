// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:gym_staff_app/screens/searchScreen.dart';

import 'menuScreen.dart';

class MainScreen extends StatelessWidget {
  static const routeName = '/MainScreen';
  final drawerController = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ZoomDrawer(
        menuScreen: MenuScreen(),
        mainScreen: SearchScreen(),
        showShadow: true,
        controller: drawerController,
        angle: 0.0,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.bounceIn,
        borderRadius: 24.0,
        mainScreenTapClose: true,
      ),
    );
  }
}
