import 'package:flutter/material.dart';
import 'package:loved_app/utils/chat_module_by_aqib/controller/chat_controller.dart';
import 'package:loved_app/utils/chat_module_by_aqib/view/chat_screen.dart';
import 'package:loved_app/utils/images.dart';
import 'package:loved_app/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loved_app/utils/text_styles.dart';
import 'package:loved_app/widgets/custom_toasts.dart';
import '../controllers/general_controller.dart';
import '../utils/colors.dart';
import '../utils/const.dart';
import '../widgets/progress_bar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetailsScreen extends StatelessWidget {
  Map<String, dynamic> postData;

  PostDetailsScreen({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: textFieldClr,
      appBar: AppBar(
          elevation: 0,
          title: const Text("Post Details"),
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
      body: Stack(
        children: [
          CachedNetworkImage(
            height: getHeight(540),
            width: getWidth(414),
            imageUrl: postData['pic_person'],
            placeholder: (context, url) => ProgressBar(),
            errorWidget: (context, url, error) => Image.asset(
              error_image,
              height: getHeight(300),
              width: getWidth(300),
              fit: BoxFit.cover,
            ),
            fit: BoxFit.cover,
          ),
          GestureDetector(
            onTap: () async {
              Get.log("eeeee");

              Get.log("chatID ${postData["chatRoomId"]}");
              Get.log("user name ${postData["user_name"]}");
              Get.log(
                  "sender uid ${FirebaseAuth.instance.currentUser!.uid.toString()}");
              Get.log("receiver uid ${postData["userId"]}");

              // Get.to(() => ChatScreen(
              //   chatRoomId:
              //   postData["chatRoomId"],
              //   senderUid: FirebaseAuth
              //       .instance.currentUser!.uid,
              //   receiverUid: postData['userId'],
              //   senderName: Get.find<
              //       GeneralController>()
              //       .lovedBox
              //       .get(cUserName),
              //   receiverName:
              //   postData['user_name'],
              //   receiverDeviceToken:
              //   postData["dv_token"],
              // ));
              Get.find<ChatController>()
                  .chatroom
                  .doc(postData['chatRoomId'])
                  .set({
                "senderUid": FirebaseAuth.instance.currentUser!.uid.toString(),
                "senderName":
                    Get.find<GeneralController>().lovedBox.get(cUserName),
                "receiverUid": postData['userId'],
                "chatRoomId": postData["chatRoomId"],
              });

              if (FirebaseAuth.instance.currentUser!.uid.toString() ==
                  postData["userId"]) {
                try {
                  DocumentSnapshot documentSnapshot =
                      await Get.find<ChatController>()
                          .chatroom
                          .doc(postData['chatRoomId'])
                          .get();

                  if (documentSnapshot.exists) {
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    Get.to(() => ChatScreen(
                          chatRoomId: postData["chatRoomId"],
                          senderUid: FirebaseAuth.instance.currentUser!.uid,
                          receiverUid: data['senderUid'],
                          senderName: Get.find<GeneralController>()
                              .lovedBox
                              .get(cUserName),
                          receiverName: data['senderName'],
                          receiverDeviceToken: postData["dv_token"],
                        ));
                    // Now you can use the data as needed
                    print('Sender UID: ${data['senderUid']}');
                    print('Sender Name: ${data['senderName']}');
                    print('Receiver UID: ${data['receiverUid']}');
                  } else {
                    CustomToast.failToast(
                        msg:
                            "You cannot chat with yourself unless some one initiate first");

                    print('Document does not exist');
                  }
                } catch (e) {
                  print('Error fetching data: $e');
                }
              } else {
                Get.to(() => ChatScreen(
                      chatRoomId: postData["chatRoomId"],
                      senderUid: FirebaseAuth.instance.currentUser!.uid,
                      receiverUid: postData['userId'],
                      senderName:
                          Get.find<GeneralController>().lovedBox.get(cUserName),
                      receiverName: postData['user_name'],
                      receiverDeviceToken: postData["dv_token"],
                    ));
              }
            },
            child: postData['postType'] == 'looking'
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      height: getHeight(350),
                      width: getWidth(414),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                          color: white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Post Type:",
                                style: kSize16ColorWhite.copyWith(
                                    color: black, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: getWidth(15),
                              ),
                              SizedBox(
                                  width: getWidth(100),
                                  child: Text(
                                    postData['postType']
                                        .toString()
                                        .toUpperCase(),
                                    style: kSize16ColorWhite.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  )),
                              const Spacer(),
                              Icon(
                                Icons.chat_rounded,
                                color: black,
                                size: getHeight(30),
                              ),
                              SizedBox(
                                width: getWidth(25),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Name:",
                                style: kSize16ColorWhite.copyWith(
                                    color: black, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: getWidth(15),
                              ),
                              SizedBox(
                                  width: getWidth(100),
                                  child: Text(
                                    postData['name'].toString().toUpperCase(),
                                    style: kSize16ColorWhite.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Last Cell Number:",
                                style: kSize16ColorWhite.copyWith(
                                    color: black, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: getWidth(15),
                              ),
                              SizedBox(
                                  width: getWidth(100),
                                  child: Text(
                                    postData['last cell number']
                                        .toString()
                                        .toUpperCase(),
                                    style: kSize16ColorWhite.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Last Known School:",
                                style: kSize16ColorWhite.copyWith(
                                    color: black, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: getWidth(15),
                              ),
                              SizedBox(
                                  width: getWidth(100),
                                  child: Text(
                                    postData['last known school']
                                        .toString()
                                        .toUpperCase(),
                                    style: kSize16ColorWhite.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Last Known Employer:",
                                style: kSize16ColorWhite.copyWith(
                                    color: black, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: getWidth(15),
                              ),
                              SizedBox(
                                  width: getWidth(100),
                                  child: Text(
                                    postData['last known employer']
                                        .toString()
                                        .toUpperCase(),
                                    style: kSize16ColorWhite.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Last Seen:",
                                style: kSize16ColorWhite.copyWith(
                                    color: black, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: getWidth(15),
                              ),
                              SizedBox(
                                  width: getWidth(100),
                                  child: Text(
                                    postData['last seen']
                                        .toString()
                                        .toUpperCase(),
                                    style: kSize16ColorWhite.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Last Known Address:",
                                style: kSize16ColorWhite.copyWith(
                                    color: black, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: getWidth(15),
                              ),
                              SizedBox(
                                  width: getWidth(100),
                                  child: Text(
                                    postData['last known address']
                                        .toString()
                                        .toUpperCase(),
                                    style: kSize16ColorWhite.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Identifying Characteristics:",
                                style: kSize16ColorWhite.copyWith(
                                    color: black, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: getWidth(15),
                              ),
                              SizedBox(
                                  width: getWidth(100),
                                  child: Text(
                                    postData['identifying characteristics']
                                        .toString()
                                        .toUpperCase(),
                                    style: kSize16ColorWhite.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: black),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Time Posted:",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: getWidth(15),
                              ),
                              SizedBox(
                                  width: getWidth(120),
                                  child: Text(
                                    DateFormat('yyyy-MM-dd').format(
                                      (postData['timestamp'] as Timestamp).toDate(),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : postData['postType'] == 'lost'
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          height: getHeight(350),
                          width: getWidth(414),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              color: white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Post Type:",
                                    style: kSize16ColorWhite.copyWith(
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(100),
                                      child: Text(
                                        postData['postType']
                                            .toString()
                                            .toUpperCase(),
                                        style: kSize16ColorWhite.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      )),
                                  const Spacer(),
                                  Icon(
                                    Icons.chat_rounded,
                                    color: black,
                                    size: getHeight(30),
                                  ),
                                  SizedBox(
                                    width: getWidth(25),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Name:",
                                    style: kSize16ColorWhite.copyWith(
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(100),
                                      child: Text(
                                        postData['name']
                                            .toString()
                                            .toUpperCase(),
                                        style: kSize16ColorWhite.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Last Cell Number:",
                                    style: kSize16ColorWhite.copyWith(
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(100),
                                      child: Text(
                                        postData['last cell number']
                                            .toString()
                                            .toUpperCase(),
                                        style: kSize16ColorWhite.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Last Known School:",
                                    style: kSize16ColorWhite.copyWith(
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(100),
                                      child: Text(
                                        postData['last known school']
                                            .toString()
                                            .toUpperCase(),
                                        style: kSize16ColorWhite.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Last Known Employer:",
                                    style: kSize16ColorWhite.copyWith(
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(100),
                                      child: Text(
                                        postData['last known employer']
                                            .toString()
                                            .toUpperCase(),
                                        style: kSize16ColorWhite.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Last Known Address:",
                                    style: kSize16ColorWhite.copyWith(
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(100),
                                      child: Text(
                                        postData['last known address']
                                            .toString()
                                            .toUpperCase(),
                                        style: kSize16ColorWhite.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Identifying Characteristics:",
                                    style: kSize16ColorWhite.copyWith(
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(100),
                                      child: Text(
                                        postData['identifying characteristics']
                                            .toString()
                                            .toUpperCase(),
                                        style: kSize16ColorWhite.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Time Posted:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(120),
                                      child: Text(
                                        DateFormat('yyyy-MM-dd').format(
                                          (postData['timestamp'] as Timestamp).toDate(),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          height: getHeight(350),
                          width: getWidth(414),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              color: white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Post Type:",
                                    style: kSize16ColorWhite.copyWith(
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(100),
                                      child: Text(
                                        postData['postType']
                                            .toString()
                                            .toUpperCase(),
                                        style: kSize16ColorWhite.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      )),
                                  const Spacer(),
                                  // FirebaseAuth.instance.currentUser!.uid
                                  //             .toString() ==
                                  //         postData["userId"]
                                  //     ?
                                  Icon(
                                    Icons.chat_rounded,
                                    color: black,
                                    size: getHeight(30),
                                  ),
                                  // : const SizedBox(),
                                  SizedBox(
                                    width: getWidth(25),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Name:",
                                    style: kSize16ColorWhite.copyWith(
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(100),
                                      child: Text(
                                        postData['name']
                                            .toString()
                                            .toUpperCase(),
                                        style: kSize16ColorWhite.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Location:",
                                    style: kSize16ColorWhite.copyWith(
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(100),
                                      child: Text(
                                        postData['last known address']
                                            .toString()
                                            .toUpperCase(),
                                        style: kSize16ColorWhite.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Age:",
                                    style: kSize16ColorWhite.copyWith(
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(100),
                                      child: Text(
                                        postData['age']
                                            .toString()
                                            .toUpperCase(),
                                        style: kSize16ColorWhite.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Race:",
                                    style: kSize16ColorWhite.copyWith(
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(100),
                                      child: Text(
                                        postData['race']
                                            .toString()
                                            .toUpperCase(),
                                        style: kSize16ColorWhite.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Hair Color:",
                                    style: kSize16ColorWhite.copyWith(
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(100),
                                      child: Text(
                                        postData['hair_color']
                                            .toString()
                                            .toUpperCase(),
                                        style: kSize16ColorWhite.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Identifying Characteristics:",
                                    style: kSize16ColorWhite.copyWith(
                                        color: black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(100),
                                      child: Text(
                                        postData['identifying characteristics']
                                            .toString()
                                            .toUpperCase(),
                                        style: kSize16ColorWhite.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: black),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Time Posted:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: getWidth(15),
                                  ),
                                  SizedBox(
                                      width: getWidth(120),
                                      child: Text(
                                        DateFormat('yyyy-MM-dd').format(
                                          (postData['timestamp'] as Timestamp).toDate(),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
