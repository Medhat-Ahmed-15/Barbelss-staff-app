// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:gym_staff_app/models/memberAttendencesData.dart';
import 'package:gym_staff_app/models/memberData.dart';
import 'package:gym_staff_app/models/memberRegistrationsResponseData.dart';
import 'package:gym_staff_app/models/planData.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showToast(String message, BuildContext context) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.grey,
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

//Get All Members/////////////////////////////////////////////////////////////////////////////

Future<void> getAllMembers() async {
  String url =
      'http://159.223.172.150/api/v1/members/clubs/${currentStaffData.staffClubId}/search?phone=&countryCode=?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

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
    throw GetRequestException(decodeData['message'] ?? 'error');
  }

  var allMembers = decodeData['members'];

  allMembersList =
      (allMembers as List).map((index) => MemberData.fromjson(index)).toList();
}

//Get All Member Registartions/////////////////////////////////////////////////////////////////////////////

Future<void> getAllMemberRegistartions() async {
  String url =
      'http://159.223.172.150/api/v1/registrations/clubs/${currentStaffData.staffClubId}/members/${pickedMember.memberId}?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

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

  var allMemberRegistrations = decodeData['memberRegistrations'];

  allMemberRegistrationsList = (allMemberRegistrations as List)
      .map((index) => MemberRegistrationsResponseData.fromjson(index))
      .toList();
}

// Convert date to day in numbers month in text//////////////////////////////////////////////////////////////////////

String convertDateToDayInNumberMonthInText(String date) {
  String monthInText;
  String dayInNumber;

  dayInNumber = date.split('T')[0].split('-')[2];

  if (dayInNumber.split('')[0].contains('0')) {
    dayInNumber = date.split('T')[0].split('-')[2].split('')[1];
  }

  int month = int.parse(date.split('T')[0].split('-')[1]);

  if (month == 1) {
    monthInText = 'Jan';
  } else if (month == 2) {
    monthInText = 'Feb';
  } else if (month == 3) {
    monthInText = 'Mar';
  } else if (month == 4) {
    monthInText = 'Apr';
  } else if (month == 5) {
    monthInText = 'May ';
  } else if (month == 6) {
    monthInText = 'Jun';
  } else if (month == 7) {
    monthInText = 'Jul';
  } else if (month == 8) {
    monthInText = 'Aug';
  } else if (month == 9) {
    monthInText = 'Sep';
  } else if (month == 10) {
    monthInText = 'Oct';
  } else if (month == 11) {
    monthInText = 'Nov';
  } else if (month == 12) {
    monthInText = 'Dec';
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

//Add New Member/////////////////////////////////////////////////////////////////////////////////

Future<void> addNewMember(
    {String name,
    String email,
    String phone,
    String phoneCode,
    String gender,
    int age,
    bool isAuthenticate,
    int membership,
    String whatsAppMessageLang,
    BuildContext context}) async {
  String url =
      'http://159.223.172.150/api/v1/members?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': token
      },
      body: json.encode({
        "clubId": currentStaffData.staffClubId,
        "name": name,
        "email": email,
        "phone": phone,
        "gender": gender,
        "age": age,
        "membership": membership,
        "countryCode": phoneCode,
        "staffId": currentStaffData.staffId,
        "canAuthenticate": isAuthenticate,
        "languageCode": whatsAppMessageLang,
      }));
  final responseData = json.decode(response.body);

  if (responseData['accepted'] == false) {
    addNewMemberFieldKey = responseData['field'];
    throw GetRequestException(responseData['message'] ?? 'error');
  }

  MemberData memberData = MemberData();

  memberData.memberId = responseData['newMember']['_id'];
  memberData.clubId = responseData['newMember']['clubId'];
  memberData.memberName = responseData['newMember']['name'];
  memberData.memberEmail = responseData['newMember']['email'];
  memberData.memberPhone = responseData['newMember']['phone'];
  memberData.countryCode = responseData['newMember']['countryCode'];
  memberData.staffId = responseData['newMember']['staffId'];
  memberData.membership = responseData['newMember']['membership'];
  memberData.gender = responseData['newMember']['gender'];
  memberData.canAuthenticate = responseData['newMember']['canAuthenticate'];
  memberData.isBlocked = responseData['newMember']['isBlocked'];

  pickedMember = memberData;
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

//Register Plan///////////////////////////////////////////////////////////////////////////

Future<void> registerPlan(
    {String planId, num planPrice, BuildContext context}) async {
  String url =
      'http://159.223.172.150/api/v1/registrations?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': token
      },
      body: json.encode({
        "clubId": currentStaffData.staffClubId,
        "memberId": pickedMember.memberId,
        "staffId": currentStaffData.staffId,
        "packageId": planId,
        "paid": planPrice
      }));
  final responseData = json.decode(response.body);

  if (responseData['accepted'] == false) {
    throw GetRequestException(responseData['message'] ?? 'error');
  }
}

