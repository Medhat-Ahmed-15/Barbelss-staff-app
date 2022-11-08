// ignore_for_file: file_names

import 'package:gym_staff_app/models/memberAttendencesData.dart';

class MemberRegistrationsResponseData {
  String registrationId;
  bool registrationIsActive;
  int registrationAttended;
  String registrationExpiresAt;
  bool isFreezed;
  String registrationCreatedAt;
  String packageId;
  String packageTitle;
  int packageAttendance;
  String packageExpiresIn;
  List<MemberAttendencesData> memberAttendencesData;

  MemberRegistrationsResponseData(
      {this.registrationId,
      this.registrationIsActive,
      this.registrationAttended,
      this.registrationExpiresAt,
      this.isFreezed,
      this.registrationCreatedAt,
      this.packageId,
      this.packageTitle,
      this.packageAttendance,
      this.packageExpiresIn,
      this.memberAttendencesData});

  MemberRegistrationsResponseData.fromjson(Map<String, dynamic> json) {
    registrationId = json['_id'];
    registrationIsActive = json['isActive'];
    registrationAttended = json['attended'];
    registrationExpiresAt = json['expiresAt'];
    isFreezed = json['isFreezed'];
    registrationCreatedAt = json['createdAt'];

    packageId = json['package']['_id'];
    packageTitle = json['package']['title'];
    packageAttendance = json['package']['attendance'];
    packageExpiresIn = json['package']['expiresIn'];
    memberAttendencesData = (json['attendances'] as List)
        .map((index) => MemberAttendencesData.fromjson(index))
        .toList();
  }
}
