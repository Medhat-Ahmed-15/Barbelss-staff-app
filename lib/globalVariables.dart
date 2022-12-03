// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gym_staff_app/models/freezeData.dart';
import 'package:gym_staff_app/models/memberData.dart';
import 'package:gym_staff_app/models/planData.dart';
import 'package:gym_staff_app/models/registrations.dart';
import 'package:gym_staff_app/models/staffData.dart';
import 'models/memberAttendencesData.dart';
import 'models/memberRegistrationsResponseData.dart';
import 'objectbox.g.dart';

Store store;

Box<MemberData> memberDataBox;
Box<Registrations> registrationsBox;
Box<MemberAttendencesData> memberAttendenceDataBox;
Box<PlanData> planDataBox;
Box<FreezeData> freezeBox;
Box<Notes> notesBox;

String token = '';
String qrCodeURL = '';
String qrCodeUUID = '';
String addNewMemberFieldKey;
String loginFieldKey;
String workConnectionStatus;

bool addedVerifyMember = false;
bool showConnectedToInternetPopUp = false;

var localeLanguage = const Locale('en');

StaffData currentStaffData;
Key memberDetailsScreenCentralCardKey;

List<MemberData> allMembersList = [];
List<MemberData> sortedMemberData = [];
List<MemberRegistrationsResponseData> allMemberRegistrationsList = [];
List<PlanData> allPlansList = [];

List<MemberData> offlineAllMembersData = [];
List<MemberData> offlineSortedMemberData = [];
List<PlanData> offlineAllPlansList = [];
List<Registrations> offlineAllRegistrationsList = [];
List<Registrations> offlinePickedMemberAllRegistrationsList = [];
List<MemberAttendencesData> offlineAllAttendancesList = [];
List<FreezeData> offlineAllFreezeList = [];

MemberData pickedMember;
MemberData offlinePickedMember;

MemberRegistrationsResponseData pickedMemberPackage;
Registrations offlinePickedMemberPackage;

MaterialColor primaryColor = const MaterialColor(
  0x00061828,
  <int, Color>{
    50: Color(0x00061828),
    100: Color(0x00061828),
    200: Color(0x00061828),
    300: Color(0x00061828),
    400: Color(0x00061828),
    500: Color(0x00061828),
    600: Color(0x00061828),
    700: Color(0x00061828),
    800: Color(0x00061828),
    900: Color(0x00061828),
  },
);
