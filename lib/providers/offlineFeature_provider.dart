// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineFeautureProvider extends ChangeNotifier {
  //set work status In Sorage/////////////////////////////////////////////////////////////////////////////

  Future<void> setWorkStatusInStorage(String status) async {
    final prefs = await SharedPreferences.getInstance();

    final workStatus = json.encode({
      'workStatus': status,
    });

    prefs.setString('workStatus', workStatus);

    workConnectionStatus = status;
    notifyListeners();
  }

  //Get Work Status From Sorage/////////////////////////////////////////////////////////////////////////////

  Future<void> getWorkStatusFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('workStatus')) {
      workConnectionStatus = 'online';
      return;
    }
    final extractedWorkStatus =
        json.decode(prefs.getString('workStatus')) as Map<String, Object>;

    workConnectionStatus = extractedWorkStatus['workStatus'];
  }

  void setNotifyListner() {
    notifyListeners();
  }
}
