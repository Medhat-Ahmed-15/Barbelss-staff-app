// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/models/registrations.dart';
import 'package:gym_staff_app/screens/memberPackageDetailsScreen.dart';
import 'package:gym_staff_app/widgets/dialogs/confirmDeleteRegistrationDialog.dart';

class OfflineMemberPackageDataTile extends StatefulWidget {
  Registrations memberRegistrations;
  Function refresh;

  OfflineMemberPackageDataTile(this.memberRegistrations, this.refresh);

  @override
  State<OfflineMemberPackageDataTile> createState() =>
      _OfflineMemberPackageDataTileState();
}

class _OfflineMemberPackageDataTileState
    extends State<OfflineMemberPackageDataTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        offlinePickedMemberPackage = widget.memberRegistrations;
        await Navigator.pushNamed(
            context, MemberPackageDetailsScreen.routeName);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        width: MediaQuery.of(context).size.width,
        height: 190,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Dismissible(
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
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) =>
                        ConfirmDeleteRegistrationDialog(
                      itemToDelete: 'registration',
                      registrationId: widget.memberRegistrations.registrationId,
                    ),
                  );

                  widget.refresh();
                },
                confirmDismiss: (direction) async {
                  return true;
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: ListTile(
                    title: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              )),
                          child: Text(
                            offlineAllPlansList
                                .firstWhere((element) =>
                                    element.planId ==
                                    widget.memberRegistrations.packageId)
                                .planTitle,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline2.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppLocalizations.of(context).attendedTitle,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline2.color,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${widget.memberRegistrations.registrationAttended}/${offlineAllPlansList.firstWhere((element) => element.planId == widget.memberRegistrations.packageId).planAttendance}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppLocalizations.of(context).expirationDateTitle,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline2.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          convertDateToDayInNumberMonthInText(
                                  widget.memberRegistrations
                                      .registrationExpiresAt,
                                  context) +
                              " " +
                              convertTimeTo12HFormat(widget
                                  .memberRegistrations.registrationExpiresAt),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.all(4),
                    trailing: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.memberRegistrations.isFreezed == true
                            ? Colors.blue
                            : widget.memberRegistrations.registrationIsActive ==
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
                        widget.memberRegistrations.isFreezed == true
                            ? AppLocalizations.of(context).freezed
                            : widget.memberRegistrations.registrationIsActive ==
                                    false
                                ? AppLocalizations.of(context).inActiveTitle
                                : AppLocalizations.of(context).activeTitle,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
