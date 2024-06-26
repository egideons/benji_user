// ignore_for_file: camel_case_types

import 'package:benji/src/repo/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../src/components/button/my_elevatedbutton.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';
import '../orders/order_history.dart';

class PaymentSuccessful extends StatelessWidget {
  const PaymentSuccessful({super.key});

  void _toOrdersScreen() => Get.to(
        () => const OrdersHistory(),
        routeName: 'OrdersHistory',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
  void _toMyCart() {
    Get.close(4);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: GetBuilder<CartController>(builder: (controller) {
          return MyElevatedButton(
            title: "Done",
            onPressed:
                controller.cartProducts.isEmpty ? _toOrdersScreen : _toMyCart,
          );
        }),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Container(
          margin: const EdgeInsets.only(
            top: kDefaultPadding,
            left: kDefaultPadding,
            right: kDefaultPadding,
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/animations/payment/frame_1.json",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    width: media.width - 100,
                  ),
                  kSizedBox,
                  Text(
                    "Payment Successful",
                    style: TextStyle(
                      color: kTextGreyColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  kSizedBox,
                  Text(
                    "The vendor has received your order\nand a rider will be dispatched to deliver it soon.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kTextGreyColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
