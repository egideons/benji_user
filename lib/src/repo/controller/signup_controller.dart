// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:benji/app/splash_screens/login_splash_screen.dart';
import 'package:benji/src/repo/controller/error_controller.dart';
import 'package:benji/src/repo/controller/user_controller.dart';
import 'package:benji/src/repo/services/api_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignupController extends GetxController {
  static SignupController get instance {
    return Get.find<SignupController>();
  }

  var isLoad = false.obs;

  Future<void> signup(String email, String password, String phone,
      String firstName, String lastName) async {
    UserController.instance;
    isLoad.value = true;
    update();

    try {
      final body = {
        'email': email,
        'password': password,
        'phone': phone,
        'username': email.split('@')[0],
        'first_name': firstName,
        'last_name': lastName
      };

      await http.post(Uri.parse('$baseURL/clients/createClient'), body: body);

      Map finalData = {
        "username": email,
        "password": password,
      };

      http.Response? response =
          await HandleData.postApi(Api.baseUrl + Api.login, null, finalData);

      var jsonData = jsonDecode(response?.body ?? '');

      if (jsonData["token"] == false) {
        ApiProcessorController.errorSnack(
            "Invalid email or password. Try again");
        isLoad.value = false;
        update();
        return;
      }
      http.Response? responseUser =
          await HandleData.getApi(Api.baseUrl + Api.user, jsonData["token"]);

      http.Response? responseUserData = await HandleData.getApi(
          Api.baseUrl +
              Api.getClient +
              jsonDecode(responseUser?.body ?? '')['id'].toString(),
          jsonData["token"]);

      if (responseUserData == null) {
        throw const SocketException('Please connect to the internet');
      }

      UserController.instance
          .saveUser(responseUserData.body, jsonData["token"]);

      ApiProcessorController.successSnack("Signup Successful");
      isLoad.value = false;
      update();
      Get.offAll(
        () => const LoginSplashScreen(),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "LoginSplashScreen",
        predicate: (route) => false,
        popGesture: true,
        transition: Transition.cupertinoDialog,
      );
    } catch (e) {
      ApiProcessorController.errorSnack("Please connect to the internet");
      isLoad.value = false;
      update();
    }
  }
}