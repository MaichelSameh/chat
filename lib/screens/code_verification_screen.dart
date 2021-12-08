import 'package:chat_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/localization_controller.dart';
import '../models/size.dart';
import '../controllers/auth_controller.dart';

class CodeVerificationScreen extends StatefulWidget {
  const CodeVerificationScreen({Key? key}) : super(key: key);

  // ignore: constant_identifier_names
  static const String route_name = "code_verification_screen";

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  final TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  Widget buildVerificationCodeRow(Size _size) {
    List<Widget> fields = [];
    for (int i = 0; i < 6; i++) {
      String code = "";
      try {
        code = codeController.text[i];
        // ignore: empty_catches
      } catch (error) {}
      fields.add(buildVerificationCodeRowItem(_size, code));
    }
    codeController.addListener(() {
      setState(() {});
    });

    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: fields,
        ),
        Opacity(
          opacity: 0,
          child: SizedBox(
            height: _size.width(50),
            child: TextField(
              controller: codeController,
              maxLength: 6,
              autofocus: true,
              maxLines: null,
              minLines: null,
              expands: true,
              onChanged: (value) {
                if (value.length >= 6) {
                  FocusScope.of(context).unfocus();
                  Get.find<AuthController>().verifyPhone(codeController.text);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildVerificationCodeRowItem(Size _size, String text) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: MyPalette.secondary_color),
        shape: BoxShape.circle,
      ),
      width: _size.width(50),
      height: _size.width(50),
      alignment: Alignment.center,
      child: Text(text, style: Theme.of(context).textTheme.headline2),
    );
  }

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
                  .getTranslatedValue("enter_code"),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: _size.height(15)),
            Text(
              Get.find<AppLocalizationController>()
                      .getTranslatedValue("enter_code_text") +
                  " " +
                  Get.find<AuthController>().phoneNumber +
                  ".",
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: _size.height(35)),
            buildVerificationCodeRow(_size),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Get.find<AppLocalizationController>()
                      .getTranslatedValue("did_not_get_code"),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: const Color.fromRGBO(158, 159, 159, 1),
                      ),
                ),
                Text(
                  " ",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: const Color.fromRGBO(158, 159, 159, 1),
                      ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.find<AuthController>().resendCode();
                  },
                  child: Text(
                    Get.find<AppLocalizationController>()
                        .getTranslatedValue("resend_code"),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            SizedBox(height: _size.height(21)),
          ],
        ),
      ),
    );
  }
}
