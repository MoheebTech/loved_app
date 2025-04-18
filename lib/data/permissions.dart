import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loved_app/controllers/general_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_image_compress/flutter_image_compress.dart';


// XFile? image;
// File? imageFile;

int i = 1;
// var imagePath = "".obs;


getitFromGallery(BuildContext context, Permission platform) async {
  var stauts = await Permission.photos.status;
  await platform.request();
  Get.log("status  $stauts ");
  if (await platform.status.isDenied) {
    // Permission.systemAlertWindow.isPermanentlyDenied;
    if (Platform.isIOS) {
      await platform.request();
    } else {
      showDeleteDialog(context);
    }
  } else if (await platform.status.isPermanentlyDenied) {
    if (Platform.isIOS) {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text("Settings "),
            content: Text(
                "Loved One's want to access camera open settings and give permission"),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("No"),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                onPressed: () => openAppSettings(),
                child: Text("open settings"),
              )
            ],
          ));
    } else {
      showDeleteDialog(context);
    }
    print("is permanant");
  } else if (await platform.isGranted) {
    print("is grandted");
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      print("Picked File: ${pickedFile.path}");
      var imagePath = pickedFile.path;
      // image = File(imagePath);
      // update();

      var imageName = imagePath.split("/").last;
      print("Image Name: $imageName");
      final dir1 = Directory.systemTemp;
      final targetPath1 = "${dir1.absolute.path}/dp$i.jpg";
      var compressedFile1 = await FlutterImageCompress.compressAndGetFile(
          imagePath, targetPath1,
          quality: 60);
      print("compressedFile File: ${compressedFile1!.path}");
      Get.find<GeneralController>().image = compressedFile1;
      //convert XFile to File
      Get.find<GeneralController>().imageFile = File(Get.find<GeneralController>().image!.path);
      imagePath = compressedFile1.path;
      i++;
      Get.find<GeneralController>().update();
    }
    Get.log("ggranted");
    return true;
  } else if (await platform.isLimited) {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      print("Picked File: ${pickedFile.path}");
      var imagePath = pickedFile.path;
      // image = File(imagePath);
      // update();

      var imageName = imagePath.split("/").last;
      print("Image Name: $imageName");
      final dir1 = Directory.systemTemp;
      final targetPath1 = "${dir1.absolute.path}/dp$i.jpg";
      var compressedFile1 = await FlutterImageCompress.compressAndGetFile(
          imagePath, targetPath1,
          quality: 60);
      print("compressedFile File: ${compressedFile1!.path}");
      Get.find<GeneralController>().image = compressedFile1;
      //convert XFile to File
      Get.find<GeneralController>().imageFile = File(Get.find<GeneralController>().image!.path);
      imagePath = compressedFile1.path;
      i++;
      Get.find<GeneralController>().update();
    }
    return true;

  }
}

/// Get from Camera
getitFromCamera(BuildContext context) async {
  //var status = await Permission.camera.status;
  var status = await Permission.camera.status; //
  await Permission.camera.request();
  Get.log("camera ios permission ${await Permission.camera.request()} ");
  if (await Permission.camera.status.isDenied) {
    if (Platform.isIOS) {
      Get.log("denied  ios platform");
      await Permission.camera.request();
    } else {
      showDeleteDialog(context);
    }
  }
  if (await Permission.camera.status.isPermanentlyDenied) {
    if (Platform.isIOS) {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text("Settings"),
            content: Text(
                "Loved One's want to access camera open settings and give permission"),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Not now"),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                child: Text("Open settings"),
                onPressed: openAppSettings,
              )
            ],
          ));
    } else {
      showDeleteDialog(context);
    }
  }
  else if (await Permission.camera.isGranted ||
      await Permission.camera.isLimited) {
    print("is grandted");
    final pickedFile =await  ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      print("Picked File: ${pickedFile.path}");
      var imagePath = pickedFile.path;
      // image = File(imagePath);
      // update();

      var imageName = imagePath.split("/").last;
      print("Image Name: $imageName");
      final dir1 = Directory.systemTemp;
      final targetPath1 = dir1.absolute.path + "/dp${i}.jpg";
      var compressedFile1 = await FlutterImageCompress.compressAndGetFile(
          imagePath, targetPath1,
          quality: 60);
      print("compressedFile File: ${compressedFile1!.path}");
      Get.find<GeneralController>().image = compressedFile1;
      Get.find<GeneralController>().imageFile = File(Get.find<GeneralController>().image!.path);

      imagePath = compressedFile1.path;
      i++;
      Get.find<GeneralController>().update();
    }
    Get.log("ggranted");
    return true;
    // Either the permission was already granted before or the user just granted it.
  }
}

