import 'package:flutter/material.dart';
import 'package:loved_app/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:loved_app/utils/firebase_functions.dart';
import 'package:loved_app/utils/size_config.dart';
import 'package:loved_app/view/post_details_screen.dart';
import '../controllers/i_have_found_controller.dart';
import '../utils/colors.dart';
import '../widgets/progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class IHaveFoundViewScreen extends StatelessWidget {
  IHaveFoundViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: textFieldClr,
      appBar: AppBar(
          elevation: 0,
          title: const Text("Found Posts"),
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
        future: getFoundPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ProgressBar();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final gunPins = (snapshot.data ?? []).reversed.toList(); // Reverse the list
            Get.log("gunpins $gunPins");
            return gunPins.isEmpty
                ? Center(
                    child: Image.asset(
                      "assets/icons/no_pics_show.png",
                      fit: BoxFit.cover,
                      height: getHeight(300),
                      width: getWidth(300),
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    itemCount: gunPins.length,
                    separatorBuilder: (context, index) => SizedBox(
                      height: getHeight(12),
                    ),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: (){
                        Get.to(()=>PostDetailsScreen(postData: {
                          "name": gunPins[index]['name'],
                          "user_name": gunPins[index]['user_name'],
                          "chatRoomId": gunPins[index]['chatRoomId'],

                          "last known address": gunPins[index]['last known address'],
                          "age": gunPins[index]['age'],
                          "race": gunPins[index]['race'],
                          "hair_color": gunPins[index]['hair_color'],
                          "identifying characteristics": gunPins[index]['identifying characteristics'],
                          "dv_token": gunPins[index]['dv_token'],
                          'userId': gunPins[index]['userId'], // Replace with the actual user's ID
                          'timestamp': gunPins[index]['timestamp'],
                          'postType': 'found',
                          "pic_person": gunPins[index]['pic_person'],
                        }));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        // height: getHeight(150),
                        // width: getWidth(375),
                        decoration: BoxDecoration(
                            color: greyFont.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: getHeight(80),
                                  width: getWidth(80),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle, color: black),
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: gunPins[index]['pic_person'],
                                      placeholder: (context, url) =>
                                          ProgressBar(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: getWidth(15),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Name:",
                                      style:
                                          TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: getWidth(15),
                                    ),
                                    SizedBox(
                                        width: getWidth(190),
                                        child: Text(
                                          gunPins[index]['name'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: true,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Age:",
                                      style:
                                          TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: getWidth(15),
                                    ),
                                    SizedBox(
                                        width: getWidth(170),
                                        child: Text(
                                          gunPins[index]['age'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: true,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Race:",
                                      style:
                                          TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: getWidth(15),
                                    ),
                                    SizedBox(
                                        width: getWidth(135),
                                        child: Text(
                                          gunPins[index]['race'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: true,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Hair Color:",
                                      style:
                                          TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: getWidth(15),
                                    ),
                                    SizedBox(
                                        width: getWidth(100),
                                        child: Text(
                                          gunPins[index]['hair_color'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          softWrap: true,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          }
        },
      ),
    );
  }
}
