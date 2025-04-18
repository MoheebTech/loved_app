import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loved_app/utils/images.dart';
import 'package:loved_app/utils/singleton.dart';
import 'package:loved_app/utils/size_config.dart';
import 'package:loved_app/utils/text_styles.dart';
import 'package:loved_app/view/post_details_screen.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../widgets/progress_bar.dart';
import 'colors.dart';
import 'package:intl/intl.dart';

class SyncfusionMap extends StatefulWidget {
  // String? subcatID;

  final List<dynamic> gunPins;
  const SyncfusionMap({super.key, required this.gunPins});

  @override
  State<SyncfusionMap> createState() => _SyncfusionMapState();
}

class _SyncfusionMapState extends State<SyncfusionMap> {
  late PageController _pageViewController;
  late MapTileLayerController _mapController;

  late MapZoomPanBehavior _zoomPanBehavior;

  // late List<_WonderDetails> _worldWonders;

  late int _currentSelectedIndex;
  late int _previousSelectedIndex;
  late int _tappedMarkerIndex;

  late double _cardHeight;

  late bool _canUpdateFocalLatLng;
  late bool _canUpdateZoomLevel;
  bool _isDesktop = false;

  @override
  void initState() {
    super.initState();
    _currentSelectedIndex = 0;
    _canUpdateFocalLatLng = true;
    _canUpdateZoomLevel = true;
    _mapController = MapTileLayerController();
    _zoomPanBehavior = MapZoomPanBehavior(
      minZoomLevel: 3,
      maxZoomLevel: 18,
      focalLatLng: MapLatLng(
        double.parse(SingleToneValue.instance.currentLat.toString()),
        double.parse(SingleToneValue.instance.currentLng.toString()),
      ),
      enableDoubleTapZooming: true,
    );
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _mapController.dispose();
    // _worldWonders.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_canUpdateZoomLevel) {
      _zoomPanBehavior.zoomLevel = _isDesktop ? 5 : 16;
      _canUpdateZoomLevel = false;
    }
    _cardHeight = (MediaQuery.of(context).orientation == Orientation.landscape)
        ? (_isDesktop ? 120 : 90)
        : 250;
    _pageViewController = PageController(
        initialPage: _currentSelectedIndex,
        viewportFraction:
            (MediaQuery.of(context).orientation == Orientation.landscape)
                ? (_isDesktop ? 0.5 : 0.7)
                : 0.95);

