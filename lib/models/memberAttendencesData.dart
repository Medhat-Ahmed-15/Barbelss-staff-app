// ignore_for_file: file_names

class MemberAttendencesData {
  String attendenceId;
  String clubId;
  String registrationId;
  String packageId;
  String staffId;
  String memberId;
  String createdAt;
  String staffName;

  MemberAttendencesData.fromjson(Map<String, dynamic> json) {
    attendenceId = json['_id'];
    clubId = json['clubId'];
    registrationId = json['registrationId'];
    packageId = json['packageId'];
    staffId = json['staffId'];
    memberId = json['memberId'];
    createdAt = json['createdAt'];
    staffName = json['staff'][0]['name'];
  }
}
