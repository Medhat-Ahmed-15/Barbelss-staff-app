// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_tv/flutter_swiper.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/widgets/plansScreenWidgets/planDataTile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart' as lot;

class PlansScreen extends StatefulWidget {
  static const routeName = '/PlansScreen';

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  bool loadingMembersData = true;
  bool connectionError = false;
  bool empty = false;
  bool isInit = false;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    try {
      await getAllPlans();

      if (allPlansList.isEmpty) {
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
    }
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
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).iconTheme.color,
                      size: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    AppLocalizations.of(context).chooseAPlanTitle,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1.color,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 35,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Colors.grey[300]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
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
                              : Swiper(
                                  outer: true,
                                  pagination: const SwiperPagination(
                                    builder: SwiperPagination.dots,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return PlanDataTile(allPlansList[index]);
                                  },
                                  itemCount: allPlansList.length,
                                  itemWidth: 300.0,
                                  itemHeight: 550.0,
                                  loop: true,
                                  layout: SwiperLayout.STACK,
                                ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
