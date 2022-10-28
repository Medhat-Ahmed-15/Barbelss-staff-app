// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_tv/flutter_swiper.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/widgets/plansScreenWidgets/planDataTile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart' as lot;

import '../widgets/other/EmptyAnimationWidget.dart';
import '../widgets/other/FourDotsLoading.dart';
import '../widgets/other/InternetConnectionError.dart';

class PlansScreen extends StatefulWidget {
  static const routeName = '/PlansScreen';

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  bool loadingPlans = true;
  bool connectionError = false;
  bool empty = false;
  bool isInit = false;

  String screenComingFrom;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    try {
      await getAllPlans();

      if (allPlansList.isEmpty) {
        setState(() {
          loadingPlans = false;
          connectionError = false;
          empty = true;
        });
      } else {
        setState(() {
          loadingPlans = false;
          connectionError = false;
          empty = false;
        });
      }
    } on SocketException {
      setState(() {
        connectionError = true;
        loadingPlans = false;
        empty = false;
      });
    } catch (error) {
      showToast(AppLocalizations.of(context).somethingWentWrong, context);
    }
  }

  Future<void> refresh() async {
    try {
      setState(() {
        loadingPlans = true;
        connectionError = false;
        empty = false;
      });
      await getAllPlans();
      if (allPlansList.isEmpty) {
        setState(() {
          loadingPlans = false;
          connectionError = false;
          empty = true;
        });
      } else {
        setState(() {
          loadingPlans = false;
          connectionError = false;
          empty = false;
        });
      }
    } on SocketException {
      setState(() {
        connectionError = true;
        loadingPlans = false;
        empty = false;
      });
    } catch (error) {
      showToast(AppLocalizations.of(context).somethingWentWrong, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenComingFrom = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await refresh();
            },
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).iconTheme.color,
              size: 25,
            ),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 100,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
            size: 25,
          ),
        ),
        title: Text(
          AppLocalizations.of(context).chooseAPlanTitle,
          style: TextStyle(
              color: Theme.of(context).textTheme.headline1.color,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
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
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: connectionError == true
                ? InternetConnectionError(refresh)
                : loadingPlans == true
                    ? FourDotsLoading()
                    : empty == true
                        ? const EmptyAnimationWidget()
                        : Swiper(
                            outer: true,
                            pagination: const SwiperPagination(
                              builder: SwiperPagination.dots,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return PlanDataTile(
                                  allPlansList[index], screenComingFrom);
                            },
                            itemCount: allPlansList.length,
                            itemWidth: 300.0,
                            itemHeight: 550.0,
                            loop: true,
                            layout: SwiperLayout.STACK,
                          ),
          ),
        ],
      ),
    );
  }
}