// Confirm Arrival //////////////////////////////////////////////////////////////////////////////

Future<void> confirmArrival(
    {String registrationId, BuildContext context}) async {
  String url =
      'http://159.223.172.150/api/v1/attendances?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': token
      },
      body: json.encode({
        "registrationId": registrationId,
        "staffId": currentStaffData.staffId
      }));
  final responseData = json.decode(response.body);

  if (responseData['accepted'] == false) {
    throw GetRequestException(responseData['message'] ?? 'error');
  }
}

//Cancel Attendence////////////////////////////////////////////////////////////////////////////
Future<void> cancelAttendence(
    {String registrationId, BuildContext context}) async {
  String url =
      'http://159.223.172.150/api/v1/cancelled-attendances?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': token
      },
      body: json.encode({
        "clubId": currentStaffData.staffClubId,
        "registrationId": registrationId,
        "staffId": currentStaffData.staffId
      }));
  final responseData = json.decode(response.body);

  if (responseData['accepted'] == false) {
    throw GetRequestException(responseData['message'] ?? 'error');
  }
}

//Delete Registration//////////////////////////////////////////////////////////////////////////

Future<void> deleteRegistration(
    {String registrationId, BuildContext context}) async {
  String url =
      'http://159.223.172.150/api/v1/cancelled-registrations?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': token
      },
      body: json.encode({
        "registrationId": registrationId,
        "clubId": currentStaffData.staffClubId,
        "staffId": currentStaffData.staffId
      }));
  final responseData = json.decode(response.body);

  if (responseData['accepted'] == false) {
    throw GetRequestException(responseData['message'] ?? 'error');
  }
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

//Delete Registration//////////////////////////////////////////////////////////////////////////

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

//Freeze Registration//////////////////////////////////////////////////////////////////////////

Future<void> freezeRegistration(
    {String registrationId, BuildContext context, String duration}) async {
  String url =
      'http://159.223.172.150/api/v1/freeze-registrations?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

  final response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': token
      },
      body: json.encode({
        "registrationId": registrationId,
        "staffId": currentStaffData.staffId,
        "freezeDuration": duration
      }));
  final responseData = json.decode(response.body);

  if (responseData['accepted'] == false) {
    throw GetRequestException(responseData['message'] ?? 'error');
  }
}

//Reactivate Registration//////////////////////////////////////////////////////////////////////////

Future<void> reactivateRegestration(
    {String registrationId, BuildContext context}) async {
  String url =
      'http://159.223.172.150/api/v1/freeze-registrations/registrations/$registrationId?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

  final response = await http.patch(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': token
      },
      body: json.encode({
        "staffId": currentStaffData.staffId,
      }));
  final responseData = json.decode(response.body);

  if (responseData['accepted'] == false) {
    throw GetRequestException(responseData['message'] ?? 'error');
  }
}

//Get All Member Attendences/////////////////////////////////////////////////////////////////////////////

