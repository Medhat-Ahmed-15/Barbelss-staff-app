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
  int sync;
  String operation;

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
      this.sync,
      this.operation,
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
    isBlocked = json['isBlocked'] == 0
        ? false
        : json['isBlocked'] == 1
            ? true
            : json['isBlocked'];
    createdAt = json['createdAt'];
    memberPhone = json['phone'];
    sync = json['sync'];
    createdAt = json['createdAt'];
    operation = json['operation'];
    countryCode = json['countryCode'];
    qrCodeURL = json['QRCodeURL'];
    qrCodeUUID = json['QRCodeUUID'];
    canAuthenticate = json['canAuthenticate'] == 0
        ? false
        : json['canAuthenticate'] == 1
            ? true
            : json['canAuthenticate'];
  }
}
