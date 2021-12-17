import 'package:flutter/material.dart';

import '../models/contact_info.dart';
import '../models/size.dart';

class ContactContainer extends StatelessWidget {
  final ContactInfo contact;
  const ContactContainer({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = Size(context);
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: _size.height(12),
        horizontal: _size.width(24),
      ),
      height: _size.height(64),
      width: double.infinity,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color.fromRGBO(200, 200, 200, 1),
            child: Text(
              contact.name.substring(0, 2).toUpperCase(),
              style: Theme.of(context).textTheme.headline2,
            ),
            radius: _size.height(32),
          ),
          SizedBox(width: _size.width(20)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: _size.width(280),
                child: Text(
                  contact.name,
                  style: Theme.of(context).textTheme.bodyText1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
              Text(
                "Online",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: const Color.fromRGBO(52, 199, 89, 1),
                    ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