Future<void> getAllMemberAttendences(String registrationId) async {
  String url =
      'http://159.223.172.150/api/v1/attendances/registrations/$registrationId?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

  var res = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-token': token
    },
  );

  final responseData = json.decode(res.body);

  var allMemberAttendences = responseData['attendances'];

  allMemberAttendencesList = (allMemberAttendences as List)
      .map((index) => MemberAttendencesData.fromjson(index))
      .toList();
}

//Update Verify Member Registration//////////////////////////////////////////////////////////////////////////

Future<void> updateMemberVerification(
    {BuildContext context,
    bool verificationStatus,
    String whatsAppMessageLang}) async {
  String url =
      'http://159.223.172.150/api/v1/members/${pickedMember.memberId}/authentication?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

  try {
    final response = await http.patch(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': token
        },
        body: json.encode({
          "QRCodeURL": qrCodeURL,
          "QRCodeUUID": qrCodeUUID,
          "canAuthenticate": verificationStatus,
          "languageCode": whatsAppMessageLang
        }));
    final responseData = jsonDecode(response.body.toString());

    if (responseData['whatsappMessage']['message'] ==
            'could not send member QR code message' &&
        responseData['whatsappMessage']['isSent'] == false) {
      throw GetRequestException(
          responseData['whatsappMessage']['message'] ?? 'error');
    }

    MemberData memberData = MemberData();
    memberData.memberId = responseData['updatedMember']['_id'];
    memberData.clubId = responseData['updatedMember']['clubId'];
    memberData.memberName = responseData['updatedMember']['name'];
    memberData.staffId = responseData['updatedMember']['staffId'];
    memberData.gender = responseData['updatedMember']['gender'];
    memberData.memberEmail = responseData['updatedMember']['email'];
    memberData.birthYear = responseData['updatedMember']['birthYear'];
    memberData.isBlocked = responseData['updatedMember']['isBlocked'];
    memberData.createdAt = responseData['updatedMember']['createdAt'];
    memberData.memberPhone = responseData['updatedMember']['phone'];
    memberData.countryCode = responseData['updatedMember']['countryCode'];
    memberData.qrCodeURL = responseData['updatedMember']['QRCodeURL'];
    memberData.qrCodeUUID = responseData['updatedMember']['QRCodeUUID'];
    memberData.canAuthenticate =
        responseData['updatedMember']['canAuthenticate'];

    pickedMember = memberData;
  } on SocketException {
    throw SocketException(AppLocalizations.of(context).connectionStatusMessage);
  }
}

//Add Attendance By Member//////////////////////////////////////////////////////////////////////////

Future<void> addAttendanceBymember(
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

//Block Member//////////////////////////////////////////////////////////

Future<void> blockMember(
  BuildContext context,
) async {
  String url =
      'http://159.223.172.150/api/v1/members/${pickedMember.memberId}?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

  final response = await http.patch(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'x-access-token': token
    },
    body: json.encode(
      {
        "isBlocked": !pickedMember.isBlocked,
      },
    ),
  );

  final responseData = json.decode(response.body);

  if (responseData['accepted'] == false) {
    throw GetRequestException(responseData['message'] ?? 'error');
  }

  MemberData memberData = MemberData();
  memberData.memberId = responseData['member']['_id'];
  memberData.clubId = responseData['member']['clubId'];
  memberData.memberName = responseData['member']['name'];
  memberData.staffId = responseData['member']['staffId'];
  memberData.gender = responseData['member']['gender'];
  memberData.memberEmail = responseData['member']['email'];
  memberData.birthYear = responseData['member']['birthYear'];
  memberData.isBlocked = responseData['member']['isBlocked'];
  memberData.createdAt = responseData['member']['createdAt'];
  memberData.memberPhone = responseData['member']['phone'];
  memberData.countryCode = responseData['member']['countryCode'];
  memberData.qrCodeURL = responseData['member']['QRCodeURL'];
  memberData.qrCodeUUID = responseData['member']['QRCodeUUID'];
  memberData.canAuthenticate = responseData['member']['canAuthenticate'];

  pickedMember = memberData;
}
