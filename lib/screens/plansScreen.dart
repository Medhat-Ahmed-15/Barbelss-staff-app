// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_tv/flutter_swiper.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/widgets/plansScreenWidgets/planDataTile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../helper/object_box.dart';
import '../providers/offlineFeature_provider.dart';
import '../widgets/other/EmptyAnimationWidget.dart';
import '../widgets/other/FourDotsLoading.dart';
import '../widgets/other/InternetConnectionError.dart';

class PlansScreen extends StatefulWidget {
  static const routeName = '/PlansScreen';

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  bool loadingPlans = false;
  bool connectionError = false;

  String screenComingFrom;

  Future<void> refresh() async {
    if (workConnectionStatus == 'online') {
      try {
        setState(() {
          loadingPlans = true;
          connectionError = false;
        });
        await getAllPlans();
        setState(() {
          loadingPlans = false;
          connectionError = false;
        });
      } on SocketException {
        setState(() {
          connectionError = true;
          loadingPlans = false;
        });
      } catch (error) {
        // showToast(AppLocalizations.of(context).somethingWentWrong, context);
        setState(() {
          connectionError = false;
          loadingPlans = false;
        });
      }
    } else {
      ObjectBox.getClubData();

      setState(() {
        loadingPlans = false;
        connectionError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<OfflineFeautureProvider>(context, listen: true);

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
            child: workConnectionStatus == 'offline'
                ? offlineAllPlansList.isEmpty
                    ? EmptyAnimationWidget(refresh)
                    : Swiper(
                        outer: true,
                        pagination: const SwiperPagination(
                          builder: SwiperPagination.dots,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return PlanDataTile(
                              offlineAllPlansList[index], screenComingFrom);
                        },
                        itemCount: offlineAllPlansList.length,
                        itemWidth: MediaQuery.of(context).size.width * 0.75,
                        itemHeight: MediaQuery.of(context).size.height * 0.7,
                        loop: true,
                        layout: SwiperLayout.STACK,
                      )
                : connectionError == true
                    ? InternetConnectionError(refresh)
                    : loadingPlans == true
                        ? FourDotsLoading()
                        : allPlansList.isEmpty
                            ? EmptyAnimationWidget(refresh)
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
                                itemWidth:
                                    MediaQuery.of(context).size.width * 0.75,
                                itemHeight:
                                    MediaQuery.of(context).size.height * 0.7,
                                loop: true,
                                layout: SwiperLayout.STACK,
                              ),
          ),
        ],
      ),
    );
  }
}
