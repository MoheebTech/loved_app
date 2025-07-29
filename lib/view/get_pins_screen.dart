import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loved_app/utils/size_config.dart';
import 'package:loved_app/utils/text_styles.dart';

import '../utils/colors.dart';
import '../utils/firebase_functions.dart';
import '../utils/suncfusion_map.dart';
import '../widgets/progress_bar.dart';

class GetPinsMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ProgressBar();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == null) {
            return Scaffold(
              backgroundColor: white,
              appBar: AppBar(
                backgroundColor: white,
                elevation: 0,
                leading: GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back,color: black,size:24)),


              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/icons/no_pics_show.png",
                      fit: BoxFit.cover,
                      height: getHeight(300),
                      width: getWidth(300),
                    ),
                  ),
                  SizedBox(height: getHeight(30),),
                  Text("No Pins to show right now!",style: kSize18W700ColorWhite.copyWith(color: red),),
                ],
              ),
            );
          } else {
            final gunPins = snapshot.data ?? [];
            Get.log("gunpins $gunPins");
            return SyncfusionMap(gunPins: gunPins);
          }
        },
      ),
    );
  }
}
