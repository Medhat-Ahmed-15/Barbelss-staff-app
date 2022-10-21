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
    print('Entered here');
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
                        localeLanguage == const Locale('en')
                            ? Icons.arrow_back
                            : Icons.arrow_forward,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppLocalizations.of(context).settingsIconTitle,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 170,
                    left: 15,
                    right: 15,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: switchLanguage == true
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(206, 206, 206, 1),
                          offset: Offset(1, 3),
                          blurRadius: 1.0,
                        )
                      ],
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
                            final provider =
                                Provider.of<LocaleLanguageProvider>(context,
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
                                AppLocalizations.of(context)
                                    .errorChangingLanguage,
                                context);
                          }
                        },
                        child: ListTile(
                          leading: const Text(
                            'English',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.grey),
                          ),
                          trailing: switchLanguage == false
                              ? null
                              : Icon(Icons.check_circle_outline,
                                  size: 30,
                                  color: switchLanguage == true
                                      ? Colors.white
                                      : Colors.grey[600]),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: switchLanguage == false
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(206, 206, 206, 1),
                          offset: Offset(1, 3),
                          blurRadius: 1.0,
                        )
                      ],
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
                            final provider =
                                Provider.of<LocaleLanguageProvider>(context,
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
                          leading: const Text(
                            'العربية',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.grey),
                          ),
                          trailing: switchLanguage == true
                              ? null
                              : Icon(Icons.check_circle_outline,
                                  size: 30,
                                  color: switchLanguage == false
                                      ? Colors.white
                                      : Colors.grey[600]),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
