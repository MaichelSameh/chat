import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/localization_controller.dart';
import '../controllers/user_controller.dart';
import '../models/size.dart';

class BottomNavBar extends StatelessWidget {
  final int currentPageNumber;
  final void Function(int) onChange;
  final Color color = const Color.fromRGBO(200, 200, 200, 1);
  const BottomNavBar({
    Key? key,
    required this.currentPageNumber,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = Size(context);
    return Container(
      width: double.infinity,
      height: _size.height(67),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: color,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: buildNavBarRow(context, _size),
    );
  }

  Widget buildNavBarRow(BuildContext context, Size _size) {
    List<Widget> navItems = [];
    for (int i = 0; i < 4; i++) {
      navItems.add(buildNavBarItem(context, _size, i));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: navItems,
    );
  }

  Widget buildNavBarItem(BuildContext context, Size _size, int index) {
    String iconName = "";
    String label = "";
    switch (index) {
      case 0:
        iconName = "message_icon";
        label = "messages";
        break;
      case 1:
        iconName = "persons_icon";
        label = "contacts";
        break;
      case 2:
        iconName = "phone_icon";
        label = "calls";
        break;
      case 3:
        iconName = "profile";
        label = "profile";
        break;
      default:
        iconName = "profile";
        label = "profile";
        break;
    }
    return GestureDetector(
      onTap: () {
        onChange(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconName != "profile"
              ? SvgPicture.asset(
                  "assets/icons/$iconName.svg",
                  width: _size.width(26),
                  height: _size.height(26),
                  color: index == currentPageNumber
                      ? const Color.fromRGBO(48, 48, 48, 1)
                      : color,
                )
              : CircleAvatar(
                  radius: _size.width(13),
                  backgroundColor: color,
                  backgroundImage: Get.find<UserController>()
                          .currentUser
                          .profileURL
                          .isNotEmpty
                      // ignore: unnecessary_cast
                      ? (NetworkImage(
                              Get.find<UserController>().currentUser.profileURL)
                          as ImageProvider)
                      : const AssetImage("assets/images/person.jpg"),
                ),
          SizedBox(height: _size.height(8)),
          Text(
            Get.find<AppLocalizationController>().getTranslatedValue(label),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: index == currentPageNumber
                      ? const Color.fromRGBO(48, 48, 48, 1)
                      : color,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }
}
