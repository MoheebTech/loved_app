import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loved_app/utils/const.dart';
import 'package:loved_app/utils/singleton.dart';
import 'package:loved_app/view/dashboard_screen.dart';
import 'package:loved_app/widgets/progress_bar.dart';

import '../data/permissions.dart';
import '../widgets/custom_toasts.dart';
import 'general_controller.dart';

class HomeController extends GetxController {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  TextEditingController controller7 = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('posts');

  Future<void> iAmLookingPin() async {
    Get.dialog(ProgressBar(), barrierDismissible: false);
    final downloadUrl = await uploadImageToFirebaseStorage(
        Get.find<GeneralController>().imageFile!);
    if (downloadUrl != null) {
      String randomString = generateRandomString(8);
      final post = {
        "name": controller1.text,
        "chatRoomId":randomString,
        "user_name": Get.find<GeneralController>().lovedBox.get(cUserName),
        "last known address": controller2.text,
        "last cell number": controller3.text,
        "last known school": controller4.text,
        "last known employer": controller5.text,
        "last seen": controller6.text,
        "identifying characteristics": controller7.text,
        "lat": SingleToneValue.instance.currentLat,
        "lng": SingleToneValue.instance.currentLng,
        "dv_token": Get.find<GeneralController>().lovedBox.get(cDvToken),
        'userId': FirebaseAuth
            .instance.currentUser!.uid, // Replace with the actual user's ID
        'timestamp': DateTime.now(),
        'postType': 'looking',
        "pic_person": downloadUrl,
      };
      // checkFirebaseDataIsEmpty(docRef, post);
      setFireStoreData(post);
    } else {
      Get.back();
      CustomToast.failToast(msg: 'Your picture is not correct');
    }

    // Check if Firebase data is empty, and initialize with a default list if necessary.
  }

  Future<String?> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      final imgName = imageFile.path.split("/").last;
      Get.log("imgname $imgName");
      final ref = FirebaseStorage.instance.ref('images/$imgName');
      Get.log("ref $ref");

      final task = ref.putFile(imageFile);
      await task.whenComplete(() {});
      return await task.snapshot.ref.getDownloadURL();
    } catch (error) {
      // Handle errors gracefully, e.g., throw custom exceptions or show specific error messages.
      Get.log("Failed to upload image: $error");
      CustomToast.failToast(msg: "Failed to upload image: $error");
      return null;
    }
  }

  void setFireStoreData(Map<String, dynamic> data) {
    users.add(data).then((_) {
      cleanControllers();
      Get.back();
      Get.to(() => const DashBoardScreen(),
          transition: Transition.noTransition);

      CustomToast.successToast(msg: "Post Successfully Placed");
    }).catchError((error) {
      Get.log("Failed to add data: $error");
      CustomToast.failToast(msg: "Failed to add data: $error");
    });
  }

  void cleanControllers() {
    controller1.clear();
    controller2.clear();
    controller3.clear();
    controller4.clear();
    controller5.clear();
    controller6.clear();
    controller7.clear();
    Get.find<GeneralController>().imageFile = null;
    Get.find<GeneralController>().image = null;
  }

  String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }
}

