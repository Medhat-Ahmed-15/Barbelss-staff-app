// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/models/memberData.dart';
import 'package:gym_staff_app/widgets/other/EmptyAnimationWidget.dart';
import 'package:gym_staff_app/widgets/other/FourDotsLoading.dart';
import 'package:gym_staff_app/widgets/other/ListCountSubTitle.dart';
import 'package:gym_staff_app/widgets/searchScreenWidgets/memberDataTile.dart';
import '../Exceptions/getRequest_exception.dart';
import '../globalVariables.dart';
import '../widgets/dialogs/feedBackDialog.dart';
import '../widgets/dialogs/scanQrCodeDialog.dart';
import '../widgets/other/InternetConnectionError.dart';
import '../widgets/searchScreenWidgets/upperContainer.dart';

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
        await getAllMembers();
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
      } catch (error) {
        showToast(AppLocalizations.of(context).somethingWentWrong, context);
      }
    }
    isInit = false;
  }

  Future<void> refresh() async {
    try {
      setState(() {
        loadingMembersData = true;
        connectionError = false;
        empty = false;
      });
      await getAllMembers();

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
    } catch (error) {
      showToast(AppLocalizations.of(context).somethingWentWrong, context);
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
          const upperContainer(),
          //search textfield and list count
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: kElevationToShadow[1],
                      ),
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
                            await getAllMembers();

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
                          } on GetRequestException {
                            setState(() {
                              connectionError = false;
                              loadingMembersData = false;
                              empty = true;
                            });
                          } catch (error) {
                            showToast(
                                AppLocalizations.of(context).somethingWentWrong,
                                context);

                            setState(() {
                              loadingMembersData = false;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListCountSubTitle(empty, 'members'),
                  ),
                ],
              ),
            ),
          ),

          //Members List
          Padding(
            padding: const EdgeInsets.only(
              top: 230,
              left: 15,
              right: 15,
            ),
            child: connectionError == true
                ? InternetConnectionError(refresh)
                : loadingMembersData == true
                    ? FourDotsLoading()
                    : empty == true
                        ? const EmptyAnimationWidget()
                        : RefreshIndicator(
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 5,
                            onRefresh: () {
                              return refresh();
                            },
                            child: ListView.builder(
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                return MemberDataTile(
                                    allMembersList[index], refresh);
                              },
                              itemCount: allMembersList.length,
                            ),
                          ),
          ),

          confirmationLoading == true
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: FourDotsLoading(),
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
              } catch (error) {
                showToast(
                    AppLocalizations.of(context).somethingWentWrong, context);
              }
            }
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