bottomSheet(BuildContext context,Permission platform) {
  Get.bottomSheet(Container(
    height: 170,
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.photo_camera,
                size: 30,
              ),
              onPressed: () {
                Get.back();
                getitFromCamera(context);
              },
            ),
            Text("From Camera")
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.photo,
                size: 30,
              ),
              onPressed: () {
                Get.back();
                getitFromGallery(context, platform);
              },
            ),
            Text("From Gallery")
          ],
        ),
      ],
    ),
  ));
}


bool? serviceEnabled;
var perm1;
Future<bool?> getLatLongStreamData(BuildContext context) async {
  loc.Location location = loc.Location();
  serviceEnabled = await location.serviceEnabled();
  // Get.log("location status service:$serviceEnabled");

  if (serviceEnabled == false) {
    Get.log("service not enabled");
    await Permission.location.request();
    // loc.PermissionStatus status = await location.hasPermission();
    //   Get.log("location status:$status");
    if (await Permission.location.status.isDenied) {
      if (Platform.isIOS) {
        await Permission.location.request();
      } else {
        showDeleteDialog(context);
      }
      Get.log("denied");
    } else if (await Permission.location.status.isPermanentlyDenied) {
      Get.log("isPermanentlyDenied");
      if (Platform.isIOS) {
        showDialog(
            context: Get.context!,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text("Set location access to \"While using the app\""),
              content: Column(
                children: [
                  Text("1.Tap iOS Settings"),
                  Text("2.Tap Location"),
                  Text("3.Tap While Using the App "),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Not now"),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  onPressed: () => openAppSettings(),
                  child: Text("iOS Settings"),
                )
              ],
            ));
      } else {
        showDeleteDialog(context);
      }
    } else if (await Permission.location.status.isGranted) {
      if (Platform.isIOS) {
        showDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text("Turn on  location services"),
              content: Column(
                children: [
                  Text("1.Tap iOS Settings"),
                  Text("2.Tap Settings"),
                  Text("3.Tap Privacy"),
                  Text("4.Tap Location Services"),
                  Text("5.Turn on location services"),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Not now"),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  onPressed: () => openAppSettings(),
                  child: Text("iOS Settings"),
                )
              ],
            ));
      } else {
        await location.requestService();
      }
      Get.log("isGranted");
    } else if (await Permission.location.status.isLimited) {
      Get.log("limited");
    }
  } else {
    await Permission.location.request();
    if (await Permission.location.status.isGranted) {
      Get.log("granteed");
    } else if (await Permission.location.status.isLimited) {
      Get.log("limiyted");
    } else if (await Permission.location.status.isDenied) {
      Get.log("in per denied");
      //

      if (Platform.isIOS) {
        await Permission.location.request();
      } else {
        showDeleteDialog(context);
      }
    } else if (await Permission.location.status.isPermanentlyDenied) {
      if (Platform.isIOS) {
        showDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text("Set location access to \"While using the app\""),
              content: Column(
                children: [
                  Text("1.Tap iOS Settings"),
                  Text("2.Tap Location"),
                  Text("3.Tap While Using the App "),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Not now"),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  onPressed: () => openAppSettings(),
                  child: Text("iOS Settings"),
                )
              ],
            ));
      } else {
        showDeleteDialog(context);
      }
    }
  }
  return false;
}

showDeleteDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: Text(
      "Not now",
      style: TextStyle(fontSize: 12),
    ),
  );
  Widget continueButton = GestureDetector(
    onTap: () async {
      openAppSettings();
    },
    child: Text("Open settings".tr,
        style: TextStyle(fontStyle: FontStyle.normal, fontSize: 12)),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    actionsPadding: EdgeInsets.only(right: 15, bottom: 15),
    title: Text(
      "Settings".tr,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    ),
    content: Text(
      "For the best experience, Loved One's needs to use your current location to find closest farmer"
          .tr,
      style: TextStyle(fontWeight: FontWeight.w400),
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
