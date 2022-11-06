// ignore_for_file: file_names

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

  MemberRegistrationsResponseData({
    this.registrationId,
    this.registrationIsActive,
    this.registrationAttended,
    this.registrationExpiresAt,
    this.isFreezed,
    this.registrationCreatedAt,
    this.packageId,
    this.packageTitle,
    this.packageAttendance,
    this.packageExpiresIn,
  });

  MemberRegistrationsResponseData.fromjson(Map<String, dynamic> json) {
    registrationId = json['_id'];
    registrationIsActive = json['isActive'];
    registrationAttended = json['attended'];
    registrationExpiresAt = json['expiresAt'];
    isFreezed = json['isFreezed'];
    registrationCreatedAt = json['createdAt'];

    packageId = json['package'][0]['_id'];
    packageTitle = json['package'][0]['title'];
    packageAttendance = json['package'][0]['attendance'];
    packageExpiresIn = json['package'][0]['expiresIn'];
  }
}
