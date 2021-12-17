import 'package:flutter/material.dart';

import '../../models/contact_info.dart';
import '../../services/contacts_db_services.dart';
import '../../widgets/widgets.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<ContactInfo> contacts = [];
  @override
  void initState() {
    initContacts();
    super.initState();
  }

  Future<void> initContacts() async {
    contacts = await ContactsDBServices().getContacts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: contacts.map<Widget>(
        (contact) {
          return ContactContainer(contact: contact);
        },
      ).toList(),
    );
  }
}
