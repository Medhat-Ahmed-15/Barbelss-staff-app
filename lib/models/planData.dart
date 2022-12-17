// ignore: file_names
// ignore_for_file: file_names

import 'package:objectbox/objectbox.dart';

@Entity()
class PlanData {
  int id;
  @Index()
  String planId;
  String planClubId;
  String planTitle;
  int planAttendance;
  String planExpiresIn;
  double planPriceAsDouble;
  bool isOpen;
  String createdAt;

  PlanData({
    this.id,
    this.planId,
    this.planClubId,
    this.planTitle,
    this.planAttendance,
    this.planExpiresIn,
    this.isOpen,
    this.createdAt,
    this.planPriceAsDouble,
  });

  PlanData.fromjson(Map<String, dynamic> json) {
    planId = json['_id'];
    planClubId = json['clubId'];
    planTitle = json['title'];
    planAttendance = json['attendance'];
    planExpiresIn = json['expiresIn'];
    planPriceAsDouble = json['price'].toDouble();
    createdAt = json['createdAt'];
    isOpen = json['isOpen'];
  }
}
