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
      height: 170,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of(context).staffName,
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline2.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    memberAttendencesData.staffName,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range_rounded,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of(context).attendenceTme,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline2.color,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    convertTimeTo12HFormat(memberAttendencesData.createdAt),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                convertDateToDayInNumberMonthInText(
                    memberAttendencesData.createdAt),
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
