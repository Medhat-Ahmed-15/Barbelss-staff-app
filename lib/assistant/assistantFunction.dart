// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:gym_staff_app/models/memberAttendencesData.dart';
import 'package:gym_staff_app/models/planData.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showToast(
  String message,
  BuildContext context,
) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

//get Local Language From Storage/////////////////////////////////////////////////////////////////////////////

Future<String> getLocalLanguageFromStorage() async {
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('localLanguage')) {
    return null;
  }
  final extractedLocalLanguage =
      json.decode(prefs.getString('localLanguage')) as Map<String, Object>;

  return extractedLocalLanguage['localLanguage'];
}

//set Local Language In Sorage/////////////////////////////////////////////////////////////////////////////

Future<void> setLocalLanguageInSorage(String language) async {
  final prefs = await SharedPreferences.getInstance();

  final localLanguage = json.encode({
    'localLanguage': language,
  });

  prefs.setString('localLanguage', localLanguage);

  localeLanguage = Locale(language);
}

void showErrorDialog(
    String message, String title, BuildContext context, Color color) {
  showDialog(
    barrierColor: Colors.white10,
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.grey[200],
      title: Text(title),
      titleTextStyle: TextStyle(color: color),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black),
      ),
      actions: [
        InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Text('Okay',
                style: TextStyle(color: Theme.of(context).primaryColor)))
      ],
    ),
  );
}

// Convert date to day in numbers month in text//////////////////////////////////////////////////////////////////////

String convertDateToDayInNumberMonthInText(String date, BuildContext context) {
  String monthInText;
  String dayInNumber;

  dayInNumber = date.split('T')[0].split('-')[2];

  if (dayInNumber.split('')[0].contains('0')) {
    dayInNumber = date.split('T')[0].split('-')[2].split('')[1];
  }

  int month = int.parse(date.split('T')[0].split('-')[1]);

  if (month == 1) {
    monthInText = AppLocalizations.of(context).jan;
  } else if (month == 2) {
    monthInText = AppLocalizations.of(context).feb;
  } else if (month == 3) {
    monthInText = AppLocalizations.of(context).mar;
  } else if (month == 4) {
    monthInText = AppLocalizations.of(context).apr;
  } else if (month == 5) {
    monthInText = AppLocalizations.of(context).may;
  } else if (month == 6) {
    monthInText = AppLocalizations.of(context).jun;
  } else if (month == 7) {
    monthInText = AppLocalizations.of(context).jul;
  } else if (month == 8) {
    monthInText = AppLocalizations.of(context).aug;
  } else if (month == 9) {
    monthInText = AppLocalizations.of(context).sep;
  } else if (month == 10) {
    monthInText = AppLocalizations.of(context).oct;
  } else if (month == 11) {
    monthInText = AppLocalizations.of(context).nov;
  } else if (month == 12) {
    monthInText = AppLocalizations.of(context).dec;
  }

  String ordderDate = dayInNumber + " " + monthInText;

  return ordderDate;
}

// convert Time To 12H Format//////////////////////////////////////////////////////////////////////

String convertTimeTo12HFormat(String time) {
  TimeOfDay timeOfDay = TimeOfDay(
      hour: int.parse(time.split("T")[1].split(':')[0]),
      minute: int.parse(time.split("T")[1].split(':')[1]));

  final now = DateTime.now();
  final dt =
      DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  final format = DateFormat.jm();

  return format.format(dt);
}

//Get All Plans/////////////////////////////////////////////////////////////////

Future<void> getAllPlans() async {
  String url =
      'http://159.223.172.150/api/v1/packages/clubs/${currentStaffData.staffClubId}?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

  var res = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-token': token
    },
  );

  String jSonData = res.body;
  var decodeData = jsonDecode(jSonData);

  if (decodeData['accepted'] == false) {
    throw GetRequestException('Error');
  }

  var allPlans = decodeData['packages'];

  allPlansList =
      (allPlans as List).map((index) => PlanData.fromjson(index)).toList();
}

//Extract Qr Image///////////////////////////////////////////////////////////

Future<void> extractImageAndPutInFirebase(
    GlobalKey globalKey, String phone) async {
//Get the render object from context.
  final RenderRepaintBoundary boundary =
      globalKey.currentContext.findRenderObject();
  //Convert to the image
  var image = await boundary.toImage(pixelRatio: 1);
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  final imageBytes = byteData.buffer.asUint8List(); //convert to unsigned
  Reference storageRef = FirebaseStorage.instance.ref();

  var sref = storageRef.child("IMG_${currentStaffData.staffClubId}_$phone.png");

  await sref.putData(imageBytes, SettableMetadata(contentType: "image/png"));

  qrCodeURL = await sref.getDownloadURL();
  log('CURRENT URL2:: $qrCodeURL');
}

//Update Member Qr Code//////////////////////////////////////////////////////////////////////////

Future<void> updateMemberQrCode(
    {BuildContext context, String whatsAppMessageLang}) async {
  String url =
      'http://159.223.172.150/api/v1/members/${pickedMember.memberId}/QR-code?lang=lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

  final response = await http.patch(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': token
      },
      body: json.encode({
        "QRCodeURL": qrCodeURL,
        "QRCodeUUID": qrCodeUUID,
      }));
  final responseData = jsonDecode(response.body);

  if (responseData['accepted'] == false) {
    throw GetRequestException(responseData['message'] ?? 'error');
  }

  await sendVerificationCodeToWhatsApp(context, whatsAppMessageLang);
}

//Send Verification Code To Whatsapp Registration//////////////////////////////////////////////////////////////////////////

Future<void> sendVerificationCodeToWhatsApp(
    BuildContext context, String whatsAppMessageLang) async {
  String url =
      'http://159.223.172.150/api/v1/members/${pickedMember.memberId}/language/$whatsAppMessageLang/whatsapp/verification?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-token': token
    },
  );
  final responseData = json.decode(response.body);

  if (responseData['accepted'] == false) {
    throw GetRequestException(responseData['message'] ?? 'error');
  }
}

//Add Attendance By Member//////////////////////////////////////////////////////////////////////////

Future<String> addAttendanceBymember(
    {String memberId, String qrCodeUUID, BuildContext context}) async {
  //159.223.172.150/api/v1/attendances/members/63137d0bc4cae825d788889b/QRCodes-uuids/39f3368e-8c38-4a48-beeb-138918da9970?lang=ar
  String url =
      'http://159.223.172.150/api/v1/attendances/members/$memberId/QRCodes-uuids/$qrCodeUUID?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-token': token
    },
  );
  final responseData = json.decode(response.body);

  if (responseData['accepted'] == false) {
    throw GetRequestException(
        '${responseData['message'] ?? 'error'}\n${responseData['note'] ?? 'error'}');
  }

  return '${AppLocalizations.of(context).numberOfAttendancesLeft}: ${responseData['remainingAttendance']}';
}

//Forget Password Package///////////////////////////////////////////////

Future<void> memberForgetPassword(String email, BuildContext context) async {
  String url =
      'http://159.223.172.150/api/v1/auth/reset-password/mail/staff?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': token
      },
      body: json.encode({"email": email}));

  final responseData = json.decode(response.body);

  if (responseData['accepted'] == false) {
    throw GetRequestException(responseData['message'] ?? 'error');
  }
}
