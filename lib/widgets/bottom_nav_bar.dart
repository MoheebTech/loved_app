import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loved_app/controllers/auth_controller.dart';
import 'package:loved_app/utils/images.dart';
import 'package:loved_app/utils/size_config.dart';
import 'package:loved_app/view/drawer_screen.dart';
import 'package:loved_app/view/user_post_screen.dart';

import '../utils/colors.dart';
import '../view/get_pins_screen.dart';
import '../view/iam_looking_screen.dart';
import '../view/iam_lost_screen.dart';
import '../view/ihave_seen_screen.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
      height: getHeight(80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0.1, 1.0],
          colors: [primaryColor.withOpacity(0.6), blue],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => DrawerScreen());
            },
            child: Icon(
              Icons.view_headline_sharp,
              size: getHeight(30),
              color: white,
            ),
          ),
          Spacer(),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.add,
              size: getHeight(30),
              color: white,
            ),
            // onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return <String>[
                'home1'.tr,
                'home2'.tr,
                'home3'.tr,
              ].map((String choice) {
                return PopupMenuItem<String>(
                  onTap: () {
                    choice == 'home1'.tr
                        ? Get.to(() =>IAmLostScreen ())
                        : choice == 'home2'.tr
                            ? Get.to(() => IAmLookingScreen())
                            : Get.to(() => IHaveSeenScreen());
                  },
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
          SizedBox(
            width: getWidth(20),
          ),
          GestureDetector(
            onTap: (){
              // Get.find<AuthController>().logout();
              Get.to(()=>UserPostsScreen(),transition: Transition.noTransition);
            },
            child: Icon(
              Icons.person,
              size: getHeight(30),
              color: white,
            ),
          ),
          SizedBox(
            width: getWidth(12),
          ),
          GestureDetector(
            onTap: (){
              Get.to(()=>GetPinsMap(),transition: Transition.noTransition);

            },
            child: Image.asset(
              map_pin,
              height: getHeight(30),
              width: getWidth(30),
              color: white,
            ),
          ),
        ],
      ),
    );
  }
}
