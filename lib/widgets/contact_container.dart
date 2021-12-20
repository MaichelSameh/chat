import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/contact_info.dart';
import '../models/size.dart';
import '../screens/private_chat_screen.dart';

class ContactContainer extends StatelessWidget {
  final ContactInfo contact;
  const ContactContainer({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = Size(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          PrivateChatScreen.route_name,
          arguments: contact,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: _size.height(12),
          horizontal: _size.width(24),
        ),
        height: _size.height(64),
        width: double.infinity,
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color.fromRGBO(200, 200, 200, 1),
              foregroundImage: NetworkImage(contact.profilePicture ?? ""),
              child: Text(
                contact.name.substring(0, 2).toUpperCase(),
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              radius: _size.height(32),
            ),
            SizedBox(width: _size.width(20)),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: _size.width(20),
                  child: Text(
                    contact.name,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  width: _size.width(240),
                  child: Text(
                    contact.lastMessage ?? contact.bio!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: const Color.fromRGBO(159, 159, 159, 1),
                          fontSize: 13,
                        ),
                  ),
                ),
              ],
            ),
            if (contact.messageDate != null)
              Text(
                DateFormat(contact.messageDate!.isBefore(
                            DateTime.now().subtract(const Duration(days: 1)))
                        ? "yyyy/MM/dd hh:mm"
                        : "hh:mm")
                    .format(contact.messageDate!),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: const Color.fromRGBO(159, 159, 159, 1),
                      fontSize: 13,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
