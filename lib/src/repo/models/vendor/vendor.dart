import 'dart:convert';

import 'package:benji/src/repo/models/shop_type.dart';
import 'package:benji/src/repo/services/api_url.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class BusinessModel {
  final String id;
  final VendorOwner vendorOwner;
  final String state;
  final String city;
  final String satOpeningHours;
  final String satClosingHours;
  final String sunWeekOpeningHours;
  final String sunWeekClosingHours;
  final String monOpeningHours;
  final String monClosingHours;
  final String tueOpeningHours;
  final String tueClosingHours;
  final String wedOpeningHours;
  final String wedClosingHours;
  final String thursOpeningHours;
  final String thursClosingHours;
  final String friOpeningHours;
  final String friClosingHours;
  final String address;
  final String shopName;
  final ShopTypeModel shopType;
  final String shopImage;
  final String coverImage;
  final String longitude;
  final String latitude;
  final String businessId;
  final String businessBio;
  final String accountName;
  final String accountNumber;
  final String accountType;
  final String accountBank;
  final double averageRating;
  final int numberOfClientsReactions;
  final bool isOnline;

  BusinessModel({
    required this.id,
    required this.vendorOwner,
    required this.state,
    required this.city,
    required this.monOpeningHours,
    required this.monClosingHours,
    required this.tueOpeningHours,
    required this.tueClosingHours,
    required this.wedOpeningHours,
    required this.wedClosingHours,
    required this.thursOpeningHours,
    required this.thursClosingHours,
    required this.friOpeningHours,
    required this.friClosingHours,
    required this.satOpeningHours,
    required this.satClosingHours,
    required this.sunWeekOpeningHours,
    required this.sunWeekClosingHours,
    required this.address,
    required this.shopName,
    required this.shopType,
    required this.shopImage,
    required this.coverImage,
    required this.longitude,
    required this.latitude,
    required this.businessId,
    required this.businessBio,
    required this.accountName,
    required this.accountNumber,
    required this.accountType,
    required this.accountBank,
    required this.averageRating,
    required this.numberOfClientsReactions,
    required this.isOnline,
  });

  factory BusinessModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return BusinessModel(
      id: json['id'] ?? '',
      vendorOwner: VendorOwner.fromJson(json['vendor_owner']),
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      monOpeningHours: json["monOpeningHours"] ?? notAvailable,
      monClosingHours: json["monClosingHours"] ?? notAvailable,
      tueOpeningHours: json["tueOpeningHours"] ?? notAvailable,
      tueClosingHours: json["tueClosingHours"] ?? notAvailable,
      wedOpeningHours: json["wedOpeningHours"] ?? notAvailable,
      wedClosingHours: json["wedClosingHours"] ?? notAvailable,
      thursOpeningHours: json["thursOpeningHours"] ?? notAvailable,
      thursClosingHours: json["thursClosingHours"] ?? notAvailable,
      friOpeningHours: json["friOpeningHours"] ?? notAvailable,
      friClosingHours: json["friClosingHours"] ?? notAvailable,
      satOpeningHours: json["satOpeningHours"] ?? notAvailable,
      satClosingHours: json["satClosingHours"] ?? notAvailable,
      sunWeekOpeningHours: json["sunWeekOpeningHours"] ?? notAvailable,
      sunWeekClosingHours: json["sunWeekClosingHours"] ?? notAvailable,
      address: json['address'] ?? '',
      shopName: json['shop_name'] ?? '',
      coverImage: json['coverImage'] ?? '',
      shopType: ShopTypeModel.fromJson(json['shop_type']),
      shopImage: json['shop_image'] ??
          'https://img.freepik.com/free-psd/3d-icon-social-media-app_23-2150049569.jpg',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      businessId: json['businessId'] ?? '',
      businessBio: json['businessBio'] ?? '',
      accountName: json['accountName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      accountType: json['accountType'] ?? '',
      accountBank: json['accountBank'] ?? '',
      averageRating: (json['average_rating'] ?? 0).toDouble() ?? 0.0,
      numberOfClientsReactions: json['number_of_clients_reactions'] ?? 0,
      isOnline: json["is_online"] ?? false,
    );
  }
}

class VendorOwner {
  final int id;
  final String email;
  final String phone;
  final String username;
  final String code;
  final String firstName;
  final String lastName;
  final String gender;
  final String address;
  final String longitude;
  final String latitude;
  final bool isOnline;

  final String profileLogo;

  VendorOwner({
    required this.id,
    required this.email,
    required this.phone,
    required this.username,
    required this.code,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.isOnline,
    required this.profileLogo,
  });

  factory VendorOwner.fromJson(Map<String, dynamic>? json) {
    json ??= {};

    return VendorOwner(
      id: json['id'] ?? 0,
      email: json['email'] ?? notAvailable,
      phone: json['phone'] ?? notAvailable,
      username: json['username'] ?? notAvailable,
      code: json['code'] ?? notAvailable,
      firstName: json['first_name'] ?? notAvailable,
      lastName: json['last_name'] ?? notAvailable,
      gender: json['gender'] ?? notAvailable,
      address: json['address'] ?? notAvailable,
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      isOnline: json['is_online'] ?? true,
      profileLogo: json['profileLogo'] ??
          'https://img.freepik.com/free-psd/3d-icon-social-media-app_23-2150049569.jpg',
    );
  }
}

Future<BusinessModel> getVendorById(id) async {
  final response = await http.get(
    Uri.parse('$baseURL/vendors/$id/getMybusinessInfo'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return BusinessModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load vendor');
  }
}

Future<List<BusinessModel>> getPopularBusinesses({start = 0, end = 4}) async {
  final response = await http.get(
    Uri.parse('$baseURL/clients/getPopularBusinesses?start=$start&end=$end'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body)['items'] as List)
        .map((item) => BusinessModel.fromJson(item))
        .toList();
  } else {
    return [];
  }
}

Future<List<BusinessModel>> getVendors({start = 0, end = 5}) async {
  final response = await http.get(
    Uri.parse('$baseURL/vendors/getAllVendor?start=$start&end=$end'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body)['items'] as List)
        .map((item) => BusinessModel.fromJson(item))
        .toList();
  } else {
    return [];
  }
}
