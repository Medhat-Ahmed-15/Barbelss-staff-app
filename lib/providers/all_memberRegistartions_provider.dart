import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/models/memberAttendencesData.dart';
import 'package:http/http.dart' as http;

import '../Exceptions/getRequest_exception.dart';
import '../helper/object_box.dart';
import '../models/memberRegistrationsResponseData.dart';

class AllMemberRegistartionsProvider with ChangeNotifier {
  //Get All Member Registartions/////////////////////////////////////////////////////////////////////////////

  Future<void> getAllMemberRegistartions() async {
    String url =
        'https://barbells-eg.co/api/v1/registrations/attendances/members/${pickedMember.memberId}?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

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

    var allMemberRegistrations = decodeData['registrations'];

    allMemberRegistrationsList = (allMemberRegistrations as List)
        .map((index) => MemberRegistrationsResponseData.fromjson(index))
        .toList();
  }

  //Register Plan///////////////////////////////////////////////////////////////////////////

  Future<void> registerPlan(
      {String planId, num planPrice, BuildContext context}) async {
    String url =
        'https://barbells-eg.co/api/v1/registrations?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

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

    MemberAttendencesData memberAttendencesData = MemberAttendencesData();
    memberAttendencesData.attendenceId = responseData['attendance']['_id'];
    memberAttendencesData.clubId = responseData['attendance']['clubId'];
    memberAttendencesData.registrationId =
        responseData['attendance']['registrationId'];
    memberAttendencesData.packageId = responseData['attendance']['packageId'];
    memberAttendencesData.staffId = responseData['attendance']['staffId'];
    memberAttendencesData.memberId = responseData['attendance']['memberId'];
    memberAttendencesData.createdAt = responseData['attendance']['createdAt'];

    List<MemberAttendencesData> newMemberAttendencesData = [];
    newMemberAttendencesData.insert(0, memberAttendencesData);

    var planData = allPlansList.firstWhere(
        (plan) => plan.planId == responseData['registration']['packageId']);

    MemberRegistrationsResponseData addedPlan =
        MemberRegistrationsResponseData();
    addedPlan.registrationId = responseData['registration']['_id'];
    addedPlan.registrationIsActive = responseData['registration']['isActive'];
    addedPlan.registrationAttended = responseData['registration']['attended'];
    addedPlan.registrationExpiresAt = responseData['registration']['expiresAt'];
    addedPlan.isFreezed = responseData['registration']['isFreezed'];
    addedPlan.registrationCreatedAt = responseData['registration']['createdAt'];
    addedPlan.packageId = responseData['registration']['packageId'];
    addedPlan.packageTitle = planData.planTitle;
    addedPlan.packageAttendance = planData.planAttendance;
    addedPlan.packageExpiresIn = planData.planExpiresIn;
    addedPlan.memberAttendencesData = newMemberAttendencesData;

    allMemberRegistrationsList.insert(0, addedPlan);

    notifyListeners();

    ObjectBox.insertNewSubscription(
      isFreezed: responseData['registration']['isFreezed'],
      packageId: responseData['attendance']['packageId'],
      paidInDouble: planData.planPriceAsDouble,
      registartionAttended: 1,
      registartionCreatedAt: responseData['registration']['createdAt'],
      registartionExpiresAt: responseData['registration']['expiresAt'],
      registrationId: responseData['registration']['_id'],
      registrationIsActive: responseData['registration']['isActive'],
      sync: true,
    );

    ObjectBox.insertNewAttendance(
      packageId: responseData['attendance']['packageId'],
      registrationId: responseData['attendance']['registrationId'],
      sync: true,
    );
  }

  //Delete Registration//////////////////////////////////////////////////////////////////////////

  Future<void> deleteRegistration(
      {String registrationId, BuildContext context}) async {
    String url =
        'https://barbells-eg.co/api/v1/cancelled-registrations?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

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

    allMemberRegistrationsList.removeWhere(
        (registration) => registration.registrationId == registrationId);

    ObjectBox.removeMemberRegistration(
        registrationId, context, true); //feeha notify listner
  }

