import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/models/freezeData.dart';
import 'package:gym_staff_app/models/memberAttendencesData.dart';
import 'package:gym_staff_app/models/planData.dart';
import 'package:gym_staff_app/models/registrations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../assistant/assistantFunction.dart';
import '../models/memberData.dart';
import '../objectbox.g.dart';
import '../providers/all_memberRegistartions_provider.dart';
import '../providers/all_members_provider.dart';

class ObjectBox {
  static Future<void> init() async {
    store = await openStore();

    memberDataBox = Box<MemberData>(store);
    registrationsBox = Box<Registrations>(store);
    memberAttendenceDataBox = Box<MemberAttendencesData>(store);
    planDataBox = Box<PlanData>(store);
    freezeBox = Box<FreezeData>(store);
    notesBox = Box<Notes>(store);
  }

  static void closeStore() {
    store.close();
  }

  //Insert Club Data///////////////////////////////////////////////////////////

  static void insertClubData() {
    memberDataBox.putMany(offlineAllMembersData);
    registrationsBox.putMany(offlineAllRegistrationsList);
    memberAttendenceDataBox.putMany(offlineAllAttendancesList);
    planDataBox.putMany(offlineAllPlansList);
    //insert freeze entity
    //insert notes entity
  }

//Add New member////////////////////////////////////////////////////////////////
  static void insertNewMember({
    String memberId,
    String name,
    String email,
    String phone,
    String phoneCode,
    int membership,
    String gender,
    int age,
    bool sync,
    BuildContext context,
  }) {
    MemberData newMemberData = MemberData();
    newMemberData.id = 0;
    newMemberData.memberId = memberId;
    newMemberData.clubId = currentStaffData.staffClubId;
    newMemberData.memberName = name;
    newMemberData.memberEmail = email;
    newMemberData.memberPhone = phone;
    newMemberData.countryCode = phoneCode;
    newMemberData.staffId = currentStaffData.staffId;
    newMemberData.membership =
        currentStaffData.hasMembership == true ? membership : 0;
    newMemberData.gender = gender;
    newMemberData.birthYear = (DateTime.now().year - age).toString();
    newMemberData.canAuthenticate = false;
    newMemberData.isBlocked = false;
    newMemberData.createdAt = DateTime.now().toString().replaceAll(' ', 'T');
    newMemberData.qrCodeURL = '';
    newMemberData.qrCodeURL = '';
    newMemberData.sync = sync;
    newMemberData.isBlacklist = false;
    newMemberData.operation = 'ADD';

    memberDataBox.put(newMemberData);

    offlinePickedMember = newMemberData;
    offlineAllMembersData.insert(0, newMemberData);
    offlineSortedMemberData = offlineAllMembersData;

    Provider.of<AllMembersProvider>(context, listen: false).setNotifyListner();
  }

  //Insert New Subscription////////////////////////////////////////////////////////

  static void insertNewSubscription({
    String registrationId,
    bool registrationIsActive,
    int registartionAttended,
    String registartionExpiresAt,
    bool isFreezed,
    String registartionCreatedAt,
    String packageId,
    double paidInDouble,
    bool sync,
  }) {
    Registrations newRegistration = Registrations();
    newRegistration.id = 0;
    newRegistration.registrationId = registrationId;
    newRegistration.registrationIsActive = registrationIsActive;
    newRegistration.registrationAttended = registartionAttended;
    newRegistration.registrationExpiresAt = registartionExpiresAt;
    newRegistration.isFreezed = isFreezed;
    newRegistration.registrationCreatedAt = registartionCreatedAt;
    newRegistration.packageId = packageId;
    newRegistration.paidInDouble = paidInDouble;
    newRegistration.staffId = currentStaffData.staffId;
    newRegistration.memberId = workConnectionStatus == 'offline'
        ? offlinePickedMember.memberId
        : pickedMember.memberId;
    newRegistration.clubId = currentStaffData.staffClubId;
    newRegistration.sync = false;
    newRegistration.operation = 'ADD';

    registrationsBox.put(newRegistration);
    offlineAllRegistrationsList.insert(0, newRegistration);
  }

  //Insert New note

  static void insertNewNote({String note, bool sync}) {
    Notes notes = Notes();
    notes.createdAt = DateTime.now().toString();
    notes.id = 0;
    notes.noteMaker = currentStaffData.staffName;
    notes.note = note;

    notesBox.put(notes);
  }

