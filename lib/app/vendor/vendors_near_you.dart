import 'package:benji_user/app/vendor/vendor_details.dart';
import 'package:benji_user/src/providers/my_liquid_refresh.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/common_widgets/vendor/vendors_card.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/responsive_constant.dart';
import '../../src/repo/models/vendor/vendor.dart';
import '../../src/repo/utils/helpers.dart';
import '../../theme/colors.dart';

class VendorsNearYou extends StatefulWidget {
  const VendorsNearYou({super.key});

  @override
  State<VendorsNearYou> createState() => _VendorsNearYouState();
}

class _VendorsNearYouState extends State<VendorsNearYou> {
  //================================================= INITIAL STATE AND DISPOSE =====================================================\\
  @override
  void initState() {
    super.initState();
    _getData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels >= 200 &&
        _isScrollToTopBtnVisible != true) {
      setState(() {
        _isScrollToTopBtnVisible = true;
      });
    }
    if (_scrollController.position.pixels < 200 &&
        _isScrollToTopBtnVisible == true) {
      setState(() {
        _isScrollToTopBtnVisible = false;
      });
    }
    if (loadMore || thatsAllData) return;

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        loadMore = true;
        start = end;
        end = end + 10;
      });

      await Future.delayed(const Duration(microseconds: 100));
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 25),
        curve: Curves.easeInOut,
      );
      await _getData();

      setState(() {
        loadMore = false;
      });
    }
  }

  Future<void> _scrollToTop() async {
    await _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {
      _isScrollToTopBtnVisible = false;
    });
  }

    _vendorsDetail(vendor) {
    Get.to(
      () => VendorDetails(
          vendor: vendor),
      routeName: 'VendorDetails',
      duration: const Duration(milliseconds: 300),
      fullscreenDialog: true,
      curve: Curves.easeIn,
      preventDuplicates: true,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _scrollController.removeListener(() {});
  }

  Map? _data;
  int start = 0;
  int end = 10;
  bool loadMore = false;
  bool thatsAllData = false;
  bool _isScrollToTopBtnVisible = false;

  _getData() async {
    await checkAuth(context);
    List<VendorModel> vendor = await getVendors(start: start, end: end);

    _data ??= {'vendor': []};

    setState(() {
      thatsAllData = vendor.isEmpty;
      _data = {
        'vendor': _data!['vendor'] + vendor,
      };
    });
  }

//============================================== CONTROLLERS =================================================\\
  final _scrollController = ScrollController();

  //==================================================== FUNCTIONS ===========================================================\\

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _data = null;
      start = 0;
      end = 10;
    });
    await _getData();
  }

  //========================================================================\\

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MyLiquidRefresh(
      handleRefresh: _handleRefresh,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          elevation: 0.0,
          title: "Vendors Near You",
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
          actions: const [],
        ),
        floatingActionButton: _isScrollToTopBtnVisible
            ? FloatingActionButton(
                onPressed: _scrollToTop,
                mini: true,
                backgroundColor: kAccentColor,
                enableFeedback: true,
                mouseCursor: SystemMouseCursors.click,
                tooltip: "Scroll to top",
                hoverColor: kAccentColor,
                hoverElevation: 50.0,
                child: const Icon(Icons.keyboard_arrow_up),
              )
            : const SizedBox(),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: _data == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitChasingDots(color: kAccentColor),
                  ],
                )
              : Scrollbar(
                  controller: _scrollController,
                  child: ListView(
                    controller: _scrollController,
                    dragStartBehavior: DragStartBehavior.down,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                       LayoutGrid(
                                    rowGap: kDefaultPadding/2,
                                    columnGap: kDefaultPadding/2,
                                    columnSizes: breakPointDynamic(
                                        media.width,
                                        [1.fr],
                                        [1.fr, 1.fr],
                                        [1.fr, 1.fr, 1.fr], [1.fr, 1.fr, 1.fr, 1.fr]),
                                    rowSizes: List.generate(_data!['vendor'].length, (index) => auto),
                                    children: (_data!['vendor']
                                            as List<VendorModel>)
                                        .map(
                                          (item) => VendorsCard(
                                removeDistance: true,
                                onTap: () {
                                  _vendorsDetail(item);
                                },
                                vendorName:
                                    item.shopName ?? 'Not Available',
                                typeOfBusiness: item
                                        .shopType!
                                        .name ??
                                    'Not Available',
                                rating:
                                    " ${((item.averageRating) ?? 0.0).toStringAsPrecision(2).toString()} (${(item.numberOfClientsReactions ?? 0).toString()})",
                                cardImage: "assets/images/vendors/ntachi-osa.png"),)
                                        .toList(),
                                  ),thatsAllData
                          ? Container(
                              margin: const EdgeInsets.only(top: 20, bottom: 20),
                              height: 10,
                              width: 10,
                              decoration: ShapeDecoration(
                                shape: const CircleBorder(),
                                color: kPageSkeletonColor,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
