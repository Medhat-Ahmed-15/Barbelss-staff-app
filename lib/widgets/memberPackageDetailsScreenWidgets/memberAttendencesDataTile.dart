// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/screens/memberPackageDetailsScreen.dart';

import '../../assistant/assistantFunction.dart';
import '../../models/memberAttendencesData.dart';

class MemberAttendencesDataTile extends StatelessWidget {
  MemberAttendencesData memberAttendencesData;
  MemberAttendencesDataTile(this.memberAttendencesData);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: ListTile(
              leading: Icon(
                Icons.date_range_rounded,
                color: Theme.of(context).primaryColor,
                size: 25,
              ),
              title: Text(
                AppLocalizations.of(context).attendenceTme,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline2.color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                convertTimeTo12HFormat(memberAttendencesData.createdAt),
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              trailing: Text(
                convertDateToDayInNumberMonthInText(
                    memberAttendencesData.createdAt, context),
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              contentPadding: const EdgeInsets.all(4),
            ),
          ),
        ],
      ),
    );
  }
}
