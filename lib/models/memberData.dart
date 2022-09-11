// ignore_for_file: file_names

class MemberData {
  String memberId;
  String clubId;
  String memberName;
  String memberEmail;
  String memberPhone;
  String countryCode;
  String qrCodeURL;
  String qrCodeUUID;
  bool canAuthenticate;

  MemberData(
      {this.clubId,
      this.countryCode,
      this.memberEmail,
      this.qrCodeURL,
      this.qrCodeUUID,
      this.memberId,
      this.memberName,
      this.memberPhone});

  MemberData.fromjson(Map<String, dynamic> json) {
    memberId = json['_id'];
    clubId = json['clubId'];
    memberName = json['name'];
    memberEmail = json['email'];
    memberPhone = json['phone'];
    countryCode = json['countryCode'];
    qrCodeURL = json['QRCodeURL'];
    qrCodeUUID = json['QRCodeUUID'];
    canAuthenticate = json['canAuthenticate'];
  }
}
