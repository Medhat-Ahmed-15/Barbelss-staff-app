import 'package:flutter/material.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/widgets/other/ListCountSubTitle.dart';
import '../../screens/memberPersonalDataScreen.dart';

class MemberDetailsCentralCard extends StatelessWidget {
  bool empty = false;

  MemberDetailsCentralCard(this.empty);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      key: memberDetailsScreenCentralCardKey,
      top: MediaQuery.of(context).size.height * 0.2,
      left: MediaQuery.of(context).size.width * 0.1,
      right: MediaQuery.of(context).size.width * 0.1,
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0, 4),
                      blurRadius: 5.0)
                ],
                color: Theme.of(context).scaffoldBackgroundColor),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Theme.of(context).primaryColor,
                    radius: 45,
                    child: Text(
                      workConnectionStatus == 'offline'
                          ? offlinePickedMember.memberName.contains(' ')
                              ? offlinePickedMember.memberName[0]
                                      .toUpperCase() +
                                  offlinePickedMember.memberName
                                      .split(' ')[1][0]
                                      .toUpperCase()
                              : pickedMember.memberName[0].toUpperCase()
                          : pickedMember.memberName.contains(' ')
                              ? pickedMember.memberName[0].toUpperCase() +
                                  pickedMember.memberName
                                      .split(' ')[1][0]
                                      .toUpperCase()
                              : pickedMember.memberName[0].toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    workConnectionStatus == 'offline'
                        ? offlinePickedMember.memberName
                        : pickedMember.memberName,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  TextButton(
                      child: Text(
                        AppLocalizations.of(context).showMore,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, MemberPersonalDataScreen.routeName);
                      }),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListCountSubTitle(
            empty: empty,
            listName: 'registrations',
          )
        ],
      ),
    );
  }
}
