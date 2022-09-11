// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';

class userDataListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 20,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).primaryColor,
        radius: 25,
        child: Text(
          currentStaffData.staffName.contains(' ')
              ? currentStaffData.staffName[0] +
                  currentStaffData.staffName.split(' ')[1][0]
              : currentStaffData.staffName[0],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        currentStaffData.staffName,
        style: TextStyle(
            color: Theme.of(context).textTheme.headline1.color,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
