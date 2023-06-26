import 'package:alpha_logistics/app/cart/cart.dart';
import 'package:alpha_logistics/reusable%20widgets/see%20all%20container.dart';
import 'package:alpha_logistics/theme/colors.dart';
import 'package:alpha_logistics/theme/constants.dart';
import 'package:flutter/material.dart';

import '../../modules/appBar delivery location.dart';
import '../../modules/category button section.dart';
import '../../modules/home hot deals.dart';
import '../../modules/home popular vendors card.dart';
import '../../modules/home search field.dart';
import '../../modules/homepage vendors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //===================================================\\

  //===================== TEXTEDITING CONTROLLER =======================\\
  TextEditingController searchController = TextEditingController();

  //===================== CATEGORY BUTTONS =======================\\
  final List _categoryButton = [
    "Food",
    "Drinks",
    "Groceries",
    "Pharmaceuticals",
    "Snacks",
  ];

  final List<Color> _categoryButtonBgColor = [
    kAccentColor,
    Color(
      0xFFF2F2F2,
    ),
    Color(
      0xFFF2F2F2,
    ),
    Color(
      0xFFF2F2F2,
    ),
    Color(
      0xFFF2F2F2,
    ),
  ];
  final List<Color> _categoryButtonFontColor = [
    kPrimaryColor,
    Color(
      0xFF828282,
    ),
    Color(
      0xFF828282,
    ),
    Color(
      0xFF828282,
    ),
    Color(
      0xFF828282,
    ),
  ];

//===================== POPULAR VENDORS =======================\\
  final List<int> popularVendorsIndex = [
    0,
    1,
    2,
    3,
    4,
  ];

  final List<String> popularVendorImage = [
    "best-choice-restaurant.png",
    "golden-toast.png",
    "best-choice-restaurant.png",
    "best-choice-restaurant.png",
    "best-choice-restaurant.png",
  ];
  final List<dynamic> popularVendorBannerColor = [
    kAccentColor,
    Color(
      0x00000000,
    ),
    kAccentColor,
    kAccentColor,
    kAccentColor,
  ];
  final List<dynamic> popularVendorBannerText = [
    "Free Delivery",
    "",
    "Free Delivery",
    "Free Delivery",
    "Free Delivery",
  ];

  final List<String> popularVendorName = [
    "Best Choice restaurant",
    "Golden Toast",
    "Best Choice restaurant",
    "Best Choice restaurant",
    "Best Choice restaurant",
  ];

  final List<String> popularVendorFood = [
    "Food",
    "Traditional",
    "Food",
    "Food",
    "Food",
  ];

  final List<String> popularVendorCategory = [
    "Fast Food",
    "Continental",
    "Fast Food",
    "Fast Food",
    "Fast Food",
  ];
  final List<String> popularVendorRating = [
    "3.6",
    "3.6",
    "3.6",
    "3.6",
    "3.6",
  ];
  final List<String> popularVendorNoOfUsersRating = [
    "500+",
    "500+",
    "500+",
    "500+",
    "500+",
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: kPrimaryColor,
        ),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
          titleSpacing: kDefaultPadding / 2,
          elevation: 0.0,
          title: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding / 2,
                ),
                child: Builder(
                  builder: (context) => IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Image.asset(
                      "assets/images/icons/drawer-icon.png",
                    ),
                  ),
                ),
              ),
              AppBarDeliveryLocation(
                deliveryLocation: 'Achara Layout, Enugu',
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Cart(),
                  ),
                );
              },
              splashRadius: 20,
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: Color(
                  0xFF676767,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            color: kPrimaryColor,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(
              kDefaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchField(
                  searchController: searchController,
                ),
                kSizedBox,
                CategoryButtonSection(
                  category: _categoryButton,
                  categorybgColor: _categoryButtonBgColor,
                  categoryFontColor: _categoryButtonFontColor,
                ),
                kHalfSizedBox,
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: [
                      SeeAllContainer(
                        title: "Vendors Near you",
                        onPressed: () {},
                      ),
                      kSizedBox,
                      HomePageVendorsCard(),
                      SizedBox(
                        height: kDefaultPadding * 2,
                      ),
                      SeeAllContainer(
                        title: "Popular Vendors",
                        onPressed: () {},
                      ),
                      kSizedBox,
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            for (int i = 0;
                                i < popularVendorsIndex.length;
                                i++,)
                              PopularVendorsCard(
                                onTap: () {},
                                cardImage: popularVendorImage[i],
                                bannerColor: popularVendorBannerColor[i],
                                bannerText: popularVendorBannerText[i],
                                vendorName: popularVendorName[i],
                                food: popularVendorFood[i],
                                category: popularVendorCategory[i],
                                rating: popularVendorRating[i],
                                noOfUsersRated: popularVendorNoOfUsersRating[i],
                              ),
                          ],
                        ),
                      ),
                      kSizedBox,
                      Text(
                        'Hot Deals',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.40,
                        ),
                      ),
                      kSizedBox,
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            for (int i = 0; i < 5; i++,) HomeHotDeals(),
                          ],
                        ),
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
