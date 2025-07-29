import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loved_app/controllers/auth_controller.dart';
import 'package:loved_app/data/permissions.dart';
import 'package:loved_app/utils/firebase_functions.dart';
import 'package:loved_app/utils/images.dart';
import 'package:loved_app/utils/size_config.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/general_controller.dart';
import '../utils/colors.dart';
import '../utils/const.dart';
import '../utils/text_styles.dart';
import '../widgets/progress_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: const Text("Profile"),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const [0.1, 1.0],
                colors: [primaryColor.withOpacity(0.6), blue],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
          )),
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: getUserDataByEmail(email: Get.find<GeneralController>().lovedBox.get(cUserEmail)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ProgressBar();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userData = snapshot.data ?? []; // Reverse the list
            log("userData ${userData[0].toString()}");
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: getHeight(50),
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Get.find<GeneralController>().image == null
                          ? Container(
                              alignment: Alignment.topCenter,
                              height: getHeight(80),
                              width: getWidth(80),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: black,
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: (userData[0]['image']?.isNotEmpty ?? false) ? userData[0]['image'] : app_logo,
                                  placeholder: (context, url) => ProgressBar(),
                                  errorWidget: (context, url, error) => Image.asset(
                                    app_logo,
                                    fit: BoxFit.cover,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Image.file(
                              Get.find<GeneralController>().imageFile!,
                              height: getHeight(100),
                              width: getWidth(100),
                              frameBuilder: (BuildContext context, Widget child, int? frame, bool? wasSynchronouslyLoaded) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: child,
                                );
                              },
                              errorBuilder: (context, e, stackTrace) => Image.asset(error_image),
                            ),
                      InkWell(
                        onTap: () {
                          bottomSheet(context, Platform.isAndroid ? Permission.storage : Permission.photos);
                        },
                        child: const Padding(
                          padding: const EdgeInsets.only(left: 15.0, bottom: 12.0),
                          child: Icon(
                            Icons.edit,
                            color: white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: getHeight(20),
                  ),
                  Row(
                    children: [
                      Text(
                        "sign2".tr.toString().toUpperCase(),
                        style: kSize16ColorWhite.copyWith(color: black, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: getWidth(30),
                      ),
                      Text("${userData[0]["email"]}"),
                    ],
                  ),
                  SizedBox(
                    height: getHeight(12),
                  ),
                  Row(
                    children: [
                      Text(
                        "Name".tr.toString().toUpperCase(),
                        style: kSize16ColorWhite.copyWith(color: black, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: getWidth(30),
                      ),
                      Text("${userData[0]["user_name"]}".toString().capitalizeFirst.toString()),
                    ],
                  ),
                  SizedBox(
                    height: getHeight(12),
                  ),
                  Row(
                    children: [
                      Text(
                        "Phone #".tr.toString().toUpperCase(),
                        style: kSize16ColorWhite.copyWith(color: black, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: getWidth(30),
                      ),
                      Text("${userData[0]["user_phone"]}".toString().capitalizeFirst.toString()),
                    ],
                  ),
                  SizedBox(
                    height: getHeight(12),
                  ),
                  Row(
                    children: [
                      Text(
                        "Location".tr.toString().toUpperCase(),
                        style: kSize16ColorWhite.copyWith(color: black, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: getWidth(30),
                      ),
                      Text("${userData[0]["location"]}".toString().capitalizeFirst.toString()),
                    ],
                  ),
                  SizedBox(
                    height: getHeight(12),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
