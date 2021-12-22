import 'package:chat_app/services/messages_db_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'config/palette.dart';
import 'controllers/controllers.dart';
import 'screens/screens.dart';
// import 'services/handle_notifications.dart';

Future<void> handleBackgroundNotification(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put<AuthController>(AuthController());
  Get.put<UserController>(UserController());
  Get.put<AppLocalizationController>(AppLocalizationController.empty());
  FirebaseMessaging.onBackgroundMessage(handleBackgroundNotification);
  // HandleNotification.initialize();
  bool loggedIn = await Get.find<AuthController>().tryAutoLogin();
  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp({Key? key, required this.loggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MessagesDBHelper().resetDB();
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
          initialRoute:
              loggedIn ? HomeScreen.route_name : OnboardingScreen.route_name,
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
