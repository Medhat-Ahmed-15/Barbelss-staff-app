import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:lottie/lottie.dart' as lot;

import '../../assistant/assistantFunction.dart';
import '../dialogs/confirmDeleteRegistrationDialog.dart';

class BottomContent extends StatefulWidget {
  @override
  State<BottomContent> createState() => _BottomContentState();
}

class _BottomContentState extends State<BottomContent> {
  Widget notesList() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Dismissible(
            key: UniqueKey(),
            background: Container(
              margin: const EdgeInsets.all(5),
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.delete,
                size: 20,
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
                        itemToDelete: 'note',
                        noteId: workConnectionStatus == 'offline'
                            ? offlineMemberNotesList
                                .where((element) =>
                                    element.memberId ==
                                    offlinePickedMember.memberId)
                                .toList()
                                .where(
                                    (element) => element.operation != 'DELETE')
                                .toList()[index]
                                .noteId
                            : pickedMember.notes[index].noteId),
              );
              setState(() {});
            },
            confirmDismiss: (direction) async {
              return true;
            },
            child: ListTile(
              title: Text(workConnectionStatus == 'offline'
                  ? offlineMemberNotesList
                      .where((element) =>
                          element.memberId == offlinePickedMember.memberId)
                      .toList()
                      .where((element) => element.operation != 'DELETE')
                      .toList()[index]
                      .note
                  : pickedMember.notes[index].note),
              trailing: Text(
                convertDateToDayInNumberMonthInText(
                    workConnectionStatus == 'offline'
                        ? offlineMemberNotesList
                            .where((element) =>
                                element.memberId ==
                                offlinePickedMember.memberId)
                            .toList()
                            .where((element) => element.operation != 'DELETE')
                            .toList()[index]
                            .createdAt
                        : pickedMember.notes[index].createdAt,
                    context),
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ));
      },
      itemCount: workConnectionStatus == 'offline'
          ? offlineMemberNotesList
              .where(
                  (element) => element.memberId == offlinePickedMember.memberId)
              .toList()
              .where((element) => element.operation != 'DELETE')
              .toList()
              .length
          : pickedMember.notes.length,
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
      child: Container(
        padding: const EdgeInsets.only(
          left: 22,
          right: 22,
          top: 22,
          bottom: 22,
        ),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 0.5),
                  blurRadius: 5.0)
            ],
            color: Theme.of(context).scaffoldBackgroundColor),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).notes,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 300,
                  child: workConnectionStatus == 'offline'
                      ? offlineMemberNotesList
                              .where((element) =>
                                  element.memberId ==
                                  offlinePickedMember.memberId)
                              .toList()
                              .where((element) => element.operation != 'DELETE')
                              .toList()
                              .isEmpty
                          ? Center(
                              child: SizedBox(
                                width: 200,
                                height: 200,
                                child: lot.LottieBuilder.asset(
                                    'assets/gifs/empty.json'),
                              ),
                            )
                          : notesList()
                      : pickedMember.notes.isEmpty
                          ? Center(
                              child: SizedBox(
                                width: 200,
                                height: 200,
                                child: lot.LottieBuilder.asset(
                                    'assets/gifs/empty.json'),
                              ),
                            )
                          : notesList()),
            ],
          ),
        ),
      ),
    );
  }
}
