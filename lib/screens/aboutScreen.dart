// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutScreen extends StatefulWidget {
  static const String routeName = "AboutScreen";

  @override
  _MyAboutScreenState createState() => _MyAboutScreenState();
}

class _MyAboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: () {
              // ZoomDrawer.of(context).toggle();
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).iconTheme.color,
              size: 30,
            ),
          ),
          title: Text(
            AppLocalizations.of(context).aboutUsIconTitle,
            style: TextStyle(
                color: Theme.of(context).textTheme.headline1.color,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/b8.png',
                      height: 130,
                      width: 130,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                child: SizedBox(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Container(
                  color: Theme.of(context).primaryColor,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'FOLLOW US ON',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Divider(
                        endIndent: 10,
                        indent: 10,
                        color: Colors.grey[800],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/facebook.png',
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Image.asset(
                            'assets/images/twitter.png',
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Image.asset(
                            'assets/images/instagram.png',
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Image.asset(
                            'assets/images/linkedin.png',
                            height: 30,
                            width: 30,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
