import 'package:benji/src/components/image/my_image.dart';
import 'package:benji/src/frontend/utils/navigate.dart';
import 'package:benji/src/repo/models/product/product.dart';
import 'package:benji/src/repo/utils/user_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../theme/colors.dart';
import '../../../providers/constants.dart';
import '../../utils/constant.dart';
import '../clickable.dart';

class MyCardLg extends StatefulWidget {
  final Product product;
  final Widget? navigate;
  final Function()? close;
  final Widget? navigateCategory;

  const MyCardLg({
    super.key,
    required this.product,
    this.close,
    this.navigate,
    this.navigateCategory,
  });

  @override
  State<MyCardLg> createState() => _MyCardLgState();
}

class _MyCardLgState extends State<MyCardLg> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> cartRemoveFunction() async {
    await removeFromCart(widget.product);
  }

  Future<bool> cartCount() async {
    int count = countCartItemByProduct(widget.product);
    return count > 0;
  }

  double blurRadius = 2;
  double margin = 15;
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kTransparentColor,
      body: MouseRegion(
        child: Visibility(
          child: GestureDetector(
            onTap: widget.close,
            child: Container(
              alignment: Alignment.center,
              color: Colors.black.withOpacity(0.4),
              child: Stack(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 800,
                      maxHeight: breakPoint(media.width, 620, 400, 400),
                    ),
                    margin: EdgeInsets.all(margin),
                    padding: EdgeInsets.symmetric(
                        vertical: breakPoint(media.width, 25, 50, 50),
                        horizontal: breakPoint(media.width, 25, 50, 50)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border: const Border.fromBorderSide(
                        BorderSide(
                          width: 1,
                          color: Colors.black12,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 1,
                          blurRadius: blurRadius,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: LayoutGrid(
                      columnSizes: breakPointDynamic(
                          media.width, [1.fr], [1.fr, 1.fr], [1.fr, 1.fr]),
                      rowSizes: breakPointDynamic(
                          media.width, [1.fr, 1.fr], [auto], [auto]),
                      children: [
                        MyClickable(
                          navigate: widget.navigate,
                          child: Container(
                            decoration: BoxDecoration(
                              color: kPageSkeletonColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: MyImage(
                                url: widget.product.productImage,
                                width: null,
                                height: null,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: breakPoint(media.width, 0, 25, 25),
                            top: breakPoint(media.width, 25, 0, 0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: Image.asset(
                                      'assets/frontend/assets/product_asset/image2.png',
                                    ),
                                  ),
                                  kHalfWidthSizedBox,
                                  Expanded(
                                    child: MyClickable(
                                      getOff: false,
                                      navigate: widget.navigate,
                                      child: Text(
                                        widget.product.name,
                                        softWrap: false,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              kHalfSizedBox,
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.product.vendorId.shopName
                                          .toUpperCase(),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: kAccentColor,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  MyClickable(
                                    navigate: widget.navigateCategory,
                                    child: Text(
                                      widget.product.subCategoryId.name,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: kTextBlackColor,
                                        fontSize: 13,
                                        height: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: deviceType(media.width) > 1
                                        ? null
                                        : null,
                                    child: Text(
                                      '₦${doubleFormattedText(widget.product.price)}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'sen',
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: cartCount(),
                                    initialData: false,
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      return snapshot.data
                                          ? OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: kAccentColor,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 15),
                                              ),
                                              onPressed: toLoginPage,
                                              child: const Text('REMOVE'),
                                            )
                                          : OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: kAccentColor,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 15),
                                              ),
                                              onPressed: toLoginPage,
                                              child: const Text('ADD'),
                                            );
                                    },
                                  ),
                                ],
                              ),
                              kHalfSizedBox,
                              const Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              kHalfSizedBox,
                              Text(
                                widget.product.description,
                                maxLines: deviceType(media.width) > 2 ? 5 : 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 20,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: widget.close,
                        child: FaIcon(
                          FontAwesomeIcons.xmark,
                          color: kAccentColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
