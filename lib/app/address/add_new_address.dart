// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, invalid_use_of_protected_member

import 'package:benji/src/components/others/location_list_tile.dart';
import 'package:benji/src/components/textformfield/my_maps_textformfield.dart';
import 'package:benji/src/providers/keys.dart';
import 'package:benji/src/repo/controller/lat_lng_controllers.dart';
import 'package:benji/src/repo/models/googleMaps/autocomplete_prediction.dart';
import 'package:benji/src/repo/services/api_url.dart';
import 'package:benji/src/repo/utils/helpers.dart';
import 'package:benji/src/repo/utils/network_utils.dart';
import 'package:benji/src/repo/utils/web_map.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../src/components/appbar/my_appbar.dart';
import '../../src/components/button/my_elevatedbutton.dart';
import '../../src/components/button/my_outlined_elevatedbutton.dart';
import '../../src/components/snackbar/my_floating_snackbar.dart';
import '../../src/components/textformfield/my textformfield.dart';
import '../../src/components/textformfield/my_phone_field.dart';
import '../../src/providers/constants.dart';
import '../../src/repo/models/googleMaps/places_autocomplete_response.dart';
import '../../src/repo/models/user/user_model.dart';
import '../../theme/colors.dart';
import 'get_location_on_map.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({
    super.key,
  });

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  @override
  void initState() {
    super.initState();
    checkAuth(context);
    checkIfShoppingLocation(context);

    getUser().then((user) => _phoneNumberEC.text =
        (user?.phone ?? '').replaceFirst('+$countryDialCode', ''));
  }

  @override
  void dispose() {
    selectedLocation.dispose();

    super.dispose();
  }

  //===================== KEYS =======================\\
  final _formKey = GlobalKey<FormState>();
  // final _cscPickerKey = GlobalKey<CSCPickerState>();

  //===================== CONTROLLERS =======================\\
  final _scrollController = ScrollController();
  final TextEditingController _addressTitleEC = TextEditingController();
  final TextEditingController _phoneNumberEC = TextEditingController();
  final TextEditingController _mapsLocationEC = TextEditingController();
  final LatLngDetailController latLngDetailController =
      Get.put(LatLngDetailController());

  //===================== FOCUS NODES =======================\\
  final FocusNode _addressTitleFN = FocusNode();
  final FocusNode _phoneNumberFN = FocusNode();
  final FocusNode _mapsLocationFN = FocusNode();

  //===================== ALL VARIABLES =======================\\
  String? latitude;
  String? longitude;
  String countryDialCode = '234';
  List<AutocompletePrediction> placePredictions = [];
  final selectedLocation = ValueNotifier<String?>(null);

  //===================== BOOL VALUES =======================\\
  bool _isLoading = false;
  bool _isLoading2 = false;
  bool _typing = false;
  //===================== FUNCTIONS =======================\\
  Future _setLocation(index) async {
    final newLocation = placePredictions[index].description!;
    selectedLocation.value = newLocation;

    setState(() {
      _mapsLocationEC.text = newLocation;
    });

    List location = await parseLatLng(newLocation);
    latitude = location[0];
    longitude = location[1];
  }

  Future<bool> addAddress({bool is_current = true}) async {
    final url = Uri.parse('$baseURL/address/addAddress');
    final User? user = await getUser();

    if (latitude == null || longitude == null) {
      if (selectedLocation.value == null) {
        return false;
      }
      List<Location> location =
          await locationFromAddress(selectedLocation.value!);
      latitude = location[0].latitude.toString();
      longitude = location[0].longitude.toString();
    }

    final body = {
      'user_id': user!.id.toString(),
      'title': _addressTitleEC.text,
      'phone': "+$countryDialCode${_phoneNumberEC.text}",
      'details': _mapsLocationEC.text,
      'latitude': latitude,
      'longitude': longitude,
      'is_current': is_current.toString(),
    };
    if (kDebugMode) {
      print("This is the body: $body");
    }
    final response =
        await http.post(url, body: body, headers: await authHeader());
    return response.statusCode == 200;
  }

  //SET DEFAULT ADDRESS
  setDefaultAddress() async {
    setState(() {
      _isLoading = true;
    });

    if (await addAddress(is_current: true)) {
      mySnackBar(
        context,
        kSuccessColor,
        "Success!",
        "Set As Default Address",
        const Duration(seconds: 2),
      );
      Get.back();

      setState(() {
        _isLoading = false;
      });
    } else {
      mySnackBar(
        context,
        kErrorColor,
        "Failed!",
        "Failed to Set as Default Address",
        const Duration(seconds: 2),
      );
      Get.back();

      setState(() {
        _isLoading = false;
      });
    }
  }

  //SAVE NEW ADDRESS
  saveNewAddress() async {
    setState(() {
      _isLoading2 = true;
    });

    if (await addAddress(is_current: false)) {
      mySnackBar(
        context,
        kSuccessColor,
        "Success!",
        "Added Address",
        const Duration(seconds: 2),
      );
      Get.back();

      setState(() {
        _isLoading2 = false;
      });
    } else {
      mySnackBar(
        context,
        kErrorColor,
        "Failed!",
        "Failed to Add Address",
        const Duration(seconds: 2),
      );
      Get.back();

      setState(() {
        _isLoading2 = false;
      });
    }
  }

  void placeAutoComplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        '/maps/api/place/autocomplete/json', //unencoder path
        {
          "input": query, //query params
          "key": googlePlacesApiKey //google places api key
        });

    String? response = await NetworkUtility.fetchUrl(uri);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutoCompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  //===================== Navigation =======================\\

  void _toGetLocationOnMap() async {
    await Get.to(
      () => const GetLocationOnMap(),
      routeName: 'GetLocationOnMap',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
    latitude = latLngDetailController.latLngDetail.value[0];
    longitude = latLngDetailController.latLngDetail.value[1];
    _mapsLocationEC.text = latLngDetailController.latLngDetail.value[2];
    latLngDetailController.setEmpty();
    if (kDebugMode) {
      print("LATLNG: $latitude,$longitude");
      print(_mapsLocationEC.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          elevation: 0.0,
          title: "New Address ",
          backgroundColor: kPrimaryColor,
          actions: const [],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            controller: _scrollController,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(kDefaultPadding),
              children: [
                Form(
                  key: _formKey,
                  child: ValueListenableBuilder(
                      valueListenable: selectedLocation,
                      builder: (context, selectedLocationValue, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Title (My Home, My Office)',
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                kHalfSizedBox,
                                MyTextFormField(
                                  hintText:
                                      "Enter address name tag e.g my work, my home....",
                                  textCapitalization: TextCapitalization.words,
                                  controller: _addressTitleEC,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.name,
                                  focusNode: _addressTitleFN,
                                  validator: (value) {
                                    RegExp locationNamePattern =
                                        RegExp(r'^.{3,}$');
                                    if (value == null || value == "") {
                                      _addressTitleFN.requestFocus();
                                      return "Enter a title";
                                    } else if (!locationNamePattern
                                        .hasMatch(value)) {
                                      _addressTitleFN.requestFocus();
                                      return "Please enter a valid name";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _addressTitleEC.text = value!;
                                  },
                                ),
                                kHalfSizedBox,
                                const Text(
                                  'Name tag of this address e.g my work, my apartment',
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            kSizedBox,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Phone Number',
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                kHalfSizedBox,
                                MyPhoneField(
                                  onCountryChanged: (country) {
                                    countryDialCode = country.dialCode;
                                  },
                                  initialCountryCode: "NG",
                                  invalidNumberMessage: "Invalid phone number",
                                  dropdownIconPosition: IconPosition.trailing,
                                  showCountryFlag: true,
                                  showDropdownIcon: true,
                                  dropdownIcon: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: kAccentColor,
                                  ),
                                  controller: _phoneNumberEC,
                                  textInputAction: TextInputAction.next,
                                  focusNode: _phoneNumberFN,
                                  validator: (value) {
                                    if (_phoneNumberEC.text.isNotEmpty) {
                                      return null;
                                    }
                                    if (value == null || value == "") {
                                      _phoneNumberFN.requestFocus();
                                      return "Enter your phone number";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _phoneNumberEC.text = value!;
                                  },
                                ),
                              ],
                            ),
                            kSizedBox,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Your Location',
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                kHalfSizedBox,
                                MyMapsTextFormField(
                                  // readOnly: true,
                                  controller: _mapsLocationEC,
                                  validator: (value) {
                                    if (value == null || value == "") {
                                      _mapsLocationFN.requestFocus();
                                      return "Enter a location";
                                    }
                                    if (latitude == null || longitude == null) {
                                      _mapsLocationFN.requestFocus();
                                      return "Please select a location so we can get the coordinates";
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    placeAutoComplete(value);
                                    setState(() {
                                      selectedLocation.value = value;
                                      _typing = true;
                                    });
                                    if (kDebugMode) {
                                      print(
                                          "ONCHANGED VALUE: ${selectedLocation.value}");
                                    }
                                  },
                                  textInputAction: TextInputAction.done,
                                  focusNode: _mapsLocationFN,
                                  hintText: "Search a location",
                                  textInputType: TextInputType.text,
                                  prefixIcon: Padding(
                                    padding:
                                        const EdgeInsets.all(kDefaultPadding),
                                    child: FaIcon(
                                      FontAwesomeIcons.locationDot,
                                      color: kAccentColor,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                kSizedBox,
                                Divider(
                                  height: 10,
                                  thickness: 2,
                                  color: kLightGreyColor,
                                ),
                                ElevatedButton.icon(
                                  onPressed: _toGetLocationOnMap,
                                  icon: FaIcon(
                                    FontAwesomeIcons.locationArrow,
                                    color: kAccentColor,
                                    size: 18,
                                  ),
                                  label: const Text("Locate on map"),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: kLightGreyColor,
                                    foregroundColor: kTextBlackColor,
                                    fixedSize: Size(media.width, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 10,
                                  thickness: 2,
                                  color: kLightGreyColor,
                                ),
                                const Text(
                                  "Suggestions:",
                                  style: TextStyle(
                                    color: kTextBlackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                kHalfSizedBox,
                                SizedBox(
                                  height: () {
                                    if (_typing == false) {
                                      return 0.0;
                                    }
                                    if (_typing == true) {
                                      return 150.0;
                                    }
                                  }(),
                                  child: Scrollbar(
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      controller: _scrollController,
                                      shrinkWrap: true,
                                      itemCount: placePredictions.length,
                                      itemBuilder: (context, index) =>
                                          LocationListTile(
                                        onTap: () async =>
                                            await _setLocation(index),
                                        location: placePredictions[index]
                                            .description!,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                ),
                kSizedBox,
                MyOutlinedElevatedButton(
                  isLoading: _isLoading,
                  title: "Set As Default Address",
                  onPressed: (() async {
                    if (_formKey.currentState!.validate()) {
                      setDefaultAddress();
                    }
                  }),
                ),
                kSizedBox,
                MyElevatedButton(
                  isLoading: _isLoading2,
                  title: "Save New Address",
                  onPressed: (() async {
                    if (_formKey.currentState!.validate()) {
                      saveNewAddress();
                    }
                  }),
                ),
                const SizedBox(height: kDefaultPadding * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
