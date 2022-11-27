import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:numeral/fun.dart';

class ListCountSubTitle extends StatelessWidget {
  bool empty;
  String listName;
  int membersListCount;

  ListCountSubTitle({this.empty, this.listName, this.membersListCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Container()),
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
          workConnectionStatus == 'offline'
              ? listName == 'members'
                  ? '${empty == true || membersListCount == null ? 0 : numeral(membersListCount)}'
                  : '${empty == true || offlinePickedMemberAllRegistrationsList.where((element) => element.operation != 'delete').toList() == null ? 0 : numeral(offlinePickedMemberAllRegistrationsList.where((element) => element.operation != 'delete').toList().length)}'
              : listName == 'members'
                  ? '${empty == true || membersListCount == null ? 0 : numeral(membersListCount)}'
                  : '${empty == true || allMemberRegistrationsList == null ? 0 : numeral(allMemberRegistrationsList.length)}',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis),
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
        Expanded(child: Container()),
      ],
    );
  }
}
