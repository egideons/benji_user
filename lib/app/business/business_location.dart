// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui; // Import the ui library with an alias

import 'package:benji/src/repo/utils/network_utils.dart';
import 'package:benji/src/repo/utils/points.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../src/components/appbar/my_appbar.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/keys.dart';
import '../../src/repo/models/vendor/vendor.dart';
import '../../theme/colors.dart';

class BusinessLocation extends StatefulWidget {
  final BusinessModel vendor;
  const BusinessLocation({
    super.key,
    required this.vendor,
  });

  @override
  State<BusinessLocation> createState() => _BusinessLocationState();
}

class _BusinessLocationState extends State<BusinessLocation> {
  //============================================================== INITIAL STATE ====================================================================\\
  @override
  void initState() {
    super.initState();
    // _getPolyPoints();
    _businessLocation = LatLng(double.parse(widget.vendor.latitude),
        double.parse(widget.vendor.longitude));
    _markerTitle = <String>["Me", widget.vendor.shopName];
    _markerSnippet = <String>[
      "My Location",
      "${(widget.vendor.averageRating).toPrecision(1)} Rating"
    ];
    log(widget.vendor.address);
    _loadMapData();
  }

  //============================================================= ALL VARIABLES ======================================================================\\

  //====================================== Setting Google Map Consts =========================================\\

  Position? _userPosition;
  late LatLng _businessLocation;
  final List<LatLng> _polylineCoordinates = [];
  // List<LatLng> _latLng = <LatLng>[_userLocation, _BusinessLocation];
  Uint8List? _markerImage;
  final List<Marker> _markers = <Marker>[];
  final List<MarkerId> _markerId = <MarkerId>[
    const MarkerId("User"),
    const MarkerId("Vendor")
  ];
  List<String>? _markerTitle;
  List<String>? _markerSnippet;
  final List<String> _customMarkers = <String>[
    "assets/icons/person_location.png",
    "assets/icons/store.png",
  ];
  //============================================================= BOOL VALUES ======================================================================\\
  bool _isExpanded = false;

  //========================================================== GlobalKeys ============================================================\\

  //=================================== CONTROLLERS ======================================================\\
  final Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController? _newGoogleMapController;

  //============================================================== FUNCTIONS ===================================================================\\

  //======================================= Google Maps ================================================\\

  /// When the location services are not enabled or permissions are denied the `Future` will return an error.
  Future<void> _loadMapData() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Get.back();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    await _getUserCurrentLocation();
    await _loadCustomMarkers();
    getPolyPoints();
  }

//============================================== Get Current Location ==================================================\\

  Future<Position> _getUserCurrentLocation() async {
    Position userLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then(
      (location) => _userPosition = location,
    );

    LatLng latLngPosition =
        LatLng(userLocation.latitude, userLocation.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 16);

    _newGoogleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );

    return userLocation;
  }

  //====================================== Get bytes from assets =========================================\\

  Future<Uint8List> _getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  //====================================== Get Location Markers =========================================\\

  _loadCustomMarkers() async {
    Position userLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then(
      (location) => _userPosition = location,
    );
    List<LatLng> latLng = <LatLng>[
      LatLng(userLocation.latitude, userLocation.longitude),
      _businessLocation
    ];
    for (int i = 0; i < _customMarkers.length; i++) {
      final Uint8List markerIcon =
          await _getBytesFromAssets(_customMarkers[i], 100);

      _markers.add(
        Marker(
          markerId: _markerId[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
          position: latLng[i],
          infoWindow: InfoWindow(
            title: _markerTitle![i],
            snippet: _markerSnippet![i],
          ),
        ),
      );
      setState(() {});
    }
  }

  //============================================== Adding polypoints ==================================================\\
  void getPolyPoints() async {
    Position userLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then(
      (location) => _userPosition = location,
    );
    if (kIsWeb) {
      String routeStr =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${userLocation.latitude},${userLocation.longitude}&destination=${_businessLocation.latitude},${_businessLocation.longitude}&mode=driving&avoidHighways=false&avoidFerries=true&avoidTolls=false&alternatives=false&key=$googleMapsApiKey';
      String? response = await NetworkUtility.fetchUrl(Uri.parse(routeStr));
      // var resp = await http.get(Uri.parse(routeStr));
      if (response == null) {
        return;
      }
      Map data = jsonDecode(response);
      if (data['routes'].isEmpty) {
        return;
      }

      var overviewPolyline = MyNetworkUtil().decodeEncodedPolyline(
          data['routes'][0]['overview_polyline']['points']);
      if (overviewPolyline.isNotEmpty) {
        for (var point in overviewPolyline) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        setState(() {});
      }
      return;
    }
    PolylinePoints polyLinePoints = PolylinePoints();
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey,
      PointLatLng(userLocation.latitude, userLocation.longitude),
      PointLatLng(_businessLocation.latitude, _businessLocation.longitude),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      setState(() {});
    }
  }

