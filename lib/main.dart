import 'package:benji/app/splash_screens/startup_splash_screen.dart';
import 'package:benji/src/repo/controller/address_controller.dart';
import 'package:benji/src/repo/controller/auth_controller.dart';
import 'package:benji/src/repo/controller/category_controller.dart';
import 'package:benji/src/repo/controller/error_controller.dart';
import 'package:benji/src/repo/controller/form_controller.dart';
import 'package:benji/src/repo/controller/login_controller.dart';
import 'package:benji/src/repo/controller/order_controller.dart';
import 'package:benji/src/repo/controller/product_controller.dart';
import 'package:benji/src/repo/controller/profile_controller.dart';
import 'package:benji/src/repo/controller/sub_category_controller.dart';
import 'package:benji/src/repo/controller/url_launch_controller.dart';
import 'package:benji/src/repo/controller/user_controller.dart';
import 'package:benji/src/repo/controller/vendor_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/providers/fcm_messaging.dart';
import 'src/repo/controller/lat_lng_controllers.dart';
import 'theme/app_theme.dart';
import 'theme/colors.dart';

late SharedPreferences prefs;

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: kTransparentColor),
  );
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();

  final user = Get.put(UserController());
  final auth = Get.put(AuthController());
  final userProfile = Get.put(ProfileController());
  final login = Get.put(LoginController());
  final vendor = Get.put(VendorController());
  final order = Get.put(OrderController());
  final category = Get.put(CategoryController());
  final subCategory = Get.put(SubCategoryController());
  final location = Get.put(LatLngDetailController());
  final product = Get.put(ProductController());
  final url = Get.put(UrlLaunchController());
  final form = Get.put(FormController());
  final apiProcessor = Get.put(ApiProcessorController());
  final address = Get.put(AddressController());
  // final review = Get.put(ReviewsController());

  if (!kIsWeb) {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await NotificationController.initializeNotification();

    await handleFCM();
  }

  // await dotenv.load();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Benji",
      color: kPrimaryColor,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      //This is the home route
      home: WillPopScope(
        onWillPop: () => _showExitConfirmationDialog(context),
        child: const StartupSplashscreen(),
      ),
      // initialRoute: AppRoutes.startupSplashscreen,
      // getPages: AppRoutes.routes,
    );
  }
}

_showExitConfirmationDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Exit App?'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Don't exit
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Exit
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
