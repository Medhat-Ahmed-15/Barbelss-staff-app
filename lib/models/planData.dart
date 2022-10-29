// ignore: file_names
// ignore_for_file: file_names

class PlanData {
  String planId;
  String planClubId;
  String planTitle;
  int planAttendance;
  String planExpiresIn;
  num planPrice;
  bool isOpen;
  String createdAt;

  PlanData(
      {this.planId,
      this.planClubId,
      this.planTitle,
      this.planAttendance,
      this.planExpiresIn,
      this.isOpen,
      this.createdAt,
      this.planPrice});

  PlanData.fromjson(Map<String, dynamic> json) {
    planId = json['_id'];
    planClubId = json['clubId'];
    planTitle = json['title'];
    planAttendance = json['attendance'];
    planExpiresIn = json['expiresIn'];
    planPrice = json['price'];
    createdAt = json['createdAt'];
    isOpen = json['isOpen'];
  }
}
