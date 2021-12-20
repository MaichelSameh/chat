import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/localization_controller.dart';
import '../controllers/user_controller.dart';
import '../models/message_info.dart';
import '../models/size.dart';

class MessageContainer extends StatelessWidget {
  final MessageInfo message;
  const MessageContainer({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = Size(context);
    final bool isRTL = Get.find<AppLocalizationController>().isRTLanguage;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: _size.height(6),
        horizontal: _size.width(12),
      ),
      child: Row(
        mainAxisAlignment:
            message.senderId == Get.find<UserController>().currentUser.id
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment:
                message.senderId == Get.find<UserController>().currentUser.id
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: _size.width(300)),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(238, 238, 238, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      !isRTL
                          ? message.senderId !=
                                  Get.find<UserController>().currentUser.id
                              ? 0
                              : _size.width(10)
                          : message.senderId ==
                                  Get.find<UserController>().currentUser.id
                              ? 0
                              : _size.width(10),
                    ),
                    topRight: Radius.circular(
                      isRTL
                          ? message.senderId !=
                                  Get.find<UserController>().currentUser.id
                              ? 0
                              : _size.width(10)
                          : message.senderId ==
                                  Get.find<UserController>().currentUser.id
                              ? 0
                              : _size.width(10),
                    ),
                    bottomLeft: Radius.circular(_size.width(10)),
                    bottomRight: Radius.circular(_size.width(10)),
                  ),
                ),
                padding: EdgeInsets.all(_size.width(12)),
                child: message.type == MediaType.none
                    ? Text(
                        message.message,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 15),
                      )
                    : message.type == MediaType.file
                        ? Container(
                            padding: EdgeInsets.all(_size.width(10)),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(225, 225, 225, 1),
                              borderRadius:
                                  BorderRadius.circular(_size.width(10)),
                            ),
                            child: Text(
                              message.fileName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: 15,
                                  ),
                            ),
                          )
                        : message.type == MediaType.photo
                            ? Image.network(message.mediaLink)
                            : const SizedBox(),
              ),
              SizedBox(height: _size.height(5)),
              Text(
                DateFormat("hh:mm").format(message.createdAt),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: const Color.fromRGBO(200, 200, 200, 1),
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
