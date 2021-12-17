import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/palette.dart';
import '../../controllers/localization_controller.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';
import '../../controllers/auth_controller.dart';
import 'code_verification_screen.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({Key? key}) : super(key: key);

  // ignore: constant_identifier_names
  static const String route_name = "phone_verification_screen";

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  List<CountryInfo> countries = [];
  final TextEditingController phoneController = TextEditingController();
  String? countryCode;

  @override
  void initState() {
    initCountries();
    super.initState();
  }

  Future<void> initCountries() async {
    countries = await Get.find<AuthController>().getCountries();
    countryCode = countries.firstWhere((country) => country.code == "EG").code;
    setState(() {});
  }

  CustomDropdownButton<String> buildPhoneCodeDropDownButton(
    Size _size,
    BuildContext context,
  ) {
    return CustomDropdownButton<String>(
      hide: true,
      maxHeight: _size.height(400),
      borderRadius: _size.width(50),
      height: _size.height(60),
      width: _size.width(366),
      value: countryCode,
      items: countries
          .map<CustomDropdownButtonItem<String>>(
            (country) => CustomDropdownButtonItem(
              value: country.code,
              child: Row(
                children: [
                  SizedBox(width: _size.width(10)),
                  Text(
                    country.flag,
                    style: const TextStyle(
                      fontSize: 15,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(width: _size.width(10)),
                  SizedBox(
                    width: _size.width(150),
                    child: Text(
                      country.name,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                  SizedBox(
                    width: _size.width(130),
                    child: Text(
                      "(" + country.phoneCode + ")",
                      style: Theme.of(context).textTheme.bodyText1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onChange: (dynamic code) {
        setState(
          () {
            countryCode = code;
          },
        );
      },
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
                  .getTranslatedValue("enter_your_phone"),
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(
              Get.find<AppLocalizationController>()
                  .getTranslatedValue("get_phone_credentials"),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: _size.height(50)),
            buildPhoneCodeDropDownButton(_size, context),
            SizedBox(height: _size.height(50)),
            CustomTextField(
              border: BorderRadius.circular(_size.width(50)),
              hintKey: "enter_your_phone",
              prefixIconName: "phone_icon",
              controller: phoneController,
              keyboardType: const TextInputType.numberWithOptions(),
            ),
            const Spacer(),
            CustomElevatedButton(
              width: double.infinity,
              child: Text(
                Get.find<AppLocalizationController>()
                    .getTranslatedValue("continue"),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: MyPalette.primary_color,
                    ),
              ),
              onTap: () async {
                FocusScope.of(context).unfocus();
                if (phoneController.text.isNotEmpty) {
                  showDialog(
                      context: context, builder: (_) => const PreLoader());
                  await Get.find<AuthController>()
                      .phoneAuth(
                    countries
                        .firstWhere((country) => country.code == countryCode)
                        .phoneCode,
                    phoneController.text,
                  )
                      .catchError(
                    (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            error,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    },
                  );
                  Navigator.pop(context);
                  Get.find<AuthController>().addListener(() {
                    if (Get.find<AuthController>().smsReceived) {
                      Navigator.of(context).pushReplacementNamed(
                          CodeVerificationScreen.route_name);
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        Get.find<AppLocalizationController>()
                            .getTranslatedValue("phone_number_required"),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(
              height: _size.height(30),
            )
          ],
        ),
      ),
    );
  }
}
