import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FcmInfo {
  FcmInfo({
    required DateTime createdAt,
    required String deviceId,
    required String fcm,
    required String userId,
  }) {
    _createdAt = createdAt;
    _deviceId = deviceId;
    _fcm = fcm;
    _userId = userId;
  }

  FcmInfo.fromFirebase(Map<String, dynamic> data, String id) {
    _createdAt = data["created_at"];
    _deviceId = data["device_id"];
    _fcm = data["fcm"];
    _userId = data["user_id"];
  }

  late DateTime _createdAt;
  late String _deviceId;
  late String _fcm;
  late String _userId;

  @override
  String toString() {
    return '''
      FcmInfo(
        createdAt: $createdAt,
        deviceId: $deviceId,
        fcm: $fcm,
        userId: $userId,
      );
    ''';
  }

  Map<String, dynamic> toMap() {
    return {
      "created_at": DateFormat("yyyy-MM-dd hh:mm:ss").format(createdAt),
      "device_id": deviceId,
      "fcm": fcm,
      "user_id": userId,
    };
  }

  //the date of creation
  DateTime get createdAt => _createdAt;

  //the id pf the device, used also to identify the document
  String get deviceId => _deviceId;

  //the fcm token of the device
  String get fcm => _fcm;

  //the owner's id of this device
  String get userId => _userId;

  Future<void> upload() async {
    await FirebaseFirestore.instance
        .collection("fcm")
        .doc(deviceId)
        .set(toMap());
  }
}
