import '../controllers/home_controller.dart';
import '../controllers/i_am_lost_controller.dart';
import '../controllers/i_have_found_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

CollectionReference posts = FirebaseFirestore.instance.collection('posts');
CollectionReference users = FirebaseFirestore.instance.collection('users');

CollectionReference chatroom =
FirebaseFirestore.instance.collection('chat_room');

  Future<List<Map<String, dynamic>>?> getPosts() async {
    final querySnapshot = await posts.get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } else {
      return null; // No posts found for the user
    }
  }

  Future<List<Map<String, dynamic>>?> getPostsByUser() async {

    final querySnapshot = await posts.where('userId', isEqualTo: FirebaseAuth
        .instance.currentUser!.uid).get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } else {
      return null; // No posts found for the user
    }
  }

Future<List<Map<String, dynamic>>> getLookingPosts() async {
  final querySnapshot = await posts.where('postType', isEqualTo: 'looking').get();
  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } else {
    return []; // Return an empty list if no "looking" posts are found.
  }
}
Future<List<Map<String, dynamic>>> getFoundPosts() async {
  final querySnapshot = await posts.where('postType', isEqualTo: 'found').get();
  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } else {
    return []; // Return an empty list if no "looking" posts are found.
  }
}
Future<List<Map<String, dynamic>>> getLostPosts() async {
  final querySnapshot = await posts.where('postType', isEqualTo: 'lost').get();
  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } else {
    return []; // Return an empty list if no "looking" posts are found.
  }
}

Future<List<Map<String, dynamic>>> searchPosts(String ? name) async {
  final querySnapshot = await posts.where('name', isEqualTo: '$name').get();
  Get.log("query data ${querySnapshot.docs}");
  if (querySnapshot.docs.isNotEmpty) {
    Get.log("search results${querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList()}");
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } else {
    return []; // Return an empty list if no "looking" posts are found.
  }
}

Future<List<Map<String, dynamic>>> getUserDataByEmail({String? email}) async {
  final querySnapshot = await users.where('email', isEqualTo: email).get();
  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } else {
    return [];
  }


}

Future<List<Map<String, dynamic>>> getChatData({String? email}) async {
  final querySnapshot = await users.where('email', isEqualTo: email).get();
  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  } else {
    return [];
  }


}
Future<List<DocumentSnapshot>> fetchChats() async {
  QuerySnapshot querySnapshot = await chatroom.get();
  return querySnapshot.docs;
}



