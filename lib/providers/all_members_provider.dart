import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/models/memberData.dart';
import 'package:http/http.dart' as http;

import '../Exceptions/getRequest_exception.dart';
import '../helper/object_box.dart';

class AllMembersProvider with ChangeNotifier {
  //Get All Members/////////////////////////////////////////////////////////////////////////////

  Future<void> getAllMembers() async {
    String url =
        'https://barbells-eg.co/api/v1/members/clubs/${currentStaffData.staffClubId}/search?phone=&countryCode=?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

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

    allMembersList = (allMembers as List)
        .map((index) => MemberData.fromjson(index))
        .toList();
  }

  //Block Member//////////////////////////////////////////////////////////

  Future<void> blockOrUnblockMember(
    BuildContext context,
  ) async {
    String url =
        'https://barbells-eg.co/api/v1/members/${pickedMember.memberId}?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

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
    memberData.membership = responseData['member']['membership'] ?? '';
    memberData.isBlacklist = responseData['member']['isBlacklist'] ?? false;
    memberData.canAuthenticate = responseData['member']['canAuthenticate'];
    var allMembernotes = (responseData['member']['notes'] as List)
        .map((index) => Notes.fromjson(index))
        .toList();
    memberData.notes = allMembernotes;

    pickedMember = memberData;

    int allMembersListIndex = allMembersList
        .indexWhere((member) => member.memberId == pickedMember.memberId);

    allMembersList[allMembersListIndex] = pickedMember;

    sortedMemberData = allMembersList;

    ObjectBox.blockOrUnblockMember(pickedMember.memberId, true);
  }

  //Blacklist Member//////////////////////////////////////////////////////////

  Future<void> addtoBlackListOrRemoveFromBlacklist(
    BuildContext context,
  ) async {
    String url =
        'https://barbells-eg.co/api/v1/members/${pickedMember.memberId}/blacklist?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

    final response = await http.patch(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': token
      },
      body: json.encode(
        {
          "status": pickedMember.isBlacklist == true ? 'REMOVE' : 'ADD',
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
    memberData.membership = responseData['member']['membership'] ?? '';
    memberData.canAuthenticate = responseData['member']['canAuthenticate'];

    memberData.isBlacklist = responseData['member']['isBlacklist'];
    var allMembernotes = (responseData['member']['notes'] as List)
        .map((index) => Notes.fromjson(index))
        .toList();
    memberData.notes = allMembernotes;

    pickedMember = memberData;

    int allMembersListIndex = allMembersList
        .indexWhere((member) => member.memberId == pickedMember.memberId);

    allMembersList[allMembersListIndex] = pickedMember;

    sortedMemberData = allMembersList;

    ObjectBox.addtoBlackListOrRemoveFromBlacklist(
        pickedMember.memberId, true, context);

    notifyListeners();
  }

  //Add Notes//////////////////////////////////////////////////////////

  Future<void> addNotes(BuildContext context, String note) async {
    String url =
        'https://barbells-eg.co/api/v1/members/${pickedMember.memberId}/notes?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

    final response = await http.patch(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': token
      },
      body: json.encode(
        {
          "noteMaker": currentStaffData.staffName,
          "note": note,
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
    memberData.membership = responseData['member']['membership'] ?? '';
    memberData.isBlacklist = responseData['member']['isBlacklist'] ?? false;
    memberData.canAuthenticate = responseData['member']['canAuthenticate'];
    var allMembernotes = (responseData['member']['notes'] as List)
        .map((index) => Notes.fromjson(index))
        .toList();
    memberData.notes = allMembernotes;

    pickedMember = memberData;

    int allMembersListIndex = allMembersList
        .indexWhere((member) => member.memberId == pickedMember.memberId);

    allMembersList[allMembersListIndex] = pickedMember;

    sortedMemberData = allMembersList;

    ObjectBox.insertNewNote(note: note, sync: true);
  }

  //Remove Notes//////////////////////////////////////////////////////////

  Future<void> removeNote(BuildContext context, String noteId) async {
    String url =
        'https://barbells-eg.co/api/v1/members/${pickedMember.memberId}/notes/$noteId?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

    final response = await http.delete(
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

    pickedMember.notes.removeWhere((element) => element.noteId == noteId);

    notifyListeners();
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
        'https://barbells-eg.co/api/v1/members?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

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
    memberData.birthYear = responseData['newMember']['birthYear'];
    memberData.canAuthenticate = responseData['newMember']['canAuthenticate'];
    memberData.isBlocked = responseData['newMember']['isBlocked'];
    memberData.createdAt = responseData['newMember']['createdAt'];
    memberData.qrCodeURL = responseData['newMember']['QRCodeURL'] ?? '';
    memberData.qrCodeURL = responseData['newMember']['QRCodeUUID'] ?? '';
    memberData.isBlacklist = responseData['newMember']['isBlacklist'] ?? false;
    if (responseData['newMember']['notes'] != null) {
      var allMembernotes = (responseData['newMember']['notes'] as List)
          .map((index) => Notes.fromjson(index))
          .toList();
      memberData.notes = allMembernotes;
    }

    pickedMember = memberData;

    allMembersList.insert(0, pickedMember);
    sortedMemberData = allMembersList;

    ObjectBox.insertNewMember(
        age: age,
        memberId: responseData['newMember']['_id'],
        email: email,
        gender: gender,
        membership: membership,
        name: name,
        phone: phone,
        phoneCode: phoneCode,
        sync: true,
        context: context);
    //Dee feeha notify listner
  }

  //Update Verify Member Registration//////////////////////////////////////////////////////////////////////////

  Future<void> updateMemberVerification(
      {BuildContext context,
      bool verificationStatus,
      String whatsAppMessageLang}) async {
    String url =
        'https://barbells-eg.co/api/v1/members/${pickedMember.memberId}/authentication?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

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
    memberData.isBlacklist =
        responseData['updatedMember']['isBlacklist'] ?? false;
    memberData.canAuthenticate =
        responseData['updatedMember']['canAuthenticate'];
    var allMembernotes = (responseData['updatedMember']['notes'] as List)
        .map((index) => Notes.fromjson(index))
        .toList();
    memberData.notes = allMembernotes;

    pickedMember = memberData;

    int allMembersListIndex = allMembersList
        .indexWhere((member) => member.memberId == pickedMember.memberId);

    allMembersList[allMembersListIndex] = pickedMember;

    sortedMemberData = allMembersList;

    notifyListeners();
  }

  void setNotifyListner() {
    notifyListeners();
  }
}
