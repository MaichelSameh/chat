import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/controllers.dart';
import '../../models/size.dart';
import '../../widgets/widgets.dart';
import '../home/home_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({Key? key}) : super(key: key);

  // ignore: constant_identifier_names
  static const String route_name = "create_profile_screen";

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final TextEditingController bioController =
      TextEditingController(text: Get.find<UserController>().currentUser.bio);

  final TextEditingController nameController = TextEditingController(
      text: Get.find<UserController>().currentUser.name.isEmpty
          ? null
          : Get.find<UserController>().currentUser.name);
  @override
  Widget build(BuildContext context) {
    Size _size = Size(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _size.width(30)),
          height: _size.screenHeight(),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Column(
            children: [
              SizedBox(height: _size.height(90)),
              Text(
                Get.find<AppLocalizationController>()
                    .getTranslatedValue("create_profile_header"),
                style: Theme.of(context).textTheme.headline2,
              ),
              SizedBox(height: _size.height(20)),
              GestureDetector(
                onTap: () async {
                  XFile? file = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    showDialog(
                        context: context,
                        builder: (_) => const PreLoader(),
                        barrierDismissible: false);
                    await Get.find<UserController>()
                        .updateUserPhoto(File(file.path));
                    Navigator.pop(context);
                    setState(() {});
                  }
                },
                child: SizedBox(
                  width: _size.width(140),
                  height: _size.width(140),
                  child: DottedBorder(
                    borderType: BorderType.Circle,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(500),
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.network(
                              Get.find<UserController>().currentUser.profileURL,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) {
                                return Image.asset(
                                  "assets/images/person.jpg",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        Center(
                          child:
                              SvgPicture.asset("assets/icons/camera_icon.svg"),
                        ),
                      ],
                    ),
                    dashPattern: const [15, 5],
                  ),
                ),
              ),
              SizedBox(height: _size.height(20)),
              CustomTextField(
                textAlign: TextAlign.center,
                hintKey: "",
                controller: nameController,
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: _size.height(20)),
              TextField(
                controller: bioController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                keyboardType: TextInputType.text,
              ),
              const Spacer(),
              CustomElevatedButton(
                onTap: () async {
                  await Get.find<UserController>()
                      .updateMyInfo(nameController.text, bioController.text);
                  Navigator.of(context)
                      .pushReplacementNamed(HomeScreen.route_name);
                },
                width: double.infinity,
                child: Text(
                  Get.find<AppLocalizationController>()
                      .getTranslatedValue("create_profile"),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.white),
                ),
              ),
              SizedBox(height: _size.height(30)),
            ],
          ),
        ),
      ),
    );
  }
}
