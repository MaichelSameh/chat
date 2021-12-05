import 'package:chat_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/localization_controller.dart';
import '../models/size.dart';
import '../widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  // ignore: constant_identifier_names
  static const String route_name = "onboarding_screen";
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = Size(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: _size.width(24)),
        child: Column(
          children: [
            SizedBox(height: _size.height(119)),
            Text(
              Get.find<AppLocalizationController>()
                  .getTranslatedValue("welcome"),
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: _size.height(127)),
            SvgPicture.asset("assets/icons/welcome_icon.svg"),
            SizedBox(height: _size.height(40)),
            Text(
              Get.find<AppLocalizationController>()
                  .getTranslatedValue("welcome_text"),
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: _size.height(152)),
            CustomElevatedButton(
              width: _size.width(366),
              child: Text(
                Get.find<AppLocalizationController>()
                    .getTranslatedValue("continue_with_phone"),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: MyPalette.primary_color,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
