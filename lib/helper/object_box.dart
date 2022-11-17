import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/models/memberAttendencesData.dart';
import 'package:gym_staff_app/models/planData.dart';
import 'package:gym_staff_app/models/registrations.dart';

import '../models/memberData.dart';
import '../objectbox.g.dart';

class ObjectBox {
  static Future<void> init() async {
    store = await openStore();

    memberDataBox = Box<MemberData>(store);
    registrationsBox = Box<Registrations>(store);
    memberAttendenceDataBox = Box<MemberAttendencesData>(store);
    planDataBox = Box<PlanData>(store);
  }

  static void closeStore() {
    store.close();
  }

  static void insertClubData() {
    memberDataBox.putMany(allMembersOfflineData);
    registrationsBox.putMany(allRegistrationsOfflineData);
    memberAttendenceDataBox.putMany(allAttendencesOfflineData);
    planDataBox.putMany(allPlansOfflineData);
  }

  static void deleteClubData() {
    allMembersList = [];
    allRegistrationsOfflineData = [];
    allAttendencesOfflineData = [];
    allPlansOfflineData = [];
    memberDataBox.removeAll();
    registrationsBox.removeAll();
    memberAttendenceDataBox.removeAll();
    planDataBox.removeAll();
  }

  static void getClubData() {
    allMembersList = memberDataBox.getAll().reversed.toList();
    allRegistrationsOfflineData = registrationsBox.getAll().reversed.toList();
    allAttendencesOfflineData =
        memberAttendenceDataBox.getAll().reversed.toList();
    allPlansOfflineData = planDataBox.getAll().reversed.toList();
  }

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
}
