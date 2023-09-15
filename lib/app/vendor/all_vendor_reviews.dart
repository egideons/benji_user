import 'package:benji_user/src/common_widgets/button/my_elevatedbutton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/route_manager.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/common_widgets/rating_view/customer_review_card.dart';
import '../../src/common_widgets/section/rate_vendor_dialog.dart';
import '../../src/common_widgets/snackbar/my_floating_snackbar.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/my_liquid_refresh.dart';
import '../../src/repo/models/rating/ratings.dart';
import '../../src/repo/models/vendor/vendor.dart';
import '../../src/repo/utils/helpers.dart';
import '../../theme/colors.dart';

class AllVendorReviews extends StatefulWidget {
  final VendorModel vendor;

  const AllVendorReviews({super.key, required this.vendor});

  @override
  State<AllVendorReviews> createState() => _AllVendorReviewsState();
}

class _AllVendorReviewsState extends State<AllVendorReviews> {
//============================================= INITIAL STATE AND DISPOSE  ===================================================\\
  @override
  void initState() {
    super.initState();
    _getData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _scrollListener() async {
    if (loadMore || thatsAllData) return;

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        loadMore = true;
        start = end;
        end = end + 5;
      });

      await Future.delayed(Duration(microseconds: 100));
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 25),
        curve: Curves.easeInOut,
      );
      await _getData();

      setState(() {
        loadMore = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
//==========================================================================================\\

  //=================================== ALL VARIABLES ====================================\\

  //=================================== CONTROLLERS ====================================\\
  final ScrollController _scrollController = ScrollController();

//=================================================== FUNCTIONS =====================================================\\
  void validate() {
    mySnackBar(
      context,
      kSuccessColor,
      "Success!",
      "Thank you for your feedback!",
      Duration(seconds: 1),
    );

    Get.back();
  }

  Map? _data;
  int start = 0;
  int end = 5;
  bool loadMore = false;
  bool thatsAllData = false;

  _getData() async {
    await checkAuth(context);
    List<Ratings> ratings =
        await getRatingsByVendorId(widget.vendor.id!, start: start, end: end);

    if (_data == null) {
      _data = {'ratings': []};
    }
    setState(() {
      thatsAllData = ratings.isEmpty;
      _data = {'ratings': _data!['ratings'] + ratings};
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _data = null;
      start = 0;
      end = 5;
    });
    await _getData();
  }

  //========================================================================\\

//================================ Rating Dialog ======================================\\
  openRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetAnimationCurve: Curves.easeIn,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultPadding)),
          elevation: 50,
          child: RateVendorDialog(vendor: widget.vendor),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyLiquidRefresh(
      handleRefresh: _handleRefresh,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: MyAppBar(
          title: "All Reviews",
          elevation: 0.0,
          actions: [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(10),
          child: MyElevatedButton(
            title: "Add a review",
            onPressed: () {
              openRatingDialog(context);
            },
          ),
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Scrollbar(
            controller: _scrollController,
            child: _data == null
                ? SpinKitChasingDots(color: kAccentColor)
                : ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(kDefaultPadding / 2),
                    dragStartBehavior: DragStartBehavior.down,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      kHalfSizedBox,
                      ListView.separated(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (context, index) => kSizedBox,
                          itemCount: loadMore
                              ? _data!['ratings'].length + 1
                              : _data!['ratings'].length,
                          itemBuilder: (BuildContext context, int index) {
                            if (_data!['ratings'].length == index) {
                              return Column(
                                children: [
                                  SpinKitChasingDots(color: kAccentColor),
                                ],
                              );
                            }
                            return CostumerReviewCard(
                                rating: _data!['ratings'][index]);
                          }),
                      thatsAllData
                          ? Container(
                              margin: EdgeInsets.only(top: 20),
                              height: 10,
                              width: 10,
                              decoration: ShapeDecoration(
                                  shape: CircleBorder(),
                                  color: kPageSkeletonColor),
                            )
                          : SizedBox(),
                      SizedBox(height: kDefaultPadding * 4),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
