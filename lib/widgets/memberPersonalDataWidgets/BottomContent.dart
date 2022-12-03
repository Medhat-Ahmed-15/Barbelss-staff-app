import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:lottie/lottie.dart' as lot;

import '../dialogs/confirmDeleteRegistrationDialog.dart';

class BottomContent extends StatefulWidget {
  @override
  State<BottomContent> createState() => _BottomContentState();
}

class _BottomContentState extends State<BottomContent> {
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
                    ? offlinePickedMember.notes.isEmpty
                    : pickedMember.notes.isEmpty
                        ? Center(
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: lot.LottieBuilder.asset(
                                  'assets/gifs/empty.json'),
                            ),
                          )
                        : ListView.separated(
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
                                            noteId: workConnectionStatus ==
                                                    'offline'
                                                ? offlinePickedMember
                                                    .notes[index].noteId
                                                : pickedMember
                                                    .notes[index].noteId),
                                  );
                                  setState(() {});
                                },
                                confirmDismiss: (direction) async {
                                  return true;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 22),
                                  child: Text(workConnectionStatus == 'offline'
                                      ? offlinePickedMember.notes[index].note
                                      : pickedMember.notes[index].note),
                                ),
                              );
                            },
                            itemCount: workConnectionStatus == 'offline'
                                ? offlinePickedMember.notes.length
                                : pickedMember.notes.length,
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
