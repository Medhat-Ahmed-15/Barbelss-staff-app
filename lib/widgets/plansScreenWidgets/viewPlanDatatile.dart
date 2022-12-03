// ignore_for_file: file_names, missing_return

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/models/planData.dart';

class ViewPlanDataTile extends StatefulWidget {
  PlanData planData;

  ViewPlanDataTile(this.planData);

  @override
  State<ViewPlanDataTile> createState() => _ViewPlanDataTileState();
}

class _ViewPlanDataTileState extends State<ViewPlanDataTile> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Theme.of(context).primaryColor, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(206, 206, 206, 1),
              offset: Offset(1, 3),
              blurRadius: 5.0,
            )
          ],
          color: Theme.of(context).scaffoldBackgroundColor),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 170,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0, 4),
                        blurRadius: 5.0)
                  ],
                  color: Theme.of(context).primaryColor),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.planData.planTitle,
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.planData.planPriceAsDouble.toString(),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline2.color,
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'EGP',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline2.color,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .numberOfSessionsTitle,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                widget.planData.planAttendance.toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).expiresInTitle,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.planData.planExpiresIn,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
