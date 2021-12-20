import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/contact_info.dart';
import '../models/message_info.dart';
import '../models/size.dart';
import '../services/messages_db_helper.dart';
import '../widgets/widgets.dart';

class PrivateChatScreen extends StatefulWidget {
  const PrivateChatScreen({Key? key}) : super(key: key);

  // ignore: constant_identifier_names
  static const String route_name = "private_chat_screen";

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  ContactInfo contact =
      ContactInfo(name: "name", phoneNumbers: ["phoneNumbers"]);

  bool firstBuild = true;

  List<MessageInfo> messages = [];

  Expanded buildMessagesList(Size _size) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: _size.width(12),
          vertical: _size.height(6),
        ),
        children: messages
            .map<Widget>((message) => MessageContainer(message: message))
            .toList(),
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
            foregroundImage: NetworkImage(contact.profilePicture!),
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

  Future<void> fetchMessages([ContactInfo? contact]) async {
    bool changed = false;
    List<MessageInfo> list = await MessagesDBHelper().getMessages(
        (contact ?? this.contact).firebaseId!, ReceiverType.individual);
    for (MessageInfo message in list) {
      if (!messages.any((element) => element.id == message.id)) {
        messages.add(message);
        changed = true;
      }
      if (changed) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size _size = Size(context);
    if (firstBuild) {
      final ContactInfo contact =
          ModalRoute.of(context)!.settings.arguments as ContactInfo;
      fetchMessages(contact);
      this.contact = contact;
    }

    return Scaffold(
        body: SizedBox(
      height: _size.screenHeight() - MediaQuery.of(context).padding.bottom,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          buildAppBar(_size, contact, context),
          buildMessagesList(_size),
          SendBox(contact: contact, fetchMessages: fetchMessages),
        ],
      ),
    ));
  }
}
