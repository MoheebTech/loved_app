import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/permissions.dart';
import '../utils/const.dart';
import '../utils/singleton.dart';
import '../view/dashboard_screen.dart';
import '../widgets/custom_toasts.dart';
import '../widgets/progress_bar.dart';
import 'general_controller.dart';
import 'home_controller.dart';

class IHaveFoundSomeoneController extends GetxController {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('posts');

  Future<void> ihavefoundPin() async {
    Get.dialog(ProgressBar(), barrierDismissible: false);
    final downloadUrl = await uploadImageToFirebaseStorage(
        Get.find<GeneralController>().imageFile!);
    if (downloadUrl != null) {
      String randomString = Get.find<HomeController>().generateRandomString(8);

      final post = {
        "name": controller1.text,
        "user_name": Get.find<GeneralController>().lovedBox.get(cUserName),
        "chatRoomId":randomString,
        "last known address": controller2.text,
        "age": controller3.text,
        "race": controller4.text,
        "hair_color": controller5.text,
        "identifying characteristics": controller6.text,
        "lat": SingleToneValue.instance.currentLat,
        "lng": SingleToneValue.instance.currentLng,
        "dv_token": Get.find<GeneralController>().lovedBox.get(cDvToken),
        'userId': FirebaseAuth
            .instance.currentUser!.uid, // Replace with the actual user's ID
        'timestamp': DateTime.now(),
        'postType': 'found',
        "pic_person": downloadUrl,
      };
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
      final ref = FirebaseStorage.instance.ref('images/$imgName');
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
    Get.find<GeneralController>().imageFile = null;
    Get.find<GeneralController>().image = null;
  }
}


