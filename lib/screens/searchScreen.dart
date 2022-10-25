// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/screens/addNewMemeberScreen.dart';
import 'package:lottie/lottie.dart' as lot;
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/models/memberData.dart';
import 'package:gym_staff_app/widgets/searchScreenWidgets/memberDataTile.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Exceptions/getRequest_exception.dart';
import '../globalVariables.dart';
import '../widgets/feedBackDialog.dart';
import '../widgets/scanQrCodeDialog.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool loadingMembersData = true;
  bool connectionError = false;
  bool empty = false;
  bool isInit = true;
  bool confirmationLoading = false;
  String barcodeData;
  final searchController = TextEditingController();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit == true) {
      try {
        await getAllMembers(context);
        if (allMembersList.isEmpty) {
          setState(() {
            loadingMembersData = false;
            connectionError = false;
            empty = true;
          });
        } else {
          setState(() {
            loadingMembersData = false;
            connectionError = false;
            empty = false;
          });
        }
      } on SocketException {
        setState(() {
          connectionError = true;
          loadingMembersData = false;
          empty = false;
        });
      } on GetRequestException {
        setState(() {
          connectionError = false;
          loadingMembersData = false;
          empty = true;
        });
      }
    }
    isInit = false;
  }

  Future<void> refresh(BuildContext context) async {
    try {
      await getAllMembers(context);

      if (allMembersList.isEmpty) {
        setState(() {
          loadingMembersData = false;
          connectionError = false;
          empty = true;
        });
      } else {
        setState(() {
          loadingMembersData = false;
          connectionError = false;
          empty = false;
        });
      }
    } on SocketException {
      setState(() {
        connectionError = true;
        loadingMembersData = false;
        empty = false;
      });
    } on GetRequestException {
      setState(() {
        connectionError = false;
        loadingMembersData = false;
        empty = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          //upper container containing burger button and title
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0, 4),
                        blurRadius: 5.0)
                  ],
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0))),
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          ZoomDrawer.of(context).toggle();
                        },
                        icon: Icon(
                          Icons.menu,
                          color: Theme.of(context).iconTheme.color,
                          size: 25,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AddNewMemberScreen.routeName);
                        },
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).iconTheme.color,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          //search textfield
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 120,
                left: 15,
                right: 15,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: kElevationToShadow[1],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search,
                              color: Theme.of(context).primaryColor),
                          hintText:
                              AppLocalizations.of(context).searchBarHintTitle,
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) async {
                          List<MemberData> sortedMemberData = [];

                          try {
                            setState(() {
                              connectionError = false;
                              empty = false;
                              loadingMembersData = true;
                            });
                            await getAllMembers(context);

                            for (var memberData in allMembersList) {
                              if (memberData.memberPhone.startsWith(value)) {
                                sortedMemberData.add(memberData);
                              }
                            }
                            if (sortedMemberData.isEmpty && value != '') {
                              setState(() {
                                empty = true;
                                loadingMembersData = false;
                                connectionError = false;
                              });
                            } else {
                              setState(() {
                                allMembersList = sortedMemberData;
                                loadingMembersData = false;
                                connectionError = false;
                              });
                            }
                          } on SocketException {
                            setState(() {
                              connectionError = true;
                              loadingMembersData = false;
                              empty = false;
                            });
                          } on GetRequestException catch (error) {
                            setState(() {
                              connectionError = false;
                              loadingMembersData = true;
                              empty = false;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //number of members
          Positioned(
            child: Padding(
                padding: EdgeInsets.only(
                    top: 200,
                    left: localeLanguage == const Locale('en') ? 50 : 0,
                    right: localeLanguage != const Locale('en') ? 50 : 0),
                child: Row(
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
                      '${empty == true ? 0 : allMembersList.length}',
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
                      AppLocalizations.of(context).members,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )),
          ),

          //Members List
          Padding(
            padding: const EdgeInsets.only(
              top: 230,
              left: 15,
              right: 15,
            ),
            child: connectionError == true
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Container()),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 250,
                          height: 250,
                          child:
                              lot.LottieBuilder.asset('assets/gifs/error.json'),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 45,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).scaffoldBackgroundColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline2
                                              .color)))),
                          onPressed: () async {
                            refresh(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: Text(
                              AppLocalizations.of(context).tryAgain,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .color,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  )
                : loadingMembersData == true
                    ? Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: Theme.of(context).primaryColor,
                          size: 50,
                        ),
                      )
                    : empty == true
                        ? Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: lot.LottieBuilder.asset(
                                  'assets/gifs/empty.json'),
                            ),
                          )
                        : RefreshIndicator(
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 5,
                            onRefresh: () {
                              return refresh(context);
                            },
                            child: Scrollbar(
                              thumbVisibility: true,
                              interactive: true,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (context, index) {
                                  return MemberDataTile(allMembersList[index]);
                                },
                                itemCount: allMembersList.length,
                              ),
                            ),
                          ),
          ),

          confirmationLoading == true
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Theme.of(context).primaryColor,
                      size: 50,
                    ),
                  ),
                  color: Colors.black38,
                )
              : const SizedBox(
                  height: 0,
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'btn1',
        child: Icon(
          Icons.qr_code,
          size: 30,
          color: Theme.of(context).iconTheme.color,
        ),
        onPressed: () async {
          String value = await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => ScanQrCodeDialog(),
          );

          if (value == null) {
            return;
          } else {
            barcodeData = value;

            if (barcodeData == 'Failed To Scan') {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) => FeedBackDialog(
                    titleText: barcodeData,
                    gif: 'assets/gifs/fail.json',
                    enableButton: true,
                    buttonText: AppLocalizations.of(context).doneTitle,
                    callBackFunction: () {
                      Navigator.of(context).pop();
                    },
                    buttonColor: Colors.redAccent),
              );
            } else {
              try {
                setState(() {
                  confirmationLoading = true;
                });
                Map decodedBarcodeData = json.decode(barcodeData);

                await addAttendanceBymember(
                    context: context, memberId: decodedBarcodeData['memberId']);

                setState(() {
                  confirmationLoading = false;
                });
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) => FeedBackDialog(
                      titleText: AppLocalizations.of(context)
                          .updatedAttendenceSuccessfully,
                      gif: 'assets/gifs/success.json',
                      enableButton: true,
                      buttonText: AppLocalizations.of(context).doneTitle,
                      callBackFunction: () {
                        Navigator.of(context).pop();
                      },
                      buttonColor: Theme.of(context).primaryColor),
                );
              } on GetRequestException catch (error) {
                setState(() {
                  confirmationLoading = false;
                });
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
              } on SocketException {
                setState(() {
                  confirmationLoading = false;
                });
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) => FeedBackDialog(
                      titleText:
                          AppLocalizations.of(context).connectionStatusMessage,
                      gif: 'assets/gifs/fail.json',
                      enableButton: true,
                      buttonText: AppLocalizations.of(context).doneTitle,
                      callBackFunction: () {
                        Navigator.of(context).pop();
                      },
                      buttonColor: Colors.redAccent),
                );
              }
            }
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
