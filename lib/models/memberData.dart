// ignore_for_file: file_names

class MemberData {
  String memberId;
  String clubId;
  String memberName;
  String memberEmail;
  String memberPhone;
  String countryCode;
  String gender;
  String staffId;
  String birthYear;
  String qrCodeURL;
  String qrCodeUUID;
  bool canAuthenticate;
  bool isBlocked;
  String createdAt;

  MemberData(
      {this.clubId,
      this.countryCode,
      this.memberEmail,
      this.qrCodeURL,
      this.qrCodeUUID,
      this.staffId,
      this.gender,
      this.birthYear,
      this.isBlocked,
      this.createdAt,
      this.canAuthenticate,
      this.memberId,
      this.memberName,
      this.memberPhone});

  MemberData.fromjson(Map<String, dynamic> json) {
    memberId = json['_id'];
    clubId = json['clubId'];
    memberName = json['name'];
    staffId = json['staffId'];
    gender = json['gender'];
    memberEmail = json['email'];
    birthYear = json['birthYear'];
    isBlocked = json['isBlocked'];
    createdAt = json['createdAt'];
    memberPhone = json['phone'];
    countryCode = json['countryCode'];
    qrCodeURL = json['QRCodeURL'];
    qrCodeUUID = json['QRCodeUUID'];
    canAuthenticate = json['canAuthenticate'];
  }
}
