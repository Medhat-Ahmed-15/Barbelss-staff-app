// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gym_staff_app/assistant/assistantFunction.dart';
import 'package:gym_staff_app/globalVariables.dart';
import 'package:gym_staff_app/l10n/l10n.dart';
import 'package:gym_staff_app/providers/localLanguageProvider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ChangeLanguageScreen extends StatefulWidget {
  static const routeName = '/ChangeLanguageScreen';

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  // String orderDate;
  // String convertedTime;

  bool switchLanguageLoading = false;
  bool switchLanguage = true;

  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit == true) {
      if (localeLanguage.languageCode == 'ar') {
        setState(() {
          switchLanguage = false;
        });
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              localeLanguage == const Locale('en')
                  ? Icons.arrow_back
                  : Icons.arrow_forward,
              color: Theme.of(context).scaffoldBackgroundColor,
              size: 30,
            ),
          ),
          title: Text(
            AppLocalizations.of(context).settingsIconTitle,
            style: TextStyle(
                color: Theme.of(context).textTheme.headline1.color,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 50,
                left: 15,
                right: 15,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () async {
                      if (switchLanguage == true) {
                        return;
                      }
                      try {
                        final provider = Provider.of<LocaleLanguageProvider>(
                            context,
                            listen: false);
                        Locale locale = L10n.all.firstWhere(
                            (element) => element.languageCode == 'en');

                        provider.setLocale(locale);

                        await setLocalLanguageInSorage('en');

                        setState(() {
                          switchLanguage = !switchLanguage;
                        });
                      } catch (error) {
                        showToast(
                            AppLocalizations.of(context).errorChangingLanguage,
                            context);
                      }
                    },
                    child: ListTile(
                      leading: Text(
                        'English',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      trailing: switchLanguage == false
                          ? null
                          : Icon(Icons.check_circle_outline,
                              size: 30,
                              color: switchLanguage == true
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).scaffoldBackgroundColor),
                    ),
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
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () async {
                      if (switchLanguage == false) {
                        return;
                      }
                      setState(() {
                        switchLanguageLoading = true;
                      });
                      try {
                        final provider = Provider.of<LocaleLanguageProvider>(
                            context,
                            listen: false);
                        Locale locale = L10n.all.firstWhere(
                            (element) => element.languageCode == 'ar');

                        provider.setLocale(locale);

                        await setLocalLanguageInSorage('ar');

                        setState(() {
                          switchLanguage = !switchLanguage;
                          switchLanguageLoading = false;
                        });
                      } catch (error) {
                        showToast(error.toString(), context);
                      }
                    },
                    child: ListTile(
                      leading: Text(
                        'العربية',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      trailing: switchLanguage == true
                          ? null
                          : Icon(Icons.check_circle_outline,
                              size: 30,
                              color: switchLanguage == false
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).scaffoldBackgroundColor),
                    ),
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
            switchLanguageLoading == true
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: Theme.of(context).primaryColor,
                        size: 50,
                      ),
                    ),
                    color: Colors.black38,
                  )
                : const SizedBox(
                    height: 0,
                  ),
          ],
        ));
  }
}
