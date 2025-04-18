import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loved_app/utils/firebase_functions.dart';
import 'package:loved_app/utils/size_config.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/general_controller.dart';
import '../utils/colors.dart';
import '../utils/const.dart';
import '../utils/text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_password_textfeild.dart';
import '../widgets/custom_textfield.dart';
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
        future: getUserDataByEmail(
            email: Get.find<GeneralController>().lovedBox.get(cUserEmail)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ProgressBar();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userData = snapshot.data ?? []; // Reverse the list
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getHeight(50),
                  ),
                  Row(
                    children: [
                      Text(
                        "sign2".tr.toString().toUpperCase(),
                        style: kSize16ColorWhite.copyWith(
                            color: black, fontWeight: FontWeight.w600),
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
                        style: kSize16ColorWhite.copyWith(
                            color: black, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: getWidth(30),
                      ),
                      Text("${userData[0]["user_name"]}"),
                    ],
                  ),
                  SizedBox(
                    height: getHeight(12),
                  ),
                  Row(
                    children: [
                      Text(
                        "Phone #".tr.toString().toUpperCase(),
                        style: kSize16ColorWhite.copyWith(
                            color: black, fontWeight: FontWeight.w600),
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
                        "Location".tr.toString().toUpperCase(),
                        style: kSize16ColorWhite.copyWith(
                            color: black, fontWeight: FontWeight.w600),
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
