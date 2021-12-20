import 'package:intl/intl.dart';

enum ReceiverType { individual, group, unknown }
enum MediaType { file, voice, photo, none }

class MessageInfo {
  MessageInfo({
    required DateTime createdAt,
    required String id,
    required String mediaLink,
    required String message,
    required String receiverId,
    required String senderId,
    required String fileName,
    required ReceiverType receiverType,
    required MediaType type,
  }) {
    _createdAt = createdAt;
    _id = id;
    _mediaLink = mediaLink;
    _message = message;
    _receiverId = receiverId;
    _senderId = senderId;
    _receiverType = receiverType;
    _fileName = fileName;
    _type = type;
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
    _fileName = data["file_name"];
    switch (data["media_type"]) {
      case "1":
        _type = MediaType.none;
        break;
      case "2":
        _type = MediaType.file;
        break;
      case "3":
        _type = MediaType.photo;
        break;
      case "4":
        _type = MediaType.voice;
        break;
    }
  }

  MessageInfo.fromLocalDB(Map<String, dynamic> data) {
    _createdAt = DateTime.parse(data["created_at"]);
    _id = data["id"];
    _mediaLink = data["media_link"];
    _message = data["message"];
    _receiverId = data["receiver_id"];
    _senderId = data["sender_id"];
    _fileName = data["file_name"];
    _receiverType = data["receiver_type_id"] == "2"
        ? ReceiverType.group
        : data["receiver_type_id"] == "1"
            ? ReceiverType.individual
            : ReceiverType.unknown;
    switch (data["media_type"]) {
      case "1":
        _type = MediaType.none;
        break;
      case "2":
        _type = MediaType.file;
        break;
      case "3":
        _type = MediaType.photo;
        break;
      case "4":
        _type = MediaType.voice;
        break;
    }
  }

  late DateTime _createdAt;
  late String _fileName;
  late String _id;
  late String _mediaLink;
  late String _message;
  late String _receiverId;
  late ReceiverType _receiverType;
  late String _senderId;
  late MediaType _type;

  @override
  String toString() {
    return 'MessageInfo(createdAt: $createdAt, id: $id, mediaLink: $mediaLink, message: $message, receiverId: $receiverId, senderId: $senderId, fileName: $fileName)';
  }

  DateTime get createdAt => _createdAt;

  String get id => _id;

  String get mediaLink => _mediaLink;

  String get message => _message;

  String get receiverId => _receiverId;

  String get senderId => _senderId;

  String get fileName => _fileName;

  ReceiverType get receiverType => _receiverType;

  MediaType get type => _type;

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
    String type = "";

    switch (this.type) {
      case MediaType.file:
        type = "2";
        break;
      case MediaType.voice:
        type = "4";
        break;
      case MediaType.photo:
        type = "3";
        break;
      case MediaType.none:
        type = "1";
        break;
    }
    return {
      "created_at": DateFormat("yyyy-MM-dd hh:mm:ss").format(createdAt),
      "media_link": mediaLink,
      "message": message,
      "receiver_id": receiverId,
      "sender_id": senderId,
      "receiver_type_id": receiverType,
      "file_name": fileName,
      "media_type": type,
    };
  }

  Map<String, dynamic> toLocalDB() {
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
    String type = "";

    switch (this.type) {
      case MediaType.file:
        type = "2";
        break;
      case MediaType.voice:
        type = "4";
        break;
      case MediaType.photo:
        type = "3";
        break;
      case MediaType.none:
        type = "1";
        break;
    }
    return {
      "id": id,
      "created_at": DateFormat("yyyy-MM-dd hh:mm:ss").format(createdAt),
      "media_link": mediaLink,
      "message": message,
      "receiver_id": receiverId,
      "sender_id": senderId,
      "receiver_type_id": receiverType,
      "file_name": fileName,
      "media_type": type,
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
    String type = "";

    switch (this.type) {
      case MediaType.file:
        type = "2";
        break;
      case MediaType.voice:
        type = "4";
        break;
      case MediaType.photo:
        type = "3";
        break;
      case MediaType.none:
        type = "1";
        break;
    }
    return {
      "created_at": DateFormat("yyyy-MM-dd hh:mm:ss").format(createdAt),
      "media_link": mediaLink,
      "message": message,
      "receiver_id": receiverId,
      "sender_id": senderId,
      "receiver_type_id": receiverType,
      "file_name": fileName,
      "media_type": type,
    };
  }

  MessageInfo copyWith({
    DateTime? createdAt,
    String? id,
    String? mediaLink,
    String? message,
    String? receiverId,
    String? senderId,
    String? fileName,
    ReceiverType? receiverType,
    MediaType? type,
  }) {
    return MessageInfo(
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      mediaLink: mediaLink ?? this.mediaLink,
      message: message ?? this.message,
      receiverId: receiverId ?? this.receiverId,
      senderId: senderId ?? this.senderId,
      receiverType: receiverType ?? this.receiverType,
      fileName: fileName ?? this.fileName,
      type: type ?? this.type,
    );
  }
}
