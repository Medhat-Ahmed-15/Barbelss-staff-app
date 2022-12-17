// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_staff_app/Exceptions/getRequest_exception.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/helper/object_box.dart';
import 'package:gym_staff_app/providers/all_members_provider.dart';
import 'package:gym_staff_app/widgets/other/FourDotsLoading.dart';
import 'package:provider/provider.dart';
import '../assistant/assistantFunction.dart';
import '../widgets/dialogs/feedBackDialog.dart';

class AddNewNoteScreen extends StatefulWidget {
  static const routeName = '/AddNewNoteScreen';

  @override
  State<AddNewNoteScreen> createState() => _AddNewNoteScreenState();
}

class _AddNewNoteScreenState extends State<AddNewNoteScreen> {
  bool loading = false;

  TextEditingController noteController = TextEditingController();
  FocusNode noteFocusNode = FocusNode();
  String noteErrorMessage;

  Future<void> saveNote() async {
    if (noteController.text.toString().trim().isEmpty) {
      setState(() {
        noteErrorMessage = AppLocalizations.of(context).youMustAddNoteToSave;
      });
      return;
    }
    try {
      setState(() {
        loading = true;
      });
      if (workConnectionStatus == 'offline') {
        ObjectBox.insertNewNote(
            note: noteController.text.toString().trim(),
            sync: false,
            context: context);
      } else {
        await Provider.of<AllMembersProvider>(context, listen: false)
            .addNotes(context, noteController.text.toString().trim());
      }

      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => FeedBackDialog(
            titleText: AppLocalizations.of(context).noteAddedsccessfully,
            gif: 'assets/gifs/success.json',
            enableButton: true,
            buttonText: AppLocalizations.of(context).doneTitle,
            callBackFunction: () {
              Navigator.of(context).pop();
            },
            buttonColor: Theme.of(context).primaryColor),
      );

      Navigator.of(context).pop();
      setState(() {
        loading = false;
      });
    } on GetRequestException catch (error) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => FeedBackDialog(
            titleText: error.toStringMessage(),
            gif: 'assets/gifs/fail.json',
            enableButton: true,
            buttonText: AppLocalizations.of(context).doneTitle,
            callBackFunction: () {
              Navigator.of(context).pop();
            },
            buttonColor: Colors.redAccent),
      );

      setState(() {
        loading = false;
      });
    } on SocketException {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => FeedBackDialog(
            titleText: AppLocalizations.of(context).connectionStatusMessage,
            gif: 'assets/gifs/fail.json',
            enableButton: true,
            buttonText: AppLocalizations.of(context).doneTitle,
            callBackFunction: () {
              Navigator.of(context).pop();
            },
            buttonColor: Colors.redAccent),
      );

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              localeLanguage == const Locale('en')
                  ? Icons.arrow_back
                  : Icons.arrow_forward,
              color: Theme.of(context).iconTheme.color,
              size: 25,
            ),
          ),
          title: Text(
            AppLocalizations.of(context).addNote,
            style: TextStyle(
                color: Theme.of(context).textTheme.headline1.color,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 0, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),

              //Note TextField
              TextField(
                controller: noteController,
                onTap: () {
                  setState(() {
                    noteErrorMessage = '';
                  });
                },
                focusNode: noteFocusNode,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline2.color,
                ),
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.note_add,
                      color: noteFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.black54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: noteFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.black54),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: noteFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.black54),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  labelText: AppLocalizations.of(context).notes,
                  errorText: noteErrorMessage == '' ? null : noteErrorMessage,
                  labelStyle: TextStyle(
                    color: noteFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Colors.black54,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              loading == true
                  ? FourDotsLoading()
                  : Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 56,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                              overlayColor: MaterialStateProperty.all(
                                  Theme.of(context).scaffoldBackgroundColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ))),
                          onPressed: () async {
                            await saveNote();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: Text(
                              AppLocalizations.of(context).addNote,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      .color,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ));
  }
}
