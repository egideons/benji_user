import 'package:flutter/material.dart';

import '../../src/providers/constants.dart';
import '../../src/reusable widgets/my appbar.dart';
import '../../src/reusable widgets/search field.dart';
import '../../src/reusable widgets/track order details container.dart';
import '../../theme/colors.dart';

class OrdersHistory extends StatefulWidget {
  const OrdersHistory({super.key});

  @override
  State<OrdersHistory> createState() => _OrdersHistoryState();
}

class _OrdersHistoryState extends State<OrdersHistory> {
  //=================================== ALL VARIABLES ====================================\\

  //=================================== CONTROLLERS ====================================\\
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: MyAppBar(
          elevation: 0.0,
          title: "My Orders ",
          toolbarHeight: 80,
          backgroundColor: kPrimaryColor,
          actions: [],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            margin: EdgeInsets.only(
              top: kDefaultPadding,
              left: kDefaultPadding,
              right: kDefaultPadding,
            ),
            child: Column(
              children: [
                SearchField(
                  hintText: "Search your orders",
                  searchController: searchController,
                  onTap: () {
                    SearchBar();
                  },
                ),
                kSizedBox,
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: [
                      Container(
                        child: Text(
                          'May 2021',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      kSizedBox,
                      TrackOrderDetailsContainer(
                        shipIconDetail: Icons.cancel_rounded,
                        shipIconDetailColor: kAccentColor,
                        shipDetailText: "Unshipped",
                        shipDetailTextColor: kAccentColor,
                      ),
                      kHalfSizedBox,
                      TrackOrderDetailsContainer(
                        shipIconDetail: Icons.check_circle_rounded,
                        shipIconDetailColor: kSuccessColor,
                        shipDetailText: "Delivered",
                        shipDetailTextColor: kSuccessColor,
                      ),
                      kSizedBox,
                      Container(
                        child: Text(
                          'April 2021',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      kSizedBox,
                      TrackOrderDetailsContainer(
                        shipIconDetail: Icons.local_shipping_rounded,
                        shipIconDetailColor: kSecondaryColor,
                        shipDetailText: "Shipped",
                        shipDetailTextColor: kSecondaryColor,
                      ),
                      kHalfSizedBox,
                      TrackOrderDetailsContainer(
                        shipIconDetail: Icons.error_rounded,
                        shipIconDetailColor: kLoadingColor,
                        shipDetailText: "Closed",
                        shipDetailTextColor: kLoadingColor,
                      ),
                      kHalfSizedBox,
                      TrackOrderDetailsContainer(
                        shipIconDetail: Icons.check_circle_rounded,
                        shipIconDetailColor: kSuccessColor,
                        shipDetailText: "Delivered",
                        shipDetailTextColor: kSuccessColor,
                      ),
                      kSizedBox,
                      Container(
                        child: Text(
                          'April 2021',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      kSizedBox,
                      TrackOrderDetailsContainer(
                        shipIconDetail: Icons.error_rounded,
                        shipIconDetailColor: kLoadingColor,
                        shipDetailText: "Closed",
                        shipDetailTextColor: kLoadingColor,
                      ),
                      SizedBox(
                        height: kDefaultPadding * 3,
                      ),
                      Container(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'View More',
                            style: TextStyle(
                              color: kAccentColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: kDefaultPadding * 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
