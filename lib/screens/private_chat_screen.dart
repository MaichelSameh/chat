import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import '../models/contact_info.dart';
import '../models/message_info.dart';
import '../models/size.dart';
import '../services/message_services.dart';
import '../widgets/widgets.dart';

class PrivateChatScreen extends StatefulWidget {
  const PrivateChatScreen({Key? key}) : super(key: key);

  // ignore: constant_identifier_names
  static const String route_name = "private_chat_screen";

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final TextEditingController messageController = TextEditingController();
  double width = 1;

  double textHeight(double maxTextWidth, Size _size) {
    return ((width / maxTextWidth) - (width / maxTextWidth % 1)) * 25 + 30 >
            _size.height(150)
        ? _size.height(150)
        : ((width / maxTextWidth) - (width / maxTextWidth % 1)) * 25 + 30;
  }

  Container buildSendBox(
    Size _size,
    BuildContext context,
    ContactInfo contact,
  ) {
    final double maxTextWidth = (_size.screenWidth() - _size.width(130));
    return Container(
      width: _size.constrainMaxWidth,
      padding: EdgeInsets.symmetric(
        vertical: _size.height(12),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _size.width(12),
        vertical: _size.height(12),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(220, 220, 220, 1)),
        borderRadius: BorderRadius.circular(_size.height(20)),
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      child: CustomTextField(
        hintKey: "type_message",
        height: textHeight(maxTextWidth, _size),
        expands: true,
        controller: messageController,
        keyboardType: TextInputType.multiline,
        textAlign: TextAlign.start,
        color: Colors.transparent,
        onChange: (_) {
          width = textSize(
            messageController.text,
            Theme.of(context).textTheme.bodyText1!,
          );
          if (width == 0) {
            width = 1;
          }
          List<String> lines = messageController.text.split("\n");
          if (lines.length > 1) {
            lines.removeWhere((element) => element.isNotEmpty);
            int count = lines.length;
            width += count * maxTextWidth;
          }
          setState(() {});
        },
        suffixIcon: messageController.text.isEmpty
            ? Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: _size.width(10)),
                    child: SvgPicture.asset("assets/icons/file_icon.svg"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: _size.width(10)),
                    child: SvgPicture.asset("assets/icons/camera_icon.svg"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: _size.width(10)),
                    child: SvgPicture.asset("assets/icons/microphone_icon.svg"),
                  ),
                ],
              )
            : GestureDetector(
                onTap: () {
                  if (messageController.text.trim().isNotEmpty) {
                    MessageInfo message = MessageInfo(
                      createdAt: DateTime.now(),
                      id: "",
                      mediaLink: "",
                      message: messageController.text.trim(),
                      receiverId: contact.firebaseId!,
                      senderId: Get.find<UserController>().currentUser.id,
                      receiverType: ReceiverType.individual,
                    );
                    MessageServices().sendMessage(message);
                  }
                  messageController.clear();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _size.width(10), vertical: 1),
                  child: SvgPicture.asset("assets/icons/send_icon.svg"),
                ),
              ),
        prefixIconName: "emoji_icon",
      ),
    );
  }

  Expanded buildMessagesList(Size _size) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: _size.width(12)),
      ),
    );
  }

  Container buildAppBar(Size _size, ContactInfo contact, BuildContext context) {
    return Container(
      height: _size.height(84),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: _size.height(13),
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(220, 220, 220, 1),
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _size.width(12)),
              child: SvgPicture.asset("assets/icons/back_icon.svg"),
            ),
          ),
          SizedBox(width: _size.width(20)),
          CircleAvatar(
            radius: _size.height(24),
            backgroundColor: const Color.fromRGBO(200, 200, 200, 1),
            child: Text(
              contact.name.substring(0, 2).toUpperCase(),
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: _size.width(14)),
          Column(
            children: [
              SizedBox(
                width: _size.width(208),
                child: Text(
                  contact.name,
                  style: Theme.of(context).textTheme.bodyText1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 1,
                ),
              ),
              SizedBox(
                width: _size.width(208),
                child: Text(
                  "online",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: const Color.fromRGBO(52, 199, 89, 1),
                        fontSize: 14,
                      ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
            ],
          ),
          SizedBox(width: _size.width(24)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _size.width(12)),
            child: SvgPicture.asset("assets/icons/more_icon.svg"),
          ),
        ],
      ),
    );
  }

  double textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }

  @override
  Widget build(BuildContext context) {
    Size _size = Size(context);
    final ContactInfo contact =
        ModalRoute.of(context)!.settings.arguments as ContactInfo;
    return Scaffold(
        body: SizedBox(
      height: _size.screenHeight() - MediaQuery.of(context).padding.bottom,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          buildAppBar(_size, contact, context),
          buildMessagesList(_size),
          buildSendBox(_size, context, contact),
        ],
      ),
    ));
  }
}
