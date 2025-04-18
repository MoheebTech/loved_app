import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loved_app/view/post_details_screen.dart';

import '../utils/colors.dart';
import '../utils/firebase_functions.dart';
import '../utils/size_config.dart';
import '../widgets/progress_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: textFieldClr,
      appBar: AppBar(
          elevation: 0,
          title: const Text("Search People"),
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
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: onSearchTextChanged,
              decoration: const InputDecoration(
                hintText: 'Enter your search query...',
              ),
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchController.text.isEmpty) {
      return const Center(
        child: Text('Start typing to search.'),
      );
    } else if (_searchResults.isEmpty) {
      return const Center(
        child: Text('No results found. Try a different search.'),
      );
    } else {
      Get.log("search results else ${_searchResults.toList()}");
      Get.log("search results print ${_searchResults[0]['name']}");
      return ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: _searchResults.length,
        separatorBuilder: (context, index) => SizedBox(
          height: getHeight(12),
        ),
        itemBuilder: (context, index) =>
        _searchResults[index]['postType']=='looking'?
        GestureDetector(
          onTap: () {
            Get.to(() => PostDetailsScreen(postData: {
              "name": _searchResults[index]['name'],
              "chatRoomId": _searchResults[index]['chatRoomId'],
              "user_name": _searchResults[index]['user_name'],
              "last known address": _searchResults[index]
              ['last known address'],
              "last cell number": _searchResults[index]
              ['last cell number'],
              "last known school": _searchResults[index]
              ['last known school'],
              "last known employer": _searchResults[index]
              ['last known employer'],
              "last seen": _searchResults[index]['last seen'],
              "identifying characteristics": _searchResults[index]
              ['identifying characteristics'],
              "dv_token": _searchResults[index]['dv_token'],
              'userId': _searchResults[index][
              'userId'], // Replace with the actual user's ID
              'timestamp': _searchResults[index]['timestamp'],
              'postType': 'looking',
              "pic_person": _searchResults[index]['pic_person'],
            }));
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            height: getHeight(150),
            width: getWidth(375),
            decoration: BoxDecoration(
                color: greyFont.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: getHeight(100),
                      width: getWidth(100),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: black),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: _searchResults[index]['pic_person'],
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
                          style: TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: getWidth(15),
                        ),
                        SizedBox(
                            width: getWidth(190),
                            child: Text(
                              _searchResults[index]['name'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Last Seen:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: getWidth(15),
                        ),
                        SizedBox(
                            width: getWidth(170),
                            child: Text(
                              _searchResults[index]['last seen'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Mobile Number:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: getWidth(15),
                        ),
                        SizedBox(
                            width: getWidth(135),
                            child: Text(
                              _searchResults[index]['last cell number'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Last Known Address:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: getWidth(15),
                        ),
                        SizedBox(
                            width: getWidth(100),
                            child: Text(
                              _searchResults[index]['last known address'],
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
        ):_searchResults[index]['postType']=='lost'?GestureDetector(
          onTap: (){
            Get.to(()=>PostDetailsScreen(postData: {
              "name": _searchResults[index]['name'],
              "user_name": _searchResults[index]['user_name'],
              "chatRoomId": _searchResults[index]['chatRoomId'],

              "last known address": _searchResults[index]['last known address'],
              "last cell number": _searchResults[index]['last cell number'],
              "last known school": _searchResults[index]['last known school'],
              "last known employer": _searchResults[index]['last known employer'],
              "identifying characteristics": _searchResults[index]['identifying characteristics'],
              "dv_token": _searchResults[index]['dv_token'],
              'userId': _searchResults[index]['userId'], // Replace with the actual user's ID
              'timestamp': _searchResults[index]['timestamp'],
              'postType': 'lost',
              "pic_person": _searchResults[index]['pic_person'],
            }));
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            height: getHeight(150),
            width: getWidth(375),
            decoration: BoxDecoration(
                color: greyFont.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: getHeight(100),
                      width: getWidth(100),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: black),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: _searchResults[index]['pic_person'],
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
                              _searchResults[index]['name'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Mobile Number:",
                          style:
                          TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: getWidth(15),
                        ),
                        SizedBox(
                            width: getWidth(135),
                            child: Text(
                              _searchResults[index]['last cell number'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "last Known School:",
                          style:
                          TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: getWidth(15),
                        ),
                        SizedBox(
                            width: getWidth(110),
                            child: Text(
                              _searchResults[index]['last known school'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Last Known Address:",
                          style:
                          TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: getWidth(15),
                        ),
                        SizedBox(
                            width: getWidth(100),
                            child: Text(
                              _searchResults[index]['last known address'],
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
        ):GestureDetector(
          onTap: (){
            Get.to(()=>PostDetailsScreen(postData: {
              "name": _searchResults[index]['name'],
              "user_name": _searchResults[index]['user_name'],
              "chatRoomId": _searchResults[index]['chatRoomId'],

              "last known address": _searchResults[index]['last known address'],
              "age": _searchResults[index]['age'],
              "race": _searchResults[index]['race'],
              "hair_color": _searchResults[index]['hair_color'],
              "identifying characteristics": _searchResults[index]['identifying characteristics'],
              "dv_token": _searchResults[index]['dv_token'],
              'userId': _searchResults[index]['userId'], // Replace with the actual user's ID
              'timestamp': _searchResults[index]['timestamp'],
              'postType': 'found',
              "pic_person": _searchResults[index]['pic_person'],
            }));
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            height: getHeight(150),
            width: getWidth(375),
            decoration: BoxDecoration(
                color: greyFont.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: getHeight(100),
                      width: getWidth(100),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: black),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: _searchResults[index]['pic_person'],
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
                              _searchResults[index]['name'],
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
                              _searchResults[index]['age'],
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
                              _searchResults[index]['race'],
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
                              _searchResults[index]['hair_color'],
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
        )
      );
    }
  }

  void onSearchTextChanged(String text) async {
    // Call your method to fetch search results
    List<Map<String, dynamic>> results = await searchPosts(text);

    setState(() {
      _searchResults = results;
    });
  }
}
