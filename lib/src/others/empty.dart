import 'package:benji/src/providers/constants.dart';
import 'package:benji/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

import '../../app/home/home.dart';
import '../components/button/my_elevatedbutton.dart';

class EmptyCard extends StatelessWidget {
  final bool removeButton;
  const EmptyCard({
    super.key,
    this.removeButton = false,
  });

  void _toHomeScreen() => Get.offAll(
        () => const Home(),
        routeName: 'Home',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        popGesture: false,
        predicate: (routes) => false,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Column(
          children: [
            Lottie.asset(
              "assets/animations/empty/frame_1.json",
            ),
            kSizedBox,
            Text(
              "Oops!, There is nothing here",
              style: TextStyle(
                color: kTextGreyColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            kSizedBox,
            removeButton == true
                ? const SizedBox()
                : MyElevatedButton(
                    title: "Start shopping",
                    onPressed: _toHomeScreen,
                  ),
            kSizedBox,
          ],
        ),
      ],
    );
  }
}
