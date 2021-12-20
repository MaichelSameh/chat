import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/user_controller.dart';
import '../models/size.dart';
import '../models/contact_info.dart';
import '../models/message_info.dart';
import '../services/message_services.dart';
import 'custom_text_field.dart';

class SendBox extends StatefulWidget {
  final ContactInfo contact;
  final Future<void> Function() fetchMessages;
  const SendBox({Key? key, required this.contact, required this.fetchMessages})
      : super(key: key);

  @override
  State<SendBox> createState() => _SendBoxState();
}

class _SendBoxState extends State<SendBox> {
  double width = 1;

  final TextEditingController messageController = TextEditingController();

  double textHeight(double maxTextWidth, Size _size) {
    return ((width / maxTextWidth) - (width / maxTextWidth % 1)) * 25 + 30 >
            _size.height(150)
        ? _size.height(150)
        : ((width / maxTextWidth) - (width / maxTextWidth % 1)) * 25 + 30;
  }

  double textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }

  @override
  Widget build(BuildContext context) {
    Size _size = Size(context);
    final double maxTextWidth = (_size.screenWidth() - _size.width(130));
    return Container(
      width: _size.constrainMaxWidth,
      padding: EdgeInsets.symmetric(
        vertical: _size.height(12),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _size.width(12),
        vertical: _size.height(12),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(220, 220, 220, 1)),
        borderRadius: BorderRadius.circular(_size.height(20)),
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      child: CustomTextField(
        hintKey: "type_message",
        height: textHeight(maxTextWidth, _size),
        expands: true,
        controller: messageController,
        keyboardType: TextInputType.multiline,
        textAlign: TextAlign.start,
        color: Colors.transparent,
        onChange: (_) {
          width = textSize(
            messageController.text,
            Theme.of(context).textTheme.bodyText1!,
          );
          if (width == 0) {
            width = 1;
          }
          List<String> lines = messageController.text.split("\n");
          if (lines.length > 1) {
            lines.removeWhere((element) => element.isNotEmpty);
            int count = lines.length;
            width += count * maxTextWidth;
          }
          setState(() {});
        },
        suffixIcon: messageController.text.trim().isEmpty
            ? Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      FilePickerResult? files =
                          await FilePicker.platform.pickFiles();
                      if (files != null) {
                        for (PlatformFile file in files.files) {
                          if (file.path != null) {
                            await MessageServices().sendFileMessage(
                              MessageInfo(
                                type: MediaType.file,
                                createdAt: DateTime.now(),
                                id: "",
                                mediaLink: "",
                                message: messageController.text,
                                receiverId: widget.contact.firebaseId!,
                                senderId:
                                    Get.find<UserController>().currentUser.id,
                                receiverType: ReceiverType.individual,
                                fileName: file.name,
                              ),
                              File(file.path!),
                            );
                            widget.fetchMessages();
                          }
                        }
                      }
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: _size.width(10)),
                      child: SvgPicture.asset("assets/icons/file_icon.svg"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      XFile? file = await ImagePicker()
                          .pickImage(source: ImageSource.camera);
                      if (file != null) {
                        await MessageServices().sendImageMessage(
                          MessageInfo(
                            type: MediaType.photo,
                            createdAt: DateTime.now(),
                            id: "",
                            mediaLink: "",
                            message: messageController.text,
                            receiverId: widget.contact.firebaseId!,
                            senderId: Get.find<UserController>().currentUser.id,
                            receiverType: ReceiverType.individual,
                            fileName: file.name,
                          ),
                          File(file.path),
                        );

                        widget.fetchMessages();
                      }
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: _size.width(10)),
                      child: SvgPicture.asset("assets/icons/camera_icon.svg"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      widget.fetchMessages();
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: _size.width(10)),
                      child:
                          SvgPicture.asset("assets/icons/microphone_icon.svg"),
                    ),
                  ),
                ],
              )
            : GestureDetector(
                onTap: () async {
                  if (messageController.text.trim().isNotEmpty) {
                    MessageInfo message = MessageInfo(
                      type: MediaType.none,
                      createdAt: DateTime.now(),
                      id: "",
                      mediaLink: "",
                      message: messageController.text.trim(),
                      receiverId: widget.contact.firebaseId!,
                      senderId: Get.find<UserController>().currentUser.id,
                      receiverType: ReceiverType.individual,
                      fileName: "",
                    );
                    await MessageServices().sendTextMessage(message);
                    await widget.fetchMessages();
                  }
                  messageController.clear();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: _size.width(10), vertical: 1),
                  child: SvgPicture.asset("assets/icons/send_icon.svg"),
                ),
              ),
        prefixIconName: "emoji_icon",
      ),
    );
  }
}
