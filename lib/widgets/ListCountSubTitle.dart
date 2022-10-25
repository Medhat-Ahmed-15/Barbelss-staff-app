import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../globalVariables.dart';

class ListCountSubTitle extends StatelessWidget {
  bool empty;
  String listName;

  ListCountSubTitle(
    this.empty,
    this.listName,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context).searchResultsContains,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          listName == 'members'
              ? '${empty == true || allMembersList == null ? 0 : allMembersList.length}'
              : listName == 'registrations'
                  ? '${empty == true || allMemberRegistrationsList == null ? 0 : allMemberRegistrationsList.length}'
                  : '${empty == true || allMemberAttendencesList == null ? 0 : allMemberAttendencesList.length}',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          listName == 'members'
              ? AppLocalizations.of(context).members
              : listName == 'registrations'
                  ? AppLocalizations.of(context).registrations
                  : AppLocalizations.of(context).attendences,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
