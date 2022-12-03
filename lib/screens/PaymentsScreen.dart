import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
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
      ),
      body: Center(
        child: Text('Payments Screen'),
      ),
    );
  }
}