    Get.log("Date ${DateTime.now()}");

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back,
              color: black,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SfMaps(
            layers: <MapLayer>[
              MapTileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                zoomPanBehavior: _zoomPanBehavior,
                controller: _mapController,
                initialMarkersCount: widget.gunPins.length,
                tooltipSettings: const MapTooltipSettings(
                  color: Colors.transparent,
                ),
                markerBuilder: (BuildContext context, int index) {
                  final double markerSize =
                      _currentSelectedIndex == index ? 80 : 40;
                  return MapMarker(
                    latitude:
                        double.parse(widget.gunPins[index]['lat'].toString()),
                    longitude:
                        double.parse(widget.gunPins[index]['lng'].toString()),
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        if (_currentSelectedIndex != index) {
                          _canUpdateFocalLatLng = false;
                          _tappedMarkerIndex = index;
                          _pageViewController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: markerSize,
                        width: markerSize,
                        child: const Icon(Icons.pin_drop_sharp,
                            color: red, size: 25),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: _cardHeight,
              // width: 470,
              padding: const EdgeInsets.only(bottom: 10, top: 40),
              decoration:  BoxDecoration(
                  gradient: LinearGradient(
                    stops: const [0.1, 1.0],
                    colors: [primaryColor.withOpacity(0.6), blue],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(36),
                      topLeft: Radius.circular(36))),

              /// PageView which shows the world wonder details at the bottom.
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: widget.gunPins.length,
                onPageChanged: _handlePageChange,
                controller: _pageViewController,
                itemBuilder: (BuildContext context, int index) {
                  // final _WonderDetails item = _worldWonders[index];
                  return Transform.scale(
                    // scaleY:index==_currentSelectedIndex ? 1 : 0.85 ,
                    scale: index == _currentSelectedIndex ? 1 : 0.85,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                Get.log("on click");
                                Get.to(
                                    () => PostDetailsScreen(
                                          postData: widget.gunPins[index]
                                                      ['postType'] ==
                                                  'looking'
                                              ? {
                                                  "name": widget.gunPins[index]
                                                      ['name'],
                                                  "user_name":
                                                      widget.gunPins[index]
                                                          ['user_name'],

                                                  "chatRoomId":
                                                      widget.gunPins[index]
                                                          ['chatRoomId'],
                                                  "last known address": widget
                                                          .gunPins[index]
                                                      ['last known address'],
                                                  "last cell number":
                                                      widget.gunPins[index]
                                                          ['last cell number'],
                                                  "last known school":
                                                      widget.gunPins[index]
                                                          ['last known school'],
                                                  "last known employer": widget
                                                          .gunPins[index]
                                                      ['last known employer'],
                                                  "last seen":
                                                      widget.gunPins[index]
                                                          ['last seen'],
                                                  "identifying characteristics":
                                                      widget.gunPins[index][
                                                          'identifying characteristics'],
                                                  "dv_token":
                                                      widget.gunPins[index]
                                                          ['dv_token'],
                                                  'userId': widget
                                                          .gunPins[index][
                                                      'userId'], // Replace with the actual user's ID
                                                  'timestamp':
                                                      widget.gunPins[index]
                                                          ['timestamp'],
                                                  'postType': 'looking',
                                                  "pic_person":
                                                      widget.gunPins[index]
                                                          ['pic_person'],
                                                }
                                              : widget.gunPins[index]
                                                          ['postType'] ==
                                                      'lost'
                                                  ? {
                                                      "name":
                                                          widget.gunPins[index]
                                                              ['name'],
                                                      "chatRoomId":
                                                          widget.gunPins[index]
                                                              ['chatRoomId'],
                                                      "user_name":
                                                          widget.gunPins[index]
                                                              ['user_name'],

                                                      "last known address": widget
                                                              .gunPins[index][
                                                          'last known address'],
                                                      "last cell number": widget
                                                              .gunPins[index]
                                                          ['last cell number'],
                                                      "last known school": widget
                                                              .gunPins[index]
                                                          ['last known school'],
                                                      "last known employer": widget
                                                              .gunPins[index][
                                                          'last known employer'],
                                                      "identifying characteristics":
                                                          widget.gunPins[index][
                                                              'identifying characteristics'],
                                                      "dv_token":
                                                          widget.gunPins[index]
                                                              ['dv_token'],
                                                      'userId': widget
                                                              .gunPins[index][
                                                          'userId'], // Replace with the actual user's ID
                                                      'timestamp':
                                                          widget.gunPins[index]
                                                              ['timestamp'],
                                                      'postType': 'lost',
                                                      "pic_person":
                                                          widget.gunPins[index]
                                                              ['pic_person'],
                                                    }
                                                  : {
                                                      "name":
                                                          widget.gunPins[index]
                                                              ['name'],
                                                      "chatRoomId":
                                                          widget.gunPins[index]
                                                              ['chatRoomId'],
                                                      "user_name":
                                                          widget.gunPins[index]
                                                              ['user_name'],

                                                      "last known address": widget
                                                              .gunPins[index][
                                                          'last known address'],
                                                      "age":
                                                          widget.gunPins[index]
                                                              ['age'],
                                                      "race":
                                                          widget.gunPins[index]
                                                              ['race'],
                                                      "hair_color":
                                                          widget.gunPins[index]
                                                              ['hair_color'],
                                                      "identifying characteristics":
                                                          widget.gunPins[index][
                                                              'identifying characteristics'],
                                                      "dv_token":
                                                          widget.gunPins[index]
                                                              ['dv_token'],
                                                      'userId': widget
                                                              .gunPins[index][
                                                          'userId'], // Replace with the actual user's ID
                                                      'timestamp':
                                                          widget.gunPins[index]
                                                              ['timestamp'],
                                                      'postType': 'found',
                                                      "pic_person":
                                                          widget.gunPins[index]
                                                              ['pic_person'],
                                                    },
                                        ),
                                    transition: Transition.noTransition);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                height: getHeight(150),
                                width: getWidth(375),
                                decoration: BoxDecoration(
                                    // color: greyFont.withOpacity(0.1),
                                    color: white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: getHeight(100),
                                          width: getWidth(100),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: black),
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: widget.gunPins[index]
                                                  ['pic_person'],
                                              placeholder: (context, url) =>
                                                  ProgressBar(),
                                              errorWidget:
                                                  (context, url, error) =>
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Post Type:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: getWidth(15),
                                            ),
                                            SizedBox(
                                                width: getWidth(100),
                                                child: Text(
                                                  widget.gunPins[index]
                                                          ['postType']
                                                      .toString()
                                                      .capitalizeFirst
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  softWrap: true,
                                                )),
                                          ],
                                        ),
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
                                                width: getWidth(150),
                                                child: Text(
                                                  widget.gunPins[index]['name'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Time Posted:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: getWidth(15),
                                            ),
                                            SizedBox(
                                                width: getWidth(120),
                                                child: Text(
                                                  DateFormat('yyyy-MM-dd').format(
                                                    (widget.gunPins[index]['timestamp'] as Timestamp).toDate(),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                )
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: (20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePageChange(int index) {
    /// While updating the page viewer through interaction, selected position's
    /// marker should be moved to the center of the maps. However, when the
    /// marker is directly clicked, only the respective card should be moved to
    /// center and the marker itself should not move to the center of the maps.
    if (!_canUpdateFocalLatLng) {
      if (_tappedMarkerIndex == index) {
        _updateSelectedCard(index);
      }
    } else if (_canUpdateFocalLatLng) {
      _updateSelectedCard(index);
    }
  }

  void _updateSelectedCard(int index) {
    setState(() {
      _previousSelectedIndex = _currentSelectedIndex;
      _currentSelectedIndex = index;
    });

    /// While updating the page viewer through interaction, selected position's
    /// marker should be moved to the center of the maps. However, when the
    /// marker is directly clicked, only the respective card should be moved to
    /// center and the marker itself should not move to the center of the maps.
    if (_canUpdateFocalLatLng) {
      _zoomPanBehavior.focalLatLng = MapLatLng(
        double.parse(widget.gunPins[index]['lat'].toString()),
        double.parse(widget.gunPins[index]['lng'].toString()),
      );
    }

    /// Updating the design of the selected marker. Please check the
    /// `markerBuilder` section in the build method to know how this is done.
    _mapController
        .updateMarkers(<int>[_currentSelectedIndex, _previousSelectedIndex]);
    _canUpdateFocalLatLng = true;
  }
}
