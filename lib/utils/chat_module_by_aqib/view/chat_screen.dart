import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loved_app/utils/chat_module_by_aqib/controller/chat_controller.dart';
import 'package:loved_app/utils/size_config.dart';
import 'package:get/get.dart';
import 'package:loved_app/widgets/custom_toasts.dart';
import 'package:loved_app/widgets/progress_bar.dart';
import '../../../controllers/general_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_button_with_gradient.dart';
import '../../colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../const.dart';
import '../../text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  String? chatRoomId;
  String? senderUid;
  String? receiverUid;
  String? senderName;
  String? receiverName;
  String? receiverDeviceToken;

  ChatScreen({
    super.key,
    required this.chatRoomId,
    required this.senderUid,
    required this.senderName,
    required this.receiverUid,
    required this.receiverName,
    required this.receiverDeviceToken,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatController chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: getWidth(95),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: const [0.1, 1.0],
              colors: [primaryColor.withOpacity(0.6), blue],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
        ),
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarColor: black,
        //     statusBarIconBrightness: Brightness.light),
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios)),
            Container(
              height: getHeight(50),
              width: getHeight(45),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white),
              ),
              child: const Icon(
                Icons.person,
                color: black,
              ),
            ),
          ],
        ),
        title: Text(
          widget.receiverName.toString().capitalizeFirst.toString(),
          style: kSize18W600ColorBlack.copyWith(color: textColor2),
        ),
      ),
      body:
          // SingleChildScrollView(
          //     child:
          Column(
        children: [
          Expanded(
            child: SizedBox(
              //height: size.height / 1.25,
              width: Get.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: chatController.chatroom
                    .doc(widget.chatRoomId)
                    .collection("new_chat")
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ProgressBar();
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Image.asset(
                        "assets/icons/no_pics_show.png",
                        fit: BoxFit.cover,
                        height: getHeight(300),
                        width: getWidth(300),
                      ),
                    );
                  } else {
                    // Process the snapshot data and update your UI
                    List<DocumentSnapshot> documents = snapshot.data!.docs;
                    // You can now use the 'documents' list to display messages in your UI

                    Get.log("documents ${documents}");
                    Get.log("documents ${documents.length}");
                    return ListView.builder(
                      controller: chatController.scrollController,
                      itemCount: documents.length,
                      shrinkWrap: false,
                      reverse: true,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return messages(
                          map,
                          context,
                          index,
                        );
                      },
                    );
                  }
                },
              ),
              // child: StreamBuilder<DocumentSnapshot>(
              //   stream: _firestore.collection("users").doc("aaa").snapshots(),
              //   builder: (BuildContext context, snapshot) {
              //     print("snapshot $snapshot");
              //     if (snapshot.data != null) {
              //       var data = snapshot.data!;
              //       print("data  ${snapshot.data}");
              //       return Column(
              //         children: [
              //          ,
              //         ],
              //       );
              //     } else {
              //       return const Center(child: CircularProgressIndicator());
              //     }
              //   },
              // ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Get.height / 10,
              width: Get.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: Get.height / 12,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Get.height / 17,
                      width: Get.width / 1.3,
                      child: TextFormField(
                        expands: true,
                        controller: chatController.messageController,
                        //  cursorHeight: 30,
                        maxLines: null,

                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          // print("valuu   ${widget.myMap}");
                          // // updateLastMessage("typing...");
                          // value.isNotEmpty
                          //     ? audioController.updateIsTyping(
                          //   true,
                          // )
                          //     : audioController.updateIsTyping(
                          //   false,
                          // );
                          //
                          // value.isNotEmpty
                          //     ? audioController.isTyping.value = true
                          //     : audioController.isTyping.value = false;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          hintText: "Send Message ...",
                          hintStyle: const TextStyle(
                            decoration: TextDecoration.none,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        style: kSize18W600ColorBlack.copyWith(
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: getWidth(10),
                    ),

                    Obx(
                      () => AnimatedContainer(
                          height: chatController.containerHeight.value,
                          width: chatController.containerHeight.value,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                stops: const [0.1, 1.0],
                                colors: [primaryColor.withOpacity(0.6), blue],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                              ),
                              shape: BoxShape.circle),
                          duration: const Duration(milliseconds: 50),
                          child:
                              // audioController.isTyping.value
                              //     ?
                              IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              chatController.onSendMessage(
                                  chatRoomId: widget.chatRoomId,
                                  senderUid: widget.senderUid,
                                  receiverUid: widget.receiverUid,
                                  senderMap: {
                                    "chatRoomId": widget.chatRoomId,
                                    "senderUid": widget.senderUid,
                                    "senderName": widget.senderName,
                                    "receiverUid": widget.receiverUid,
                                    "receiverName": widget.receiverName,
                                    "time": Timestamp.now(),
                                    "message":
                                        chatController.messageController.text,
                                    "senderDeviceToken":
                                        Get.find<GeneralController>()
                                            .lovedBox
                                            .get(cDvToken),
                                    "receiverDeviceToken":
                                        widget.receiverDeviceToken,
                                  },
                                  receiverMap: {
                                    "chatRoomId": widget.chatRoomId,
                                    "message":
                                        chatController.messageController.text,
                                    "senderUid": widget.senderUid,
                                    "senderName": widget.senderName,
                                    "receiverUid": widget.receiverUid,
                                    "receiverName": widget.receiverName,
                                    "time": Timestamp.now(),
                                    "senderDeviceToken":
                                        Get.find<GeneralController>()
                                            .lovedBox
                                            .get(cDvToken),
                                    "receiverDeviceToken":
                                        widget.receiverDeviceToken,
                                  });
                            },
                          )),
                    ),
                    //   );
                    // }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      //    ),
    );
  }

  Widget messages(Map<String, dynamic> map, BuildContext context, int index) {
    Timestamp timestamp = map["time"] ?? Timestamp.now();
    var date = timestamp.toDate().toLocal();
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    print("coming date ${map["time"]}   $date");

    var time = DateFormat("hh:mm a").format(date).toString();
    print("time   $time");

    return Column(
      crossAxisAlignment:
          map['senderUid'] == FirebaseAuth.instance.currentUser!.uid
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
      children: [
        Container(
          width: Get.width,
          alignment: map['senderUid'] == FirebaseAuth.instance.currentUser!.uid
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: GestureDetector(
            onLongPress: () {
              map['senderUid'] != FirebaseAuth.instance.currentUser!.uid
                  ? showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                              height: getHeight(235),
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
                                    "Report this message?".tr,
                                    style: kSize24W500ColorWhite.copyWith(
                                        color: black),
                                  ),
                                  SizedBox(
                                    height: getHeight(20),
                                  ),
                                  Text(
                                    "This message will be forwarded to admin.User will not be notified".tr,
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
                                        text: "Report".tr,
                                        onPressed: () {
                                        Timer(const Duration(seconds: 1), () {
                                          Get.back();

                                          CustomToast.successToast(msg: "Message reported successfully!");

                                        });
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
                      })
                  : SizedBox();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              // EdgeInsets.only(
              //     left: getWidth(30),
              //     right: getWidth(50),
              //     top: getHeight(17),
              //     bottom: getHeight(10)),
              margin: EdgeInsets.only(
                  left:
                      map['senderUid'] == FirebaseAuth.instance.currentUser!.uid
                          ? 100
                          : 10,
                  right:
                      map['senderUid'] == FirebaseAuth.instance.currentUser!.uid
                          ? 10
                          : 100,
                  bottom: getHeight(12),
                  top: getHeight(12)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color:
                    map['senderUid'] == FirebaseAuth.instance.currentUser!.uid
                        ? green.withOpacity(0.2)
                        : appBackground,
              ),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(
                  map['message'],
                  style: kSize16ColorWhite.copyWith(
                    fontWeight: FontWeight.w400,
                    color: map['senderUid'] ==
                            FirebaseAuth.instance.currentUser!.uid
                        ? textColor
                        : textColor2,
                  ),
                ),
              ]),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              right: map['senderUid'] == FirebaseAuth.instance.currentUser!.uid
                  ? getWidth(10)
                  : 0),
          width: getWidth(75),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                time,
                style: kSize14ColorBlack.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: textColor.withOpacity(0.4),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              // map['sendby'] == FirebaseAuth.instance.currentUser!.uid
              //     ? map["isRead"]
              //     ? const Icon(
              //   Icons.done_all,
              //   color: Colors.black,
              //   size: 15,
              // )
              //     : Icon(
              //   Get.find<AudioController>().isUserOnline.value
              //       ? Icons.done_all
              //       : Icons.done,
              //   color: textColor.withOpacity(0.4),
              //   size: 15,
              // )
              //     : Container()
            ],
          ),
        ),
      ],
    );
  }
}
