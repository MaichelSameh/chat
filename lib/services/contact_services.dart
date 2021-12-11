import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

import '../models/contact_info.dart';
import 'contacts_db_services.dart';

class ContactServices {
  Future<bool> canGetContacts() async {
    return await Permission.contacts.isGranted;
  }

  Future<bool> getContactsPermission() async {
    PermissionStatus status = await Permission.contacts.request();
    return status.isGranted;
  }

  Future<List<ContactInfo>> getContacts() async {
    List<Contact> contacts = await ContactsService.getContacts(
        photoHighResolution: false, withThumbnails: false);
    List<ContactInfo> list = [];
    for (Contact contact in contacts) {
      String name = (contact.givenName ?? "") +
          ((contact.givenName ?? "").isEmpty ? "" : " ") +
          (contact.middleName ?? "") +
          ((contact.middleName ?? "").isEmpty ? "" : " ") +
          (contact.familyName ?? "");
      List<String> phones = [];
      for (Item phone in contact.phones ?? []) {
        if (phone.value != null &&
            !phones.contains((phone.value ?? "").replaceAll(" ", ""))) {
          phones.add(phone.value!.replaceAll(" ", ""));
        }
      }
      if (phones.isNotEmpty) {
        list.add(ContactInfo(name: name, phoneNumbers: phones));
        for (String phone in phones) {
          await ContactsDBServices()
              .insertIfAbsent(ContactInfo(name: name, phoneNumbers: [phone]));
        }
      }
    }
    return list;
  }
}