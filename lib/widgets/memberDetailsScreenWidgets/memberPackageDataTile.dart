// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/models/memberRegistrationsResponseData.dart';
import 'package:gym_staff_app/screens/memberDetailsScreen.dart';
import 'package:gym_staff_app/screens/memberPackageDetailsScreen.dart';

class MemberPackageDataTile extends StatelessWidget {
  MemberRegistrationsResponseData memberRegistrationsResponseData;
  Function refresh;
  MemberPackageDataTile(
    this.memberRegistrationsResponseData,
    this.refresh,
  );
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        pickedMemberPackage = memberRegistrationsResponseData;
        var response = await Navigator.pushNamed(
            context, MemberPackageDetailsScreen.routeName);
        if (response == true) {
          await refresh();
        }
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            width: MediaQuery.of(context).size.width,
            height: 135,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    margin: const EdgeInsets.all(15),
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.delete,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) async {
                    await deleteRegistration(
                        context: context,
                        registrationId:
                            memberRegistrationsResponseData.registrationId);

                    await refresh();
                  },
                  confirmDismiss: (direction) async {
                    return true;
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: ListTile(
                        title: Row(
                          children: [
                            Text(
                              memberRegistrationsResponseData.packageTitle,
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline2.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            memberRegistrationsResponseData.isFreezed == true
                                ? const Text(
                                    '(Freezed)',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 11),
                                  )
                                : const Text('')
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Theme.of(context).primaryColor,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${AppLocalizations.of(context).attendedTitle}: ',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .color,
                                  ),
                                ),
                                Text(
                                  '${memberRegistrationsResponseData.registrationAttended}/${memberRegistrationsResponseData.packageAttendance}',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .color,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.lock_clock,
                                  color: Theme.of(context).primaryColor,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${AppLocalizations.of(context).expirationDateTitle} ',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .color,
                                  ),
                                ),
                                Text(
                                  convertDateToDayInNumberMonthInText(
                                          memberRegistrationsResponseData
                                              .registrationExpiresAt) +
                                      " " +
                                      convertTimeTo12HFormat(
                                          memberRegistrationsResponseData
                                              .registrationExpiresAt),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .color,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        contentPadding: const EdgeInsets.all(4),
                        trailing: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: memberRegistrationsResponseData
                                        .registrationIsActive ==
                                    false
                                ? Colors.redAccent
                                : Colors.green,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 4),
                                  blurRadius: 5.0)
                            ],
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            memberRegistrationsResponseData
                                        .registrationIsActive ==
                                    false
                                ? AppLocalizations.of(context).inActiveTitle
                                : AppLocalizations.of(context).activeTitle,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1.color,
                            ),
                          ),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          memberRegistrationsResponseData.isFreezed == true
              ? Container(
                  margin: const EdgeInsets.only(right: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 135,
                  decoration: const BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                )
              : const Text('')
        ],
      ),
    );
  }
}
