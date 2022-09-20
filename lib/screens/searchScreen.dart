// ignore_for_file: file_names

import 'dart:io';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart' as lot;
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/models/memberData.dart';
import 'package:gym_staff_app/screens/addNewMemberScreen.dart';
import 'package:gym_staff_app/widgets/searchScreenWidgets/memberDataTile.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../Exceptions/getRequest_exception.dart';
import '../globalVariables.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool folded = true;

  bool loadingMembersData = true;
  bool connectionError = false;
  bool empty = false;
  final searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(currentStaffData.staffClubId);
    print(currentStaffData.staffCountryCode);
    print(currentStaffData.staffEmail);
    print(currentStaffData.staffId);
    print(currentStaffData.staffName);
    print(currentStaffData.staffPhone);

    try {
      getAllMembers().then((value) {
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
      });
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
  }

  Future<void> refresh() async {
    try {
      getAllMembers().then((value) {
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
      });
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
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
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Search title
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 100, right: 15),
                child: Text(
                  AppLocalizations.of(context).searchForAMember,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1.color,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              // Search bar
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 400,
                  ),
                  width:
                      folded == true ? 60 : MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 2),
                    boxShadow: kElevationToShadow[1],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            child: folded == false
                                ? TextField(
                                    controller: searchController,
                                    cursorColor: Theme.of(context).primaryColor,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.all(16.0),
                                      hintText: AppLocalizations.of(context)
                                          .searchBarHintTitle,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[600]),
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
                                          if (memberData.memberPhone
                                              .startsWith(value)) {
                                            sortedMemberData.add(memberData);
                                          }
                                        }
                                        if (sortedMemberData.isEmpty &&
                                            value != '') {
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
                                  )
                                : null),
                      ),
                      InkWell(
                        highlightColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            folded == true ? Icons.search : Icons.close,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onTap: () async {
                          print('1');
                          if (folded == false) {
                            print('2');
                            print('Current Value::${searchController.text}:::');
                            if (searchController.text == '') {
                              print('3');
                              setState(() {
                                folded = !folded;
                                connectionError = false;
                                loadingMembersData = false;
                              });
                              return;
                            }
                            print('4');
                            try {
                              setState(() {
                                connectionError = false;
                                loadingMembersData = true;
                                empty = false;
                              });
                              await getAllMembers();
                              print('5');
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
                          }
                          print('6');
                          setState(() {
                            folded = !folded;
                            connectionError = false;
                            loadingMembersData = false;
                          });
                          print('7');
                          searchController.text = '';
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: connectionError == true
                      ? Column(
                          children: [
                            Expanded(child: Container()),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 250,
                                height: 250,
                                child: lot.LottieBuilder.asset(
                                    'assets/gifs/error.json'),
                              ),
                            ),
                            Text(AppLocalizations.of(context)
                                .connectionStatusMessage),
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
                                    return refresh();
                                  },
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    itemBuilder: (context, index) {
                                      return MemberDataTile(
                                          allMembersList[index]);
                                    },
                                    itemCount: allMembersList.length,
                                  ),
                                ),
                ),
              ),

              // //Empty logo
              // Padding(
              //   padding: const EdgeInsets.only(top: 200),
              //   child: Align(
              //     alignment: Alignment.center,
              //     child: SizedBox(
              //       height: 130,
              //       width: 130,
              //       child: Image.asset('assets/images/empty.png'),
              //     ),
              //   ),
              // )
            ],
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              onPressed: () {
                ZoomDrawer.of(context).toggle();
              },
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).iconTheme.color,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: OpenContainer(
        transitionDuration: const Duration(seconds: 1),
        closedColor: Theme.of(context).primaryColor,
        openColor: Theme.of(context).primaryColor,
        closedShape: const CircleBorder(),
        openBuilder: (context, _) => AddNewMemberScreen(),
        closedBuilder: (context, openContainer) => FloatingActionButton(
          heroTag: 'btn1',
          child: Icon(
            Icons.add,
            size: 30,
            color: Theme.of(context).iconTheme.color,
          ),

          onPressed: openContainer,
          // label: Text(
          //   'New member',
          //   style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       color: Theme.of(context).textTheme.headline1.color),
          // ),
          //icon:
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
