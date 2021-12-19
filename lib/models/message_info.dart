import 'package:intl/intl.dart';

enum ReceiverType { individual, group, unknown }

class MessageInfo {
  MessageInfo(
      {required DateTime createdAt,
      required String id,
      required String mediaLink,
      required String message,
      required String receiverId,
      required String senderId,
      required ReceiverType receiverType}) {
    _createdAt = createdAt;
    _id = id;
    _mediaLink = mediaLink;
    _message = message;
    _receiverId = receiverId;
    _senderId = senderId;
    _receiverType = receiverType;
  }

  MessageInfo.fromFirebase(Map<String, dynamic> data, String id) {
    _createdAt = DateTime.parse(data["created_at"]);
    _id = id;
    _mediaLink = data["media_link"];
    _message = data["message"];
    _receiverId = data["receiver_id"];
    _senderId = data["sender_id"];
    _receiverType = data["receiver_type_id"] == "2"
        ? ReceiverType.group
        : data["receiver_type_id"] == "1"
            ? ReceiverType.individual
            : ReceiverType.unknown;
  }

  late DateTime _createdAt;
  late String _id;
  late String _mediaLink;
  late String _message;
  late String _receiverId;
  late String _senderId;
  late ReceiverType _receiverType;

  @override
  String toString() {
    return 'MessageInfo(createdAt: $createdAt, id: $id, mediaLink: $mediaLink, message: $message, receiverId: $receiverId, senderId: $senderId)';
  }

  DateTime get createdAt => _createdAt;

  String get id => _id;

  String get mediaLink => _mediaLink;

  String get message => _message;

  String get receiverId => _receiverId;

  String get senderId => _senderId;

  ReceiverType get receiverType => _receiverType;

  Map<String, dynamic> toMap() {
    String receiverType = "";
    switch (this.receiverType) {
      case ReceiverType.individual:
        receiverType = "1";
        break;
      case ReceiverType.group:
        receiverType = "2";
        break;
      case ReceiverType.unknown:
        break;
    }
    return {
      "created_at": DateFormat("yyyy-MM-dd hh:mm:ss").format(createdAt),
      "media_link": mediaLink,
      "message": message,
      "receiver_id": receiverId,
      "sender_id": senderId,
      "receiver_type_id": receiverType,
    };
  }

  Map<String, String> toMessage() {
    String receiverType = "";
    switch (this.receiverType) {
      case ReceiverType.individual:
        receiverType = "1";
        break;
      case ReceiverType.group:
        receiverType = "2";
        break;
      case ReceiverType.unknown:
        break;
    }
    return {
      "created_at": DateFormat("yyyy-MM-dd hh:mm:ss").format(createdAt),
      "media_link": mediaLink,
      "message": message,
      "receiver_id": receiverId,
      "sender_id": senderId,
      "receiver_type_id": receiverType,
    };
  }
}
