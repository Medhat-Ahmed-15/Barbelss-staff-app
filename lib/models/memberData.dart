// ignore_for_file: file_names

import 'dart:math';

import 'package:objectbox/objectbox.dart';

@Entity()
class MemberData {
  int id;
  @Index()
  String memberId;
  String clubId;
  String memberName;
  String memberEmail;
  String memberPhone;
  String countryCode;
  String gender;
  String staffId;
  String birthYear;
  int membership;
  String qrCodeURL;
  String qrCodeUUID;
  bool canAuthenticate;
  bool isBlocked;
  String createdAt;
  bool sync;
  String operation;
  bool isBlacklist;
  List<Notes> notes;

  MemberData(
      {this.id,
      this.clubId,
      this.countryCode,
      this.memberEmail,
      this.membership,
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
      this.memberPhone,
      this.isBlacklist,
      this.notes,
      this.sync = true,
      this.operation = ''});

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
    membership = json['membership'];
    memberPhone = json['phone'];
    isBlacklist = json['isBlacklist'];
    countryCode = json['countryCode'];
    qrCodeURL = json['QRCodeURL'];
    qrCodeUUID = json['QRCodeUUID'];
    canAuthenticate = json['canAuthenticate'];
    notes =
        (json['notes'] as List).map((index) => Notes.fromjson(index)).toList();
    sync = true;
    operation = '';
  }
}

@Entity()
class Notes {
  int id;
  String noteMaker;
  String note;
  String createdAt;
  @Index()
  String noteId;

  Notes({
    this.id,
    this.noteMaker,
    this.createdAt,
    this.note,
    this.noteId,
  });

  Notes.fromjson(Map<String, dynamic> json) {
    noteMaker = json['noteMaker'];
    note = json['note'];
    createdAt = json['createdAt'];
    noteId = json['_id'];
  }
}