//============================================== Create Google Maps ==================================================\\

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController.complete(controller);
    _newGoogleMapController = controller;
  }

//========================================================== Navigation =============================================================\\
  // void _viewProducts() => Get.off(
  //       () => AllBusinessProducts(vendor: widget.vendor),
  //       routeName: 'AllBusinessProducts',
  //       duration: const Duration(milliseconds: 300),
  //       fullscreenDialog: true,
  //       curve: Curves.easeIn,
  //       preventDuplicates: true,
  //       popGesture: true,
  //       transition: Transition.rightToLeft,
  //     );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: MyAppBar(
        title: "Business location",
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
        actions: const [],
      ),
      body: Stack(
        children: [
          _userPosition == null
              ? Center(
                  child: CircularProgressIndicator(
                    color: kAccentColor,
                  ),
                )
              : GoogleMap(
                  mapType: MapType.normal,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        _userPosition!.latitude, _userPosition!.longitude),
                    zoom: 18,
                  ),
                  markers: Set.of(_markers),
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId("Route to the vendor"),
                      points: _polylineCoordinates,
                      color: kAccentColor,
                      width: 4,
                    ),
                  },
                  padding: EdgeInsets.only(
                    bottom: _isExpanded ? media.height * 0.32 : 90,
                  ),
                  compassEnabled: true,
                  mapToolbarEnabled: true,
                  minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                  tiltGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  fortyFiveDegreeImageryEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  cameraTargetBounds: CameraTargetBounds.unbounded,
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            left: 0,
            right: 0,
            bottom: _isExpanded ? 0 : -140,
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              decoration: ShapeDecoration(
                shadows: [
                  BoxShadow(
                    color: kBlackColor.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                    blurStyle: BlurStyle.normal,
                  ),
                ],
                color: const Color(0xFFFEF8F8),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    width: 0.50,
                    color: Color(0xFFFDEDED),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Text(
                        _isExpanded ? "See less" : "See more",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: kAccentColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: media.width - 200,
                    child: Text(
                      widget.vendor.shopName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: kTextBlackColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  kHalfSizedBox,
                  Container(
                    width: media.width - 90,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.locationDot,
                          color: kAccentColor,
                          size: 15,
                        ),
                        kHalfWidthSizedBox,
                        SizedBox(
                          width: media.width - 120,
                          child: Text(
                            widget.vendor.address,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // kHalfSizedBox,
                  // InkWell(
                  //   onTap: _viewProducts,
                  //   borderRadius: BorderRadius.circular(10),
                  //   child: Container(
                  //     width: media.width / 4,
                  //     padding: const EdgeInsets.all(kDefaultPadding / 4),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       border: Border.all(
                  //         color: kAccentColor,
                  //         width: 1,
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       "Show products",
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontSize: 13,
                  //         fontWeight: FontWeight.w400,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // kHalfSizedBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: media.width * 0.23,
                        height: 57,
                        decoration: ShapeDecoration(
                          color: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidStar,
                              color: kStarColor,
                              size: 17,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${(widget.vendor.averageRating).toPrecision(1)}',
                              style: const TextStyle(
                                color: kBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: media.width * 0.25,
                        height: 57,
                        decoration: ShapeDecoration(
                          color: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.vendor.vendorOwner.isOnline
                                  ? "Online"
                                  : 'Offline',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: widget.vendor.vendorOwner.isOnline
                                    ? kSuccessColor
                                    : kAccentColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.36,
                              ),
                            ),
                            const SizedBox(width: 5),
                            FaIcon(
                              Icons.info,
                              color: kAccentColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          // AnimatedPositioned(
          //   duration: const Duration(milliseconds: 300),
          //   curve: Curves.easeIn,
          //   bottom: _isExpanded ? 180 : 40,
          //   left: media.width / 2.7,
          //   child: Container(
          //     width: 100,
          //     height: 100,
          //     decoration: ShapeDecoration(
          //       color: kPageSkeletonColor,
          //       image: DecorationImage(
          //         image: NetworkImage(
          //           widget.vendor.vendorOwner.profileLogo,
          //         ),
          //         fit: BoxFit.cover,
          //       ),
          //       shape: const OvalBorder(),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
