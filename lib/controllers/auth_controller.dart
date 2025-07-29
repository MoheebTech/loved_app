import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:loved_app/data/firebase_notification/firebase_notification.dart';

import 'package:loved_app/utils/location_permissions.dart';
import 'package:loved_app/utils/firebase_functions.dart';
import 'package:loved_app/view/dashboard_screen.dart';
import 'package:loved_app/view/login_screen.dart';

import '../utils/const.dart';
import '../view/home_screen.dart';
import '../widgets/custom_toasts.dart';
import '../widgets/progress_bar.dart';
import 'general_controller.dart';

class AuthController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  //
  // int i = 1;
  var imagePath = "".obs;
  loginUserFunc() {
    Get.dialog(ProgressBar(), barrierDismissible: false);

    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) async {
        Get.find<GeneralController>().lovedBox.put(cUserSession, true);
        Get.find<GeneralController>().lovedBox.put(cUserEmail, emailController.text);

        await getUserDataByEmail(email: emailController.text).then((value) {
          Get.log("login email ${value[0]["email"]}");
          Get.log("login user name ${value[0]["user_name"]}");
          Get.find<GeneralController>().lovedBox.put(cUserEmail, value[0]["email"]);
          Get.find<GeneralController>().lovedBox.put(cUserName, value[0]["user_name"]);
          Get.find<GeneralController>().lovedBox.put(cUserImage, value[0]["image"]);
          // setAccountData(value[0]["user_name"], value[0]["email"], FirebaseAuth.instance.currentUser!.uid);
        });
        // users.doc(FirebaseAuth.instance.currentUser!.uid)
        //     .set({
        //   "status": "Online",
        // });
        await getCurrentLocation();
        await FirebaseNotifications().getDeviceToken();

        Get.to(() => const DashBoardScreen());

        emailController.clear();

        passwordController.clear();
      }, onError: (e) {
        Get.back();
        CustomToast.failToast(msg: "$e");
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        CustomToast.failToast(msg: "sign7".tr);
      } else if (e.code == 'wrong-password') {
        CustomToast.failToast(msg: "sign8".tr);
      }
      Get.back();
    } catch (e) {
      Get.back();
      debugPrint(e.toString());
    }
  }

  createUserFunc() {
    Get.dialog(ProgressBar(), barrierDismissible: false);

    try {
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) async {
        Future.wait([
          addUserData(),
        ]);
        Get.find<GeneralController>().lovedBox.put(cUserSession, true);
        Get.find<GeneralController>().lovedBox.put(cUserEmail, emailController.text);
        Get.find<GeneralController>().lovedBox.put(cUserName, nameController.text);
        Get.find<GeneralController>().lovedBox.put(cUserImage, '');
        await getCurrentLocation();
        // setAccountData(nameController.text, emailController.text, FirebaseAuth.instance.currentUser!.uid);
        // users.doc(FirebaseAuth.instance.currentUser!.uid)
        //     .set({
        //   "status": "Online",
        // });
        await FirebaseNotifications().getDeviceToken();

        Get.to(() => const DashBoardScreen());
        nameController.clear();
        emailController.clear();
        locationController.clear();
        phoneController.clear();
        passwordController.clear();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        CustomToast.failToast(msg: "sign7".tr);
      } else if (e.code == 'wrong-password') {
        CustomToast.failToast(msg: "sign8".tr);
      }
      Get.back();
    } catch (e) {
      print(e);
    }
  }

  ///add user data to firebase
  Future addUserData() {
    return users.add({
      'user_name': nameController.text,
      'location': locationController.text,
      'email': emailController.text,
      'user_phone': phoneController.text,
      'image': '',
      // 'user_id': FirebaseAuth.instance.currentUser!.uid,
    }).then((value) {
      // CustomToast.successToast(msg: "Data added Successfully!");

      ///optional
    }).catchError((error) => CustomToast.failToast(msg: "Failed to add user: $error"));
  }

  checkSession() async {
    if (Get.find<GeneralController>().lovedBox.get(cUserSession, defaultValue: false) == true) {
      await getCurrentLocation();

      Get.to(() => const DashBoardScreen());
    } else {
      Get.offAll(() => LoginScreen());
    }
  }

  logout() {
    FirebaseAuth.instance.signOut();
    Get.find<GeneralController>().lovedBox.put(cUserSession, false);

    Get.offAll(
      () => LoginScreen(),
    );
  }
}
