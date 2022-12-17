// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/models/memberRegistrationsResponseData.dart';
import 'package:gym_staff_app/screens/memberPackageDetailsScreen.dart';
import 'package:gym_staff_app/widgets/dialogs/confirmDeleteRegistrationDialog.dart';

class MemberPackageDataTile extends StatefulWidget {
  MemberRegistrationsResponseData memberRegistrationsResponseData;

  MemberPackageDataTile(
    this.memberRegistrationsResponseData,
  );

  @override
  State<MemberPackageDataTile> createState() => _MemberPackageDataTileState();
}

class _MemberPackageDataTileState extends State<MemberPackageDataTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        pickedMemberPackage = widget.memberRegistrationsResponseData;
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
                            registrationId: widget
                                .memberRegistrationsResponseData.registrationId,
                            itemToDelete: 'registration'),
                  );
                  setState(() {});
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
                            widget.memberRegistrationsResponseData.packageTitle,
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
                          '${widget.memberRegistrationsResponseData.registrationAttended}/${widget.memberRegistrationsResponseData.packageAttendance}',
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
                                  widget.memberRegistrationsResponseData
                                      .registrationExpiresAt,
                                  context) +
                              " " +
                              convertTimeTo12HFormat(widget
                                  .memberRegistrationsResponseData
                                  .registrationExpiresAt),
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
                        color:
                            widget.memberRegistrationsResponseData.isFreezed ==
                                    true
                                ? Colors.blue
                                : widget.memberRegistrationsResponseData
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
                        widget.memberRegistrationsResponseData.isFreezed == true
                            ? AppLocalizations.of(context).freezed
                            : widget.memberRegistrationsResponseData
                                        .registrationIsActive ==
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
