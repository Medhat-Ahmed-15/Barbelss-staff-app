// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_staff_app/models/memberAttendencesData.dart';
import 'package:gym_staff_app/models/memberData.dart';
import 'package:gym_staff_app/models/planData.dart';
import 'package:gym_staff_app/models/staffData.dart';
import 'models/memberRegistrationsResponseData.dart';

String token = '';
String qrCodeURL = '';
String qrCodeUUID = '';
String addNewMemberFieldKey;
String addedName = '';
String addedEmail = '';
String addedMembership = '';
String addedPhone = '';
String addedPhoneCode = '';
String freezeButtonText = '';

bool addedVerifyMember = false;
bool showConnectedToInternetPopUp = false;

var localeLanguage = const Locale('en');

StaffData currentStaffData;

List<MemberData> allMembersList = [];
List<MemberData> allMembersListFromMobileStorage = [];
List<MemberRegistrationsResponseData> allMemberRegistrationsList;
List<PlanData> allPlansList;
List<PlanData> allPlansListFromMobileStorage;
List<MemberAttendencesData> allMemberAttendencesList;

MemberData pickedMember;

MemberRegistrationsResponseData pickedMemberPackage;
