import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config/palette.dart';
import 'controllers/controllers.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put<AppLocalizationController>(AppLocalizationController.empty());
  Get.put<LoginController>(LoginController());
  Get.put<UserController>(UserController());

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppLocalizationController>(
      builder: (localization) {
        return MaterialApp(
          locale: localization.currentLocale,
          localizationsDelegates: [
            AppLocalizationController.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: localization.locales,
          initialRoute: OnboardingScreen.route_name,
          routes: {
            OnboardingScreen.route_name: (_) =>
                const OnboardingScreen(key: Key(OnboardingScreen.route_name)),
          },
          theme: ThemeData(
            fontFamily: "sf-ui-display",
            textTheme: const TextTheme(
              headline1: TextStyle(
                color: MyPalette.secondary_color,
                fontSize: 32,
                fontWeight: FontWeight.w500,
              ),
              headline2: TextStyle(
                color: MyPalette.secondary_color,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              bodyText1: TextStyle(
                color: MyPalette.secondary_color,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}