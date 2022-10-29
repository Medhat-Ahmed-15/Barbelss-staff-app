// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../widgets/dialogs/policyDialog.dart';

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
              ZoomDrawer.of(context).toggle();
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

              Divider(
                thickness: 1,
                endIndent: 10,
                indent: 10,
                color: Colors.grey[300],
              ),
              //Terms and Conditions
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    splashColor: Colors.blue,
                    hoverColor: Colors.blue,
                    highlightColor: Colors.blue,
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) => PolicyDialog(
                              mdFileName: 'terms_and_conditions.md'));
                    },
                    child: ListTile(
                      leading: Text(
                        AppLocalizations.of(context).termsAndConditionsTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      trailing: Icon(Icons.navigate_next,
                          size: 30, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),

              Divider(
                thickness: 1,
                endIndent: 10,
                indent: 10,
                color: Colors.grey[300],
              ),

              //Privacy Policy
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    splashColor: Colors.blue,
                    hoverColor: Colors.blue,
                    highlightColor: Colors.blue,
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) =>
                              PolicyDialog(mdFileName: 'privacy_policy.md'));
                    },
                    child: ListTile(
                      leading: Text(
                        AppLocalizations.of(context).privacyPolicy,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      trailing: Icon(Icons.navigate_next,
                          size: 30, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),

              Divider(
                thickness: 1,
                endIndent: 10,
                indent: 10,
                color: Colors.grey[300],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  padding: const EdgeInsets.only(top: 50, bottom: 50),
                  color: Theme.of(context).primaryColor,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).followUsOn,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context).poweredBy,
                            style: TextStyle(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                fontSize: 12),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            AppLocalizations.of(context).agile,
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const Text(
                        'version: 1.0.0+1',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
