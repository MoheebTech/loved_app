import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loved_app/controllers/i_have_found_controller.dart';
import 'package:loved_app/utils/size_config.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/general_controller.dart';
import '../controllers/home_controller.dart';
import '../data/permissions.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import '../utils/text_styles.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_toasts.dart';

class IHaveSeenScreen extends StatelessWidget {
  IHaveSeenScreen({super.key});

  IHaveFoundSomeoneController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    int _selectedRadio = 0;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: Text("I have found someone"),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: [0.1, 1.0],
                  colors: [primaryColor.withOpacity(0.6), blue],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
              ),
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                SizedBox(
                  height: getHeight(50),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(10), vertical: getHeight(20)),
                  // height: getHeight(350),
                  width: getWidth(374),
                  decoration: BoxDecoration(
                      color: white, borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Name".tr,
                        style: kSize16W500ColorBlack,
                      ),
                      GetBuilder<IHaveFoundSomeoneController>(
                          builder: (context) {
                        return CustomTextField(
                          backgroundColor: white,
                          height: getHeight(48),
                          text: "Enter name of person",
                          length: 100,
                          controller: homeController.controller1,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode:
                              homeController.controller1.text.isNotEmpty
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                          onChanged: (value) {
                            homeController.update();
                          },
                          inputFormatters:
                              FilteringTextInputFormatter.singleLineFormatter,
                        );
                      }),
                      SizedBox(
                        height: getHeight(15),
                      ),
                      Text(
                        "Location".tr,
                        style: kSize16W500ColorBlack,
                      ),
                      GetBuilder<IHaveFoundSomeoneController>(
                          builder: (context) {
                        return CustomTextField(
                          backgroundColor: white,
                          height: getHeight(48),
                          text: "Enter address",
                          length: 500,
                          // maxlines: 4,
                          controller: homeController.controller2,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode:
                              homeController.controller2.text.isNotEmpty
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                          onChanged: (value) {
                            homeController.update();
                          },
                          inputFormatters:
                              FilteringTextInputFormatter.singleLineFormatter,
                        );
                      }),
                      SizedBox(
                        height: getHeight(15),
                      ),
                      Text(
                        "Age".tr,
                        style: kSize16W500ColorBlack,
                      ),
                      GetBuilder<IHaveFoundSomeoneController>(
                          builder: (context) {
                        return CustomTextField(
                          backgroundColor: white,
                          height: getHeight(48),
                          width: getWidth(Get.width),
                          text: "Age",
                          length: 500,
                          controller: homeController.controller3,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode:
                              homeController.controller3.text.isNotEmpty
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                          onChanged: (value) {
                            homeController.update();
                          },
                          inputFormatters:
                              FilteringTextInputFormatter.singleLineFormatter,
                        );
                      }),
                      SizedBox(
                        height: getHeight(15),
                      ),
                      Text(
                        "Race".tr,
                        style: kSize16W500ColorBlack,
                      ),
                      GetBuilder<IHaveFoundSomeoneController>(
                          builder: (context) {
                        return CustomTextField(
                          backgroundColor: white,
                          height: getHeight(48),
                          text: "Enter the person race",
                          length: 100,
                          controller: homeController.controller4,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode:
                              homeController.controller4.text.isNotEmpty
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                          onChanged: (value) {
                            homeController.update();
                          },
                          inputFormatters:
                              FilteringTextInputFormatter.singleLineFormatter,
                        );
                      }),
                      SizedBox(
                        height: getHeight(15),
                      ),
                      Text(
                        "Hair Color".tr,
                        style: kSize16W500ColorBlack,
                      ),
                      GetBuilder<IHaveFoundSomeoneController>(
                          builder: (context) {
                        return CustomTextField(
                          backgroundColor: white,
                          height: getHeight(48),
                          text: "Enter hair color of person",
                          length: 100,
                          controller: homeController.controller5,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode:
                              homeController.controller5.text.isNotEmpty
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                          onChanged: (value) {
                            homeController.update();
                          },
                          inputFormatters:
                              FilteringTextInputFormatter.singleLineFormatter,
                        );
                      }),
                      SizedBox(
                        height: getHeight(15),
                      ),
                      Text(
                        "Identifying Characteristics".tr,
                        style: kSize16W500ColorBlack,
                      ),
                      GetBuilder<IHaveFoundSomeoneController>(
                          builder: (context) {
                        return CustomTextField(
                          backgroundColor: white,
                          height: getHeight(48),
                          text: "Identifying Characteristics",
                          length: 100,
                          controller: homeController.controller6,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode:
                              homeController.controller6.text.isNotEmpty
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                          onChanged: (value) {
                            homeController.update();
                          },
                          inputFormatters:
                              FilteringTextInputFormatter.singleLineFormatter,
                        );
                      }),
                      SizedBox(
                        height: getHeight(15),
                      ),
                      Text(
                        "Photo of the person".tr,
                        style: kSize16W500ColorBlack,
                      ),
                      SizedBox(
                        height: getHeight(8),
                      ),
                      GetBuilder<GeneralController>(builder: (context) {
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Get.find<GeneralController>().image == null
                                ? GestureDetector(
                                    onTap: () {
                                      bottomSheet(
                                          context,
                                          Platform.isAndroid
                                              ? Permission.storage
                                              : Permission.photos);
                                    },
                                    child: Container(
                                      height: getHeight(150),
                                      width: getWidth(100),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: black.withOpacity(0.5)),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: black.withOpacity(0.3),
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                  )
                                : Image.file(
                              Get.find<GeneralController>().imageFile!,
                                    height: getHeight(100),
                                    width: getWidth(100),
                                    frameBuilder: (BuildContext context,
                                        Widget child,
                                        int? frame,
                                        bool? wasSynchronouslyLoaded) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: child,
                                      );
                                    },
                                    errorBuilder: (context, e, stackTrace) =>
                                        Image.asset(error_image),
                                  );
                            // : FadeInImage.assetNetwork(
                            //     height: getHeight(100),
                            //     width: getWidth(100),
                            //
                            //     placeholder: loading_pic,
                            //     image:
                            //         "${Get.find<GeneralController>().image}",
                            //     fit: BoxFit.cover,
                            //     imageErrorBuilder: (context, e, stackTrace) =>
                            //         Image.asset(error_image),
                            //   );
                          },
                        );
                      }),
                      SizedBox(
                        height: getHeight(15),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getHeight(40),
                ),
                GestureDetector(
                  onTap: () {


                    Get.find<GeneralController>().image == null
                        ? CustomToast.failToast(
                            msg: "Please add picture first".tr)
                        : homeController.ihavefoundPin();
                  },
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: getHeight(70),
                      width: getWidth(374),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: [0.1, 1.0],
                            colors: [primaryColor.withOpacity(0.6), blue],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          "Post".tr,
                          style: kSize32W700ColorBlack.copyWith(color: white),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getHeight(50),
                ),
                Text(
                  "home8".tr,
                  style: kSize16ColorWhite,
                ),
                SizedBox(
                  height: getHeight(20),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
