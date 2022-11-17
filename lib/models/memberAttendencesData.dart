// ignore_for_file: file_names

import 'package:objectbox/objectbox.dart';

@Entity()
class MemberAttendencesData {
  int id;
  String attendenceId;
  String clubId;
  String registrationId;
  String packageId;
  String staffId;
  String memberId;
  String createdAt;

  MemberAttendencesData(
      {this.id = 2,
      this.attendenceId,
      this.clubId,
      this.registrationId,
      this.packageId,
      this.staffId,
      this.memberId,
      this.createdAt});

  MemberAttendencesData.fromjson(Map<String, dynamic> json) {
    attendenceId = json['_id'];
    clubId = json['clubId'];
    registrationId = json['registrationId'];
    packageId = json['packageId'];
    staffId = json['staffId'];
    memberId = json['memberId'];
    createdAt = json['createdAt'];
  }
}