  //Insert New Attandance//////////////////////////////////////////////////////////

  static void insertNewAttendance(
      {String registrationId, String packageId, bool sync}) {
    MemberAttendencesData newAttendence = MemberAttendencesData();
    newAttendence.id = 0;
    newAttendence.attendenceId = DateTime.now().toString();
    newAttendence.clubId = currentStaffData.staffClubId;
    newAttendence.registrationId = registrationId;
    newAttendence.packageId = packageId;
    newAttendence.staffId = currentStaffData.staffId;
    newAttendence.memberId = workConnectionStatus == 'offline'
        ? offlinePickedMember.memberId
        : pickedMember.memberId;
    newAttendence.createdAt = DateTime.now().toString().replaceAll(' ', 'T');
    newAttendence.sync = sync;
    newAttendence.operation = 'ADD';

    memberAttendenceDataBox.put(newAttendence);
    offlineAllAttendancesList.insert(0, newAttendence);
  }

  //Update Member Attandance////////////////////////////////////////////////////

  static void updateMemberAttandance(
      Registrations updatedRegistration, BuildContext context, bool sync) {
    updatedRegistration.registrationAttended++;
    updatedRegistration.sync = sync;
    updatedRegistration.operation = 'UPDATE';

    registrationsBox.put(updatedRegistration);

    MemberAttendencesData memberAttendance = MemberAttendencesData();
    memberAttendance.id = 0;
    memberAttendance.attendenceId = DateTime.now().toString();
    memberAttendance.clubId = currentStaffData.staffClubId;
    memberAttendance.createdAt = DateTime.now().toString().replaceAll(' ', 'T');
    memberAttendance.memberId = workConnectionStatus == 'offline'
        ? offlinePickedMember.memberId
        : pickedMember.memberId;
    memberAttendance.staffId = currentStaffData.staffId;
    memberAttendance.packageId = updatedRegistration.packageId;
    memberAttendance.registrationId = updatedRegistration.registrationId;
    memberAttendance.sync = sync;
    memberAttendance.operation = 'UPDATE';

    offlineAllAttendancesList.insert(0, memberAttendance);

    memberAttendenceDataBox.removeAll();
    memberAttendenceDataBox.putMany(offlineAllAttendancesList);

    Provider.of<AllMemberRegistartionsProvider>(context, listen: false)
        .setNotifyListner();
  }

  //Remove member Attandance///////////////////////////////////////////////////

  static void removeMemberAttendance(
      Registrations updatedRegistration, BuildContext context, bool sync) {
    updatedRegistration.registrationAttended--;
    updatedRegistration.sync = sync;
    updatedRegistration.operation = 'UPDATE';
    registrationsBox.put(updatedRegistration);

    var memberAttendances = offlineAllAttendancesList
        .where((element) =>
            element.registrationId == updatedRegistration.registrationId)
        .toList();

    memberAttendances[0].operation = 'DELETE';
    memberAttendances[0].sync = sync;
    memberAttendenceDataBox.put(memberAttendances[0]);
    Provider.of<AllMemberRegistartionsProvider>(context, listen: false)
        .setNotifyListner();
  }

  //Block Member////////////////////////////////////////////////////////////////

  static void blockOrUnblockMember(String memberId, bool sync) {
    var updatedMember = offlineAllMembersData
        .firstWhere((element) => element.memberId == memberId);

    updatedMember.isBlocked = !updatedMember.isBlocked;
    updatedMember.sync = sync;
    updatedMember.operation = 'UPDATE';
    memberDataBox.put(updatedMember);

    offlinePickedMember = updatedMember;
  }

  //BlackListmember Member////////////////////////////////////////////////////////////////

  static void addtoBlackListOrRemoveFromBlacklist(
      String memberId, bool sync, BuildContext context) {
    var updatedMember = offlineAllMembersData
        .firstWhere((element) => element.memberId == memberId);

    updatedMember.isBlacklist = !updatedMember.isBlacklist;
    updatedMember.sync = sync;
    updatedMember.operation = 'UPDATE';
    memberDataBox.put(updatedMember);

    offlinePickedMember = updatedMember;
    Provider.of<AllMemberRegistartionsProvider>(context, listen: false)
        .setNotifyListner();
  }

