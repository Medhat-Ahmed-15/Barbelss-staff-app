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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    try {
      getAllPlans().then((value) {
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
      });
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
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
            ),
          ),
          Positioned(
              bottom: 7,
              left: 150,
              right: 150,
              child: Container(
                height: 20,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.black26),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 100, right: 15),
                child: Text(
                  AppLocalizations.of(context).chooseAPlanTitle,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1.color,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
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
                                itemBuilder: (BuildContext context, int index) {
                                  return PlanDataTile(allPlansList[index]);
                                },
                                itemCount: allPlansList.length,
                                itemWidth: 300.0,
                                itemHeight: 500.0,
                                loop: true,
                                layout: SwiperLayout.STACK,
                              ),
              )
            ],
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                localeLanguage == const Locale('en')
                    ? Icons.arrow_back
                    : Icons.arrow_forward,
                color: Theme.of(context).iconTheme.color,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
