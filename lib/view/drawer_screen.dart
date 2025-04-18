import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loved_app/view/login_screen.dart';
import 'package:loved_app/view/profile_screen.dart';
import '../controllers/general_controller.dart';
import '../utils/colors.dart';
import '../utils/const.dart';
import '../utils/size_config.dart';
import '../utils/text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_button_with_gradient.dart';

class DrawerScreen extends StatelessWidget {
  DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        // backgroundColor: Color(0xFFF5F5F5),
        appBar: AppBar(
            elevation: 0,
            title: const Text("Setting"),
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: const AlignmentDirectional(-0.05, 0),
              child: Container(
                width: 100,
                height: 150,
                decoration: const BoxDecoration(),
                alignment: const AlignmentDirectional(0, -0.09999999999999998),
              ),
            ),
            ListTile(
              title: const Text(
                'Profile',
              ),
              onTap: () {
                Get.to(()=>ProfileScreen(),transition: Transition.noTransition);
              },
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF303030),
                size: 20,
              ),
              // tileColor: Color(0xFFF5F5F5),
              dense: false,
            ),
            SizedBox(
              height: getHeight(12),
            ),
            // ListTile(
            //   title: const Text(
            //     'Privacy Policy',
            //   ),
            //   onTap: () {},
            //   trailing: const Icon(
            //     Icons.arrow_forward_ios,
            //     color: Color(0xFF303030),
            //     size: 20,
            //   ),
            //   // tileColor: Color(0xFFF5F5F5),
            //   dense: false,
            // ),
            // SizedBox(
            //   height: getHeight(12),
            // ),
            // ListTile(
            //   title: const Text(
            //     'Terms and Conditions',
            //   ),
            //   onTap: () {},
            //   trailing: const Icon(
            //     Icons.arrow_forward_ios,
            //     color: Color(0xFF303030),
            //     size: 20,
            //   ),
            //   // tileColor: Color(0xFFF5F5F5),
            //   dense: false,
            // ),

            ListTile(
              title: InkWell(
                onTap: () {
                  // Get.back();

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                              height: getHeight(225),
                              width: getWidth(374),
                              // padding: EdgeInsets.only(left: getWidth(12)),
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: getHeight(20),
                                  ),
                                  Text(
                                    "Logout Account".tr,
                                    style: kSize24W500ColorWhite.copyWith(
                                        color: black),
                                  ),
                                  SizedBox(
                                    height: getHeight(20),
                                  ),
                                  Text(
                                    "Are you sure you want to logout?".tr,
                                    style: kSize16W400ColorBlack,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: getHeight(36),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomButton(
                                        width: getWidth(145),
                                        text: "Cancel".tr,
                                        onPressed: () {
                                          Get.back();
                                        },
                                        textColor: green,
                                        color: white,
                                        borderColor: green,
                                      ),
                                      CustomButtonWithGradient(
                                        width: getWidth(145),
                                        text: "Logout".tr,
                                        onPressed: () {
                                          FirebaseAuth.instance.signOut();
                                          Get.find<GeneralController>()
                                              .lovedBox
                                              .put(cUserSession, false);

                                          Get.offAll(
                                            () => LoginScreen(),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getHeight(32),
                                  ),
                                ],
                              )),
                        );
                      });
                },
                child: const Text(
                  'Logout',
                ),
              ),
              trailing: const Icon(
                Icons.logout,
                color: Color(0xFF303030),
                size: 20,
              ),
              // tileColor: const Color(0xFFF5F5F5),
              dense: false,
            ),
            const Spacer(),
            ListTile(
              title: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                              height: getHeight(225),
                              width: getWidth(374),
                              // padding: EdgeInsets.only(left: getWidth(12)),
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: getHeight(20),
                                  ),
                                  Text(
                                    "Delete Account".tr,
                                    style: kSize24W500ColorWhite.copyWith(
                                        color: black),
                                  ),
                                  SizedBox(
                                    height: getHeight(20),
                                  ),
                                  Text(
                                    "Are you sure you want to delete account?".tr,
                                    style: kSize16W400ColorBlack,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: getHeight(36),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomButton(
                                        width: getWidth(145),
                                        text: "Cancel".tr,
                                        onPressed: () {
                                          Get.back();
                                        },
                                        textColor: green,
                                        color: white,
                                        borderColor: green,
                                      ),
                                      CustomButtonWithGradient(
                                        width: getWidth(145),
                                        text: "Delete".tr,
                                        onPressed: () {
                                          // Get the current user.
                                          User? user =
                                              FirebaseAuth.instance.currentUser;

                                          // Check if the user is signed in.
                                          if (user != null) {
                                            // Delete the user's account.
                                            user.delete().then((_) {
                                              Get.offAll(() => LoginScreen());
                                              print('Account deleted');
                                            }).catchError((error) {
                                              print(
                                                  'Error deleting account: $error');
                                            });
                                          } else {
                                            print('User is not signed in');
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getHeight(32),
                                  ),
                                ],
                              )),
                        );
                      });
                },
                child: const Text(
                  'Delete Account',
                ),
              ),
              trailing: const Icon(
                Icons.logout,
                color: Color(0xFF303030),
                size: 20,
              ),
              // tileColor: const Color(0xFFF5F5F5),
              dense: false,
            ),
            SizedBox(
              height: getHeight(20),
            ),
          ],
        ));
  }
}
