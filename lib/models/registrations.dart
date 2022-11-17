// ignore_for_file: file_names

import 'package:objectbox/objectbox.dart';

@Entity()
class Registrations {
  int id;
  String registrationId;
  bool registrationIsActive;
  int registrationAttended;
  String registrationExpiresAt;
  bool isFreezed;
  String registrationCreatedAt;
  String packageId;
  String clubId;
  String memberId;
  String staffId;
  int paid;

  Registrations(
      {this.id = 1,
      this.registrationId,
      this.registrationIsActive,
      this.registrationAttended,
      this.registrationExpiresAt,
      this.isFreezed,
      this.registrationCreatedAt,
      this.packageId,
      this.clubId,
      this.memberId,
      this.staffId,
      this.paid});

  Registrations.fromjson(Map<String, dynamic> json) {
    registrationId = json['_id'];
    registrationIsActive = json['isActive'];
    registrationAttended = json['attended'];
    registrationExpiresAt = json['expiresAt'];
    isFreezed = json['isFreezed'];
    registrationCreatedAt = json['createdAt'];
    packageId = json['packageId'];
    paid = json['paid'];
    staffId = json['staffId'];
    memberId = json['memberId'];
    clubId = json['clubId'];
  }
}