  //Freeze Registration//////////////////////////////////////////

  static void freezeRegistration(
      {String registartionId,
      String packageId,
      String freezeDuration,
      bool sync,
      MemberData memberData,
      BuildContext context}) {
    var updatedRegistration = workConnectionStatus == 'offline'
        ? offlinePickedMemberAllRegistrationsList
            .firstWhere((element) => element.registrationId == registartionId)
        : offlineAllRegistrationsList
            .firstWhere((element) => element.registrationId == registartionId);

    FreezeData freezeData = FreezeData();
    freezeData.id = 0;
    freezeData.clubId = currentStaffData.staffClubId;
    freezeData.freezeDuration = freezeDuration;
    freezeData.freezeId = const Uuid().v1();
    freezeData.memberId = memberData.memberId;
    freezeData.packageId = packageId;
    freezeData.reactivationDate =
        calcExpirationOReActivationDate(freezeDuration);
    freezeData.registrationId = registartionId;
    freezeData.staffId = currentStaffData.staffId;
    freezeData.sync = sync;
    freezeData.operation = 'ADD';
    freezeData.registrationNewExpirationDate =
        calcNewExpirationDateForRegistartion(
            updatedRegistration.registrationExpiresAt, freezeDuration);

    offlineAllFreezeList.insert(0, freezeData);
    freezeBox.putMany(offlineAllFreezeList);

    updatedRegistration.isFreezed = true;
    updatedRegistration.operation = 'UPDATE';
    updatedRegistration.sync = sync;
    updatedRegistration.registrationExpiresAt =
        calcNewExpirationDateForRegistartion(
            updatedRegistration.registrationExpiresAt, freezeDuration);

    registrationsBox.put(updatedRegistration);
    Provider.of<AllMemberRegistartionsProvider>(context, listen: false)
        .setNotifyListner();
  }

  //Reactivate Registration//////////////////////////////////////////

  static void reactivateRegistration(
      {String registartionId,
      bool sync,
      MemberData memberData,
      BuildContext context}) {
    var updatedRegistration = workConnectionStatus == 'offline'
        ? offlinePickedMemberAllRegistrationsList
            .firstWhere((element) => element.registrationId == registartionId)
        : offlineAllRegistrationsList
            .firstWhere((element) => element.registrationId == registartionId);

    var updatedFreeze = offlineAllFreezeList
        .firstWhere((element) => element.registrationId == registartionId);

    updatedFreeze.sync = sync;
    updatedFreeze.operation = 'UPDATE';
    updatedFreeze.reactivation = {
      currentStaffData.staffId: DateTime.now().toString()
    };

    freezeBox.put(updatedFreeze);

    updatedRegistration.isFreezed = false;
    updatedRegistration.operation = 'UPDATE';
    updatedRegistration.sync = sync;

    registrationsBox.put(updatedRegistration);
    Provider.of<AllMemberRegistartionsProvider>(context, listen: false)
        .setNotifyListner();
  }

  //Remove a registartion//////////////////////////////////////////////////////
  static void removeMemberRegistration(
      String registrationId, BuildContext context, bool sync) {
    var updatedRegistration = offlineAllRegistrationsList
        .firstWhere((element) => element.registrationId == registrationId);

    updatedRegistration.sync = sync;
    updatedRegistration.operation = 'DELETE';
    registrationsBox.put(updatedRegistration);

    var memberAttendances = offlineAllAttendancesList
        .where((element) =>
            element.registrationId == updatedRegistration.registrationId)
        .toList();

    for (var element in memberAttendances) {
      element.operation = 'DELETE';
      element.sync = sync;
      memberAttendenceDataBox.put(element);
    }

    Provider.of<AllMemberRegistartionsProvider>(context, listen: false)
        .setNotifyListner();
  }

  //Delete All Club Data///////////////////////////////////////////////////////

