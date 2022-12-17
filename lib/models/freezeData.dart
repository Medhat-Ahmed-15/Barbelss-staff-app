import 'package:objectbox/objectbox.dart';

@Entity()
class FreezeData {
  int id;
  @Index()
  String freezeId;
  String clubId;
  String staffId;
  String memberId;
  String registrationId;
  String packageId;
  String reactivationDate;
  String freezeDuration;
  String createdAt;
  String registrationNewExpirationDate;
  String registrationOldExpirationDate;
  Map<String, dynamic> reactivation;
  bool sync;
  String operation;

  //  "updatedAt": "2022-11-05T13:53:41.568Z",

  FreezeData(
      {this.id,
      this.freezeId,
      this.clubId,
      this.staffId,
      this.memberId,
      this.createdAt,
      this.registrationId,
      this.packageId,
      this.reactivationDate,
      this.freezeDuration,
      this.registrationNewExpirationDate,
      this.registrationOldExpirationDate,
      this.sync,
      this.operation,
      this.reactivation});

  FreezeData.fromjson(Map<String, dynamic> json) {
    memberId = json['memberId'];
    clubId = json['clubId'];
    staffId = json['staffId'];
    freezeId = json['_id'];
    registrationId = json['registrationId'];
    packageId = json['packageId'];
    reactivationDate = json['reactivationDate'];
    freezeDuration = json['freezeDuration'];
    registrationNewExpirationDate = json['registrationNewExpirationDate'];
    reactivation = json['reactivation'];
    createdAt = json['createdAt'];
    registrationOldExpirationDate = '';
    sync = true;
    operation = '';
  }
}
