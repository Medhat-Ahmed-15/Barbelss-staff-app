import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/models/staffData.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;

//Checking Authentication Function>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  bool checkauthentication() {
    if (_token != null) {
      return true;
    }
    return false;
  }

  //Authentication User>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<void> userLogin(String phone, String countryCode, String password,
      BuildContext context) async {
    String url =
        'http://159.223.172.150/api/v1/auth/staffs/login?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'phone': phone,
          'countryCode': countryCode,
          'password': password,
        }));
    final responseData = json.decode(response.body);

    if (responseData['accepted'] == false) {
      loginFieldKey = responseData['field'];
      throw GetRequestException(responseData['message'] ??
          AppLocalizations.of(context).invalidPhoneNumber);
    }

    _token = responseData['token'];
    token = _token;

    StaffData staffData = StaffData();
    staffData.staffId = responseData['staff']['_id'];
    staffData.staffEmail = responseData['staff']['email'];
    staffData.staffClubId = responseData['staff']['clubId'];
    staffData.staffName = responseData['staff']['name'];
    staffData.staffPhone = responseData['staff']['phone'];
    staffData.staffCountryCode = responseData['staff']['countryCode'];
    staffData.clubName = responseData['club']['name'];
    staffData.hasMembership = responseData['club']['hasMembership'];

    currentStaffData = staffData;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    final staffDataInStorage = json.encode({
      'token': _token,
      'staffId': responseData['staff']['_id'],
      'staffEmail': responseData['staff']['email'],
      'staffClubId': responseData['staff']['clubId'],
      'staffName': responseData['staff']['name'],
      'staffPhone': responseData['staff']['phone'],
      'staffCountryCode': responseData['staff']['countryCode'],
      'clubName': responseData['club']['name'],
      'hasMembership': responseData['club']['hasMembership']
    });

    prefs.setString('staffDataInStorage', staffDataInStorage);
  }

  //Auto Sigin>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<bool> tryAutoSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('staffDataInStorage')) {
      final extractedUserData = json
          .decode(prefs.getString('staffDataInStorage')) as Map<String, Object>;
      _token = extractedUserData['token'];
      token = _token;

      StaffData staffData = StaffData();
      staffData.staffId = extractedUserData['staffId'];
      staffData.staffEmail = extractedUserData['staffEmail'];
      staffData.staffClubId = extractedUserData['staffClubId'];
      staffData.staffName = extractedUserData['staffName'];
      staffData.staffPhone = extractedUserData['staffPhone'];
      staffData.staffCountryCode = extractedUserData['staffCountryCode'];
      staffData.clubName = extractedUserData['clubName'];
      staffData.hasMembership = extractedUserData['hasMembership'];

      currentStaffData = staffData;

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  //Signout Function>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<void> SignOut() async {
    _token = null;
    token = null;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    prefs.remove('staffDataInStorage');
  }
}