  //Cancel Attendence////////////////////////////////////////////////////////////////////////////
  Future<void> cancelAttendence(
      {String registrationId,
      BuildContext context,
      int numberOfSessions}) async {
    if (numberOfSessions == 1) {
      deleteRegistration(context: context, registrationId: registrationId);
    } else {
      String url =
          'https://barbells-eg.co/api/v1/cancelled-attendances?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

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

      var oldRegistration = allMemberRegistrationsList
          .firstWhere((element) => element.registrationId == registrationId);

      List<MemberAttendencesData> newMemberAttendencesData =
          oldRegistration.memberAttendencesData;
      newMemberAttendencesData.removeAt(0);

      MemberRegistrationsResponseData newRegistration =
          MemberRegistrationsResponseData();
      newRegistration.registrationId = oldRegistration.registrationId;
      newRegistration.registrationIsActive =
          oldRegistration.registrationIsActive;
      newRegistration.registrationAttended =
          oldRegistration.registrationAttended - 1;
      newRegistration.registrationExpiresAt =
          oldRegistration.registrationExpiresAt;
      newRegistration.isFreezed = oldRegistration.isFreezed;
      newRegistration.registrationCreatedAt =
          oldRegistration.registrationCreatedAt;
      newRegistration.packageId = oldRegistration.packageId;
      newRegistration.packageTitle = oldRegistration.packageTitle;
      newRegistration.packageAttendance = oldRegistration.packageAttendance;
      newRegistration.packageExpiresIn = oldRegistration.packageExpiresIn;
      newRegistration.memberAttendencesData = newMemberAttendencesData;

      int index = allMemberRegistrationsList
          .indexWhere((element) => element.registrationId == registrationId);

      allMemberRegistrationsList[index] = newRegistration;

      offlinePickedMemberAllRegistrationsList = offlineAllRegistrationsList
          .where((element) => pickedMember.memberId == element.memberId)
          .toList();

      var offlineActivememberRegeistartion =
          offlinePickedMemberAllRegistrationsList
              .firstWhere((element) => element.registrationIsActive == true);

      ObjectBox.removeMemberAttendance(
          offlineActivememberRegeistartion, context, true);
      //feeha notify listner
    }
  }

// Confirm Arrival //////////////////////////////////////////////////////////////////////////////

  Future<void> confirmArrival(
      {String registrationId, BuildContext context}) async {
    String url =
        'https://barbells-eg.co/api/v1/attendances?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

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

    var oldRegistration = allMemberRegistrationsList
        .firstWhere((element) => element.registrationId == registrationId);

    MemberAttendencesData memberAttendencesData = MemberAttendencesData();
    memberAttendencesData.attendenceId = responseData['attendance']['_id'];
    memberAttendencesData.clubId = responseData['attendance']['clubId'];
    memberAttendencesData.registrationId =
        responseData['attendance']['registrationId'];
    memberAttendencesData.packageId = responseData['attendance']['packageId'];
    memberAttendencesData.staffId = responseData['attendance']['staffId'];
    memberAttendencesData.memberId = responseData['attendance']['memberId'];
    memberAttendencesData.createdAt = responseData['attendance']['createdAt'];

    List<MemberAttendencesData> newMemberAttendencesData =
        oldRegistration.memberAttendencesData;
    newMemberAttendencesData.insert(0, memberAttendencesData);

    MemberRegistrationsResponseData newRegistration =
        MemberRegistrationsResponseData();
    newRegistration.registrationId = oldRegistration.registrationId;
    newRegistration.registrationIsActive = oldRegistration.registrationIsActive;
    newRegistration.registrationAttended =
        oldRegistration.registrationAttended + 1;
    newRegistration.registrationExpiresAt =
        oldRegistration.registrationExpiresAt;
    newRegistration.isFreezed = oldRegistration.isFreezed;
    newRegistration.registrationCreatedAt =
        oldRegistration.registrationCreatedAt;
    newRegistration.packageId = oldRegistration.packageId;
    newRegistration.packageTitle = oldRegistration.packageTitle;
    newRegistration.packageAttendance = oldRegistration.packageAttendance;
    newRegistration.packageExpiresIn = oldRegistration.packageExpiresIn;
    newRegistration.memberAttendencesData = newMemberAttendencesData;

    int index = allMemberRegistrationsList
        .indexWhere((element) => element.registrationId == registrationId);

    allMemberRegistrationsList[index] = newRegistration;

    offlinePickedMemberAllRegistrationsList = offlineAllRegistrationsList
        .where((element) => pickedMember.memberId == element.memberId)
        .toList();

    var offlineActivememberRegeistartion =
        offlinePickedMemberAllRegistrationsList
            .firstWhere((element) => element.registrationIsActive == true);

    ObjectBox.updateMemberAttandance(
        offlineActivememberRegeistartion, context, true); //feeha notify listner
  }

