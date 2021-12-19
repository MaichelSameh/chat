import 'services/handle_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config/palette.dart';
import 'controllers/controllers.dart';
import 'screens/screens.dart';
import 'services/contact_services.dart';

Future<void> handleBackgroundNotification(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put<AppLocalizationController>(AppLocalizationController.empty());
  Get.put<AuthController>(AuthController());
  Get.put<UserController>(UserController());

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundNotification);
  HandleNotification.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ContactServices().canGetContacts().then((value) {
      if (value) {
        ContactServices().getContacts();
      } else {
        ContactServices().getContactsPermission().then((value) {
          if (value) {
            ContactServices().getContacts();
          }
        });
      }
    });
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
          initialRoute: FirebaseAuth.instance.currentUser == null
              ? OnboardingScreen.route_name
              : HomeScreen.route_name,
          routes: {
            OnboardingScreen.route_name: (_) =>
                const OnboardingScreen(key: Key(OnboardingScreen.route_name)),
            PhoneVerificationScreen.route_name: (_) =>
                const PhoneVerificationScreen(
                    key: Key(PhoneVerificationScreen.route_name)),
            CodeVerificationScreen.route_name: (_) =>
                const CodeVerificationScreen(
                    key: Key(CodeVerificationScreen.route_name)),
            HomeScreen.route_name: (_) =>
                const HomeScreen(key: Key(HomeScreen.route_name)),
            CreateProfileScreen.route_name: (_) => const CreateProfileScreen(
                key: Key(CreateProfileScreen.route_name)),
            PrivateChatScreen.route_name: (_) =>
                const PrivateChatScreen(key: Key(PrivateChatScreen.route_name)),
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
