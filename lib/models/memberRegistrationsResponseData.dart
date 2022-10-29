// ignore_for_file: file_names

class MemberRegistrationsResponseData {
  String registrationId;
  String registrationClubId;
  bool registrationIsActive;
  int registrationAttended;
  String registrationExpiresAt;
  int registrationPaid;
  bool isFreezed;

  String memberId;
  String memberClubId;
  String memberName;
  String memmberEmail;
  String memberPhone;
  String memberCountryCode;

  String staffId;
  String staffClubId;
  String staffName;
  String staffEmail;
  String staffPhone;
  String staffCountryCode;

  String packageId;
  String packageClubId;
  String packageTitle;
  int packageAttendance;
  String packageExpiresIn;
  int packagePrice;

  MemberRegistrationsResponseData.fromjson(Map<String, dynamic> json) {
    registrationId = json['_id'];
    registrationClubId = json['clubId'];
    registrationIsActive = json['isActive'];
    registrationAttended = json['attended'];
    registrationExpiresAt = json['expiresAt'];
    registrationPaid = json['paid'];
    isFreezed = json['isFreezed'];

    memberId = json['member'][0]['_id'];
    memberClubId = json['member'][0]['clubId'];
    memberName = json['member'][0]['name'];
    memmberEmail = json['member'][0]['email'];
    memberPhone = json['member'][0]['phone'];
    memberCountryCode = json['member'][0]['countryCode'];

    staffId = json['staff'][0]['_id'];
    staffClubId = json['staff'][0]['clubId'];
    staffName = json['staff'][0]['name'];
    staffEmail = json['staff'][0]['email'];
    staffPhone = json['staff'][0]['phone'];
    staffCountryCode = json['staff'][0]['countryCode'];

    packageId = json['package'][0]['_id'];
    packageClubId = json['package'][0]['clubId'];
    packageTitle = json['package'][0]['title'];
    packageAttendance = json['package'][0]['attendance'];
    packageExpiresIn = json['package'][0]['expiresIn'];
    packagePrice = json['package'][0]['price'];
  }
}
