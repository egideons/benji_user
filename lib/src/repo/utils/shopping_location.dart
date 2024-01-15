
import 'dart:convert';

import 'package:benji/main.dart';

String instanceNameShoppingLocation = 'shoppingLocation';


Future<bool> setShoppingLocation(String country, String state, String city) async {
  Map<String, String> area = {'country': country, 'state': state, 'city': city};

  print('area $area');
    return await prefs.setString(instanceNameShoppingLocation, jsonEncode(area));
}

Map<String, dynamic>? getShoppingLocation() {
  String? data = prefs.getString(instanceNameShoppingLocation);
  return data == null ? null : (jsonDecode(data) as Map<String, dynamic>);
}


String? getShoppingLocationPath() {
  String? data = prefs.getString(instanceNameShoppingLocation);
  if (data == null) {
    return null;
  }
  dynamic result = jsonDecode(data);
  
  return "/${result['city']}/${result['state']}/${result['country']}";
}


String getShoppingLocationString() {
  String? data = prefs.getString(instanceNameShoppingLocation);
  if (data == null) {
    return '';
  }
  dynamic result = jsonDecode(data);
  
  return "${result['state']}, ${result['city']}";
}
