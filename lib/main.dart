import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gym_staff_app/providers/auth_provider.dart';
import 'package:gym_staff_app/providers/localLanguageProvider.dart';
import 'package:gym_staff_app/screens/addNewMemberScreen.dart';
import 'package:gym_staff_app/screens/addNewMemberScreenP2.dart';
import 'package:gym_staff_app/screens/changeLanguageScreen.dart';
import 'package:gym_staff_app/screens/mainScreen.dart';
import 'package:gym_staff_app/screens/loginScreen.dart';
import 'package:gym_staff_app/screens/memberDetailsScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gym_staff_app/screens/memberPackageDetailsScreen.dart';
import 'package:gym_staff_app/screens/memberPersonalDataScreen.dart';
import 'package:gym_staff_app/screens/plansScreen.dart';
import 'package:gym_staff_app/screens/searchScreen.dart';
import 'package:gym_staff_app/screens/settingsScreen.dart';
import 'package:gym_staff_app/screens/splash_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Providing Auth Data
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),

        ChangeNotifierProvider(
          create: (ctx) => LocaleLanguageProvider(),
        ),
      ],
      child: Consumer2<AuthProvider, LocaleLanguageProvider>(
          builder: (ctx, authProviderObj, localLanguageProviderObj, _) =>
              OverlaySupport.global(
                child: MaterialApp(
                  supportedLocales: L10n.all,
                  localizationsDelegates: const [
                    AppLocalizations.delegate, // Add this line
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    // This is the theme of your application.
                    primaryColor: const Color.fromRGBO(0, 41, 88, 1),
                    scaffoldBackgroundColor: Colors.white,
                    textTheme: TextTheme(
                      headline1: const TextStyle(color: Colors.white),
                      headline2: TextStyle(color: Colors.grey.shade900),
                    ),
                    fontFamily: 'Poppins',
                    iconTheme: const IconThemeData(
                      color: Colors.white,
                    ),
                  ),
                  home: authProviderObj.checkauthentication() == true
                      ? MainScreen()
                      : FutureBuilder(
                          future: authProviderObj.tryAutoSignIn(),
                          builder: (ctx, snapShot) {
                            if (snapShot.connectionState ==
                                ConnectionState.none) {
                              print('SPLAAAASSHHH SCREEEBBBB');
                              return SplashScreen();
                            }
                            if (snapShot.data == true) {
                              return MainScreen();
                            } else {
                              return LoginScreen();
                            }
                          }),
                  locale: localLanguageProviderObj.locale,
                  routes: {
                    LoginScreen.routeName: (ctx) => LoginScreen(),
                    AddNewMemberScreenP2.routeName: (ctx) =>
                        AddNewMemberScreenP2(),
                    MemberPersonalDataScreen.routeName: (ctx) =>
                        MemberPersonalDataScreen(),
                    MemberPackageDetailsScreen.routeName: (ctx) =>
                        MemberPackageDetailsScreen(),
                    SearchScreen.routeName: (ctx) => SearchScreen(),
                    MainScreen.routeName: (ctx) => MainScreen(),
                    AddNewMemberScreen.routeName: (ctx) => AddNewMemberScreen(),
                    MemberDetailsScreen.routeName: (ctx) =>
                        MemberDetailsScreen(),
                    PlansScreen.routeName: (ctx) => PlansScreen(),
                    SettingsScreen.routeName: (ctx) => SettingsScreen(),
                    ChangeLanguageScreen.routeName: (ctx) =>
                        ChangeLanguageScreen(),
                  },
                ),
              )),
    );
  }
}
