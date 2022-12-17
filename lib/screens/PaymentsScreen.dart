import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../tabs/inventory_tab.dart';

class PaymentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: () {
              ZoomDrawer.of(context).toggle();
            },
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).iconTheme.color,
              size: 30,
            ),
          ),
          title: Text(
            AppLocalizations.of(context).payments,
            style: TextStyle(
                color: Theme.of(context).textTheme.headline1.color,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).scaffoldBackgroundColor,
            tabs: const [
              Tab(icon: Icon(Icons.inventory_outlined), text: "Inventory"),
              Tab(
                icon: Icon(Icons.feed_sharp),
                text: "Bills",
              ),
              Tab(
                icon: Icon(Icons.attach_money_rounded),
                text: 'Payroll',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            InventoryTab(),
            InventoryTab(),
            InventoryTab(),
          ],
        ),
      ),
    );
  }
}
