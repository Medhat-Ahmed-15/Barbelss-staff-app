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

  bool loading = false;
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
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15))),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 100, right: 15),
                  child: Text(
                    AppLocalizations.of(context).settingsIconTitle,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1.color,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
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
                      color: switchLanguage == true
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).scaffoldBackgroundColor,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () async {
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
                            showToast('Error changing language', context);
                          }
                        },
                        child: ListTile(
                          leading: Text(
                            'English',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: switchLanguage == true
                                    ? Colors.white
                                    : Colors.grey[600]),
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
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: InkWell(
                        onTap: () async {
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
                            });
                          } catch (error) {
                            showToast(error.toString(), context);
                          }
                        },
                        child: ListTile(
                          leading: Text(
                            'العربية',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: switchLanguage == false
                                    ? Colors.white
                                    : Theme.of(context).primaryColor),
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
                Expanded(child: Container()),
                loading == true
                    ? Center(
                        child: LoadingAnimationWidget.inkDrop(
                          color: Theme.of(context).primaryColor,
                          size: 50,
                        ),
                      )
                    : const Text(''),
                Expanded(child: Container()),
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
                  Icons.arrow_back,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ));
  }
}
