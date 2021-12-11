import 'package:flutter/material.dart';

import '../services/contact_services.dart';

class HomeScreen extends StatelessWidget {
  // ignore: constant_identifier_names
  static const String route_name = "home_screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () async {
            if (!await ContactServices().canGetContacts()) {
              await ContactServices().getContactsPermission();
            }
            ContactServices().getContacts();
          },
          child: const Text("Get contacts"),
        ),
      ),
    );
  }
}
