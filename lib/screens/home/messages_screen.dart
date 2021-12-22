import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/contacts_db_services.dart';
import '../../models/contact_info.dart';
import '../../widgets/contact_container.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<ContactInfo> contacts = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      initContacts();
    });
  }

  Future<void> initContacts() async {
    List<ContactInfo> temp = await ContactsDBServices().getTextedContacts();
    for (int i = 0; i < temp.length; i++) {
      if (contacts.isEmpty) {
        setState(() {
          contacts = temp;
        });
      }
      if (contacts[i].lastMessage!.createdAt ==
              temp[i].lastMessage!.createdAt ||
          contacts[i].firebaseId != temp[i].firebaseId) {
        setState(() {
          contacts = temp;
        });
        return;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: contacts.map<Widget>(
        (contact) {
          return ContactContainer(contact: contact);
        },
      ).toList(),
    );
  }
}