  //Reactivate Registration//////////////////////////////////////////////////////////////////////////

  Future<void> reactivateRegestration(
      {String registrationId, BuildContext context}) async {
    String url =
        'https://barbells-eg.co/api/v1/freeze-registrations/registrations/$registrationId?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

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

    var oldRegistration = allMemberRegistrationsList
        .firstWhere((element) => element.registrationId == registrationId);

    MemberRegistrationsResponseData newRegistration =
        MemberRegistrationsResponseData();
    newRegistration.registrationId = oldRegistration.registrationId;
    newRegistration.registrationIsActive = oldRegistration.registrationIsActive;
    newRegistration.registrationAttended = oldRegistration.registrationAttended;
    newRegistration.registrationExpiresAt =
        oldRegistration.registrationExpiresAt;
    newRegistration.isFreezed = false;
    newRegistration.registrationCreatedAt =
        oldRegistration.registrationCreatedAt;
    newRegistration.packageId = oldRegistration.packageId;
    newRegistration.packageTitle = oldRegistration.packageTitle;
    newRegistration.packageAttendance = oldRegistration.packageAttendance;
    newRegistration.packageExpiresIn = oldRegistration.packageExpiresIn;
    newRegistration.memberAttendencesData =
        oldRegistration.memberAttendencesData;

    int index = allMemberRegistrationsList
        .indexWhere((element) => element.registrationId == registrationId);

    allMemberRegistrationsList[index] = newRegistration;

    ObjectBox.reactivateRegistration(
        context: context,
        memberData: pickedMember,
        registartionId: pickedMemberPackage.registrationId,
        sync: true); //feeha notify listner
  }

  //Freeze Registration//////////////////////////////////////////////////////////////////////////

  Future<void> freezeRegistration(
      {String registrationId, BuildContext context, String duration}) async {
    String url =
        'https://barbells-eg.co/api/v1/freeze-registrations?lang=${localeLanguage == const Locale('en') ? 'en' : 'ar'}';

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

    var oldRegistration = allMemberRegistrationsList
        .firstWhere((element) => element.registrationId == registrationId);

    MemberRegistrationsResponseData newRegistration =
        MemberRegistrationsResponseData();
    newRegistration.registrationId = oldRegistration.registrationId;
    newRegistration.registrationIsActive = oldRegistration.registrationIsActive;
    newRegistration.registrationAttended = oldRegistration.registrationAttended;
    newRegistration.registrationExpiresAt =
        responseData['freezedRegistration']['registrationNewExpirationDate'];
    newRegistration.isFreezed = true;
    newRegistration.registrationCreatedAt =
        oldRegistration.registrationCreatedAt;
    newRegistration.packageId = oldRegistration.packageId;
    newRegistration.packageTitle = oldRegistration.packageTitle;
    newRegistration.packageAttendance = oldRegistration.packageAttendance;
    newRegistration.packageExpiresIn = oldRegistration.packageExpiresIn;
    newRegistration.memberAttendencesData =
        oldRegistration.memberAttendencesData;

    int index = allMemberRegistrationsList
        .indexWhere((element) => element.registrationId == registrationId);

    allMemberRegistrationsList[index] = newRegistration;

    ObjectBox.freezeRegistration(
        context: context,
        freezeDuration: duration,
        memberData: pickedMember,
        packageId: oldRegistration.packageId,
        registartionId: pickedMemberPackage.registrationId,
        sync: true); //feeha notify listner
  }

  void setNotifyListner() {
    notifyListeners();
  }
}
