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
  String registrationNewExpirationDate;
  Map<String, String> reactivation;
  bool sync;
  String operation;

  FreezeData(
      {this.id,
      this.freezeId,
      this.clubId,
      this.staffId,
      this.memberId,
      this.registrationId,
      this.packageId,
      this.reactivationDate,
      this.freezeDuration,
      this.registrationNewExpirationDate,
      this.sync,
      this.operation,
      this.reactivation});
}
