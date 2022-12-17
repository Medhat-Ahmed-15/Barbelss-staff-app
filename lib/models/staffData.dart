// ignore_for_file: file_names

class StaffData {
  String staffId;
  String staffClubId;
  String staffName;
  String staffEmail;
  String staffPhone;
  String staffCountryCode;
  String clubName;
  bool hasMembership;

  StaffData(
      {this.staffId,
      this.staffClubId,
      this.staffName,
      this.staffEmail,
      this.staffPhone,
      this.hasMembership,
      this.staffCountryCode,
      this.clubName});
}
