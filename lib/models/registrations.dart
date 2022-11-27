// ignore_for_file: file_names

import 'package:objectbox/objectbox.dart';

@Entity()
class Registrations {
  int id;
  @Index()
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
  double paidInDouble;
  bool sync;
  String operation;

  Registrations(
      {this.id,
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
      this.paidInDouble,
      this.sync = true,
      this.operation = ''});

  Registrations.fromjson(Map<String, dynamic> json) {
    registrationId = json['_id'];
    registrationIsActive = json['isActive'];
    registrationAttended = json['attended'];
    registrationExpiresAt = json['expiresAt'];
    isFreezed = json['isFreezed'];
    registrationCreatedAt = json['createdAt'];
    packageId = json['packageId'];
    paidInDouble = json['paid'].toDouble();
    staffId = json['staffId'];
    memberId = json['memberId'];
    clubId = json['clubId'];
    sync = true;
    operation = '';
  }
}