  static void deleteClubData() {
    // print(
    //     'Freeze List //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////');
    // for (var element in offlineAllFreezeList) {
    //   print('clubId ::: ${element.clubId}');
    //   print('freezeDuration ::: ${element.freezeDuration}');
    //   print('freezeId ::: ${element.freezeId}');
    //   print('id ::: ${element.id}');
    //   print('memberId ::: ${element.memberId}');
    //   print('operation ::: ${element.operation}');
    //   print('packageId ::: ${element.packageId}');
    //   print('reactivation ::: ${element.reactivation}');
    //   print('reactivationDate ::: ${element.reactivationDate}');
    //   print('registrationId ::: ${element.registrationId}');
    //   print(
    //       'registrationNewExpirationDate ::: ${element.registrationNewExpirationDate}');
    //   print('staffId ::: ${element.staffId}');
    //   print('sync ::: ${element.sync}');
    //   print(
    //       ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::');
    // }

    // print(
    //     'Member Data List /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////');
    // for (var element in offlineAllMembersData) {
    //   print('clubId ::: ${element.clubId}');
    //   print('id ::: ${element.id}');
    //   print('memberId ::: ${element.memberId}');
    //   print('operation ::: ${element.operation}');
    //   print('staffId ::: ${element.staffId}');
    //   print('sync ::: ${element.sync}');
    //   print('birthYear ::: ${element.birthYear}');
    //   print('canAuthenticate ::: ${element.canAuthenticate}');
    //   print('countryCode ::: ${element.countryCode}');
    //   print('createdAt ::: ${element.createdAt}');
    //   print('gender ::: ${element.gender}');
    //   print('isBlocked ::: ${element.isBlocked}');
    //   print('membership ::: ${element.membership}');
    //   print('memberPhone ::: ${element.memberPhone}');
    //   print('memberName ::: ${element.memberName}');
    //   print('qrCodeURL ::: ${element.qrCodeURL}');
    //   print('qrCodeUUID ::: ${element.qrCodeUUID}');

    //   print(
    //       ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::');
    // }

    // print(
    //     'Registrations Data List /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////');
    // for (var element in offlineAllRegistrationsList) {
    //   print('clubId ::: ${element.clubId}');
    //   print('id ::: ${element.id}');
    //   print('isFreezed ::: ${element.isFreezed}');
    //   print('memberId ::: ${element.memberId}');
    //   print('operation ::: ${element.operation}');
    //   print('packageId ::: ${element.packageId}');
    //   print('paidInDouble ::: ${element.paidInDouble}');
    //   print('registrationAttended ::: ${element.registrationAttended}');
    //   print('registrationCreatedAt ::: ${element.registrationCreatedAt}');
    //   print('registrationExpiresAt ::: ${element.registrationExpiresAt}');
    //   print('clubId ::: ${element.registrationId}');
    //   print('registrationIsActive ::: ${element.registrationIsActive}');
    //   print('staffId ::: ${element.staffId}');
    //   print('sync ::: ${element.sync}');

    //   print(
    //       ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::');
    // }

    // print(
    //     'Member Attendances Data List /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////');
    // for (var element in offlineAllAttendancesList) {
    //   print('clubId ::: ${element.clubId}');
    //   print('attendenceId ::: ${element.attendenceId}');
    //   print('createdAt ::: ${element.createdAt}');
    //   print('memberId ::: ${element.memberId}');
    //   print('operation ::: ${element.operation}');
    //   print('packageId ::: ${element.packageId}');
    //   print('registrationId ::: ${element.registrationId}');
    //   print('staffId ::: ${element.staffId}');
    //   print('sync ::: ${element.sync}');

    //   print(
    //       ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::');
    // }

    // print(
    //     'Packages Data List /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////');
    // for (var element in offlineAllPlansList) {
    //   print('createdAt ::: ${element.createdAt}');
    //   print('id ::: ${element.id}');
    //   print('isOpen ::: ${element.isOpen}');
    //   print('planAttendance ::: ${element.planAttendance}');
    //   print('planClubId ::: ${element.planClubId}');
    //   print('planExpiresIn ::: ${element.planExpiresIn}');
    //   print('planId ::: ${element.planId}');
    //   print('planPriceAsDouble ::: ${element.planPriceAsDouble}');
    //   print('planTitle ::: ${element.planTitle}');

    //   print(
    //       ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::');
    // }

    allMembersList = [];
    sortedMemberData = [];
    offlineAllRegistrationsList = [];
    offlineAllAttendancesList = [];
    offlineAllPlansList = [];
    offlineAllFreezeList = [];
    memberDataBox.removeAll();
    registrationsBox.removeAll();
    memberAttendenceDataBox.removeAll();
    planDataBox.removeAll();
    freezeBox.removeAll();
  }

