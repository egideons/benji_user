import 'package:benji/src/repo/utils/user_cart.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../app/cart/cart_screen.dart';
import '../../theme/colors.dart';
import '../providers/responsive_constant.dart';

class CartCard extends StatefulWidget {
  final String? cartCount;
  const CartCard({super.key, this.cartCount});

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  void initState() {
    super.initState();
  }

  Future<String> countCartFunc() async {
    String data = await countCartItemTo10();
    if (widget.cartCount == null) {
      return data;
    } else {
      return widget.cartCount!;
    }
  }

  void _toCartScreen() async {
    await Get.to(
      () => const CartScreen(),
      routeName: 'CartScreen',
      duration: const Duration(milliseconds: 1000),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.cupertinoDialog,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: _toCartScreen,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: _toCartScreen,
              splashRadius: 20,
              icon: Icon(
                Icons.shopping_cart_outlined,
                size: deviceType(mediaWidth) > 2 ? 36 : 28,
                color: kAccentColor,
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              height: deviceType(mediaWidth) > 2 ? 22 : 20,
              width: deviceType(mediaWidth) > 2 ? 22 : 20,
              decoration: ShapeDecoration(
                color: kAccentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Center(
                child: FutureBuilder(
                    future: countCartFunc(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('');
                      }
                      return Text(
                        snapshot.data!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: deviceType(mediaWidth) > 2 ? 12 : 9,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