  //Get All Club Data//////////////////////////////////////////////////////////

  static void getClubData() {
    offlineAllMembersData = memberDataBox.getAll().toList();
    offlineSortedMemberData = memberDataBox.getAll().toList();
    offlineAllRegistrationsList = registrationsBox.getAll().toList();
    offlineAllAttendancesList = memberAttendenceDataBox.getAll().toList();
    offlineAllPlansList = planDataBox.getAll().toList();
    offlineAllFreezeList = freezeBox.getAll().toList();

    //sorting registrations
    offlineAllRegistrationsList.sort((a, b) {
      return DateTime.parse(a.registrationCreatedAt)
          .compareTo(DateTime.parse(b.registrationCreatedAt));
    });
    offlineAllRegistrationsList = offlineAllRegistrationsList.reversed.toList();

    //sorting members//////////////////////////////////////////////////////////
    offlineAllMembersData.sort((a, b) {
      return DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt));
    });
    offlineAllMembersData = offlineAllMembersData.reversed.toList();

    offlineSortedMemberData.sort((a, b) {
      return DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt));
    });
    offlineSortedMemberData = offlineSortedMemberData.reversed.toList();

    //Sorting Member Attadances////////////////////////////////////////////////
    offlineAllAttendancesList.sort((a, b) {
      return DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt));
    });
    offlineAllAttendancesList = offlineAllAttendancesList.reversed.toList();
  }

  //Check wheather datbase is empty////////////////////////////////////////////

  static bool checkDatabaseIsEmpty() {
    if (memberDataBox.isEmpty() ||
        memberDataBox == null && registrationsBox.isEmpty() ||
        registrationsBox == null && memberAttendenceDataBox.isEmpty() ||
        memberAttendenceDataBox == null && planDataBox.isEmpty() ||
        planDataBox == null) {
      return true;
    } else {
      return false;
    }
  }

  //Check If email is unique/////////////////////////////////////////////////////

  static bool checkEmailIsUnique(String email) {
    var result = allMembersList.firstWhere(
        (element) => element.memberEmail == email,
        orElse: () => null);
    if (result == null) {
      return true;
    } else {
      return false;
    }
  }

  //Check if phone is unique///////////////////////////////////////////////////

  static bool checkPhoneIsUnique(String phone) {
    var result = allMembersList.firstWhere(
        (element) => element.memberPhone == phone,
        orElse: () => null);
    if (result == null) {
      return true;
    } else {
      return false;
    }
  }

  //Check if membership is unique///////////////////////////////////////////////

  static bool checkMembershipIsUnique(int membership) {
    var result = allMembersList.firstWhere(
        (element) => element.membership == membership,
        orElse: () => null);
    if (result == null) {
      return true;
    } else {
      return false;
    }
  }

  //check If Member Already Registered In A package////////////////////////////////////////////////////////////////

  static bool checkIfMemberAlreadyRegisteredInApackage(String memberId) {
    var allActiveregistrations = offlineAllRegistrationsList
        .where((element) => element.registrationIsActive == true)
        .toList();

    if (allActiveregistrations.isNotEmpty) {
      var result = allActiveregistrations.firstWhere(
          (element) => element.memberId == memberId,
          orElse: () => null);

      if (result == null) {
        // el user dah ma3andoosh active reservation
        return false;
      } else {
        // el user 3ando active reservation
        return true;
      }
    } else {
      return false;
    }
  }

  //check If Member Already Registered In A package////////////////////////////////////////////////////////////////

  static String checkIfRegistrationIsActiveOrExpired(String registrationId) {
    var pickedRegistration = offlineAllRegistrationsList
        .firstWhere((element) => element.registrationId == registrationId);

    if (pickedRegistration.registrationIsActive == true) {
      return 'active';
    } else {
      return 'expired';
    }
  }

  //check If Member Already Registered In A package And Freezed///////////////////////////////////////////////

  static bool checkIfMemberAlreadyRegisteredInApackageAndFreezed(
      String memberId) {
    var allFreezedRegistrations = offlineAllRegistrationsList
        .where((element) => element.isFreezed == true)
        .toList();

    if (allFreezedRegistrations.isNotEmpty) {
      var result = allFreezedRegistrations.firstWhere(
          (element) => element.memberId == memberId,
          orElse: () => null);

      if (result == null) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
}
