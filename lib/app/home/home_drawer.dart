import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../src/common_widgets/appbar/my_appbar.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class HomeDrawer extends StatefulWidget {
  final Function() toEditProfilePage;
  final Function() copyUserIdToClipBoard;
  final Function() toCheckoutScreen;
  final Function() toFavoritesPage;
  final Function() toOrdersPage;
  final Function() toAddressesPage;
  final Function() toSendPackagePage;
  final Function() logOut;

  final String userID;
  const HomeDrawer({
    super.key,
    required this.copyUserIdToClipBoard,
    required this.userID,
    required this.toOrdersPage,
    // required this.toInvitesPage,
    required this.toAddressesPage,
    required this.toSendPackagePage,
    required this.logOut,
    required this.toFavoritesPage,
    required this.toEditProfilePage,
    required this.toCheckoutScreen,
  });

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kPrimaryColor,
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView(
        children: [
          MyAppBar(
            elevation: 0.0,
            title: "Profile",
            toolbarHeight: kToolbarHeight,
            backgroundColor: kPrimaryColor,
            actions: [],
          ),
          ListTile(
            leading: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              height: 60,
              width: 60,
              decoration: ShapeDecoration(
                color: kPageSkeletonColor,
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/profile/avatar-image.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
                shape: OvalBorder(),
              ),
            ),
            title: Text(
              'Super Maria',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'supermaria@gmail.com',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kTextBlackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.userID,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kTextBlackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      kWidthSizedBox,
                      IconButton(
                        onPressed: widget.copyUserIdToClipBoard,
                        tooltip: "Copy ID",
                        mouseCursor: SystemMouseCursors.click,
                        icon: FaIcon(
                          FontAwesomeIcons.copy,
                          size: 14,
                          color: kAccentColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          kHalfSizedBox,
          Divider(
            color: kTextBlackColor,
          ),
          kHalfSizedBox,
          ListTile(
            onTap: widget.toEditProfilePage,
            leading: FaIcon(
              FontAwesomeIcons.solidCircleUser,
              color: kAccentColor,
            ),
            title: Text(
              'Profile Settings',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: kTextBlackColor,
            ),
          ),
          ListTile(
            onTap: widget.toAddressesPage,
            leading: FaIcon(
              FontAwesomeIcons.locationDot,
              color: kAccentColor,
            ),
            title: Text(
              'Addresses',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: kTextBlackColor,
            ),
          ),
          ListTile(
            onTap: widget.toSendPackagePage,
            leading: FaIcon(
              FontAwesomeIcons.bicycle,
              color: kAccentColor,
            ),
            title: Text(
              'Send Package',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: kTextBlackColor,
            ),
          ),
          ListTile(
            onTap: widget.toFavoritesPage,
            leading: FaIcon(
              FontAwesomeIcons.solidHeart,
              color: kAccentColor,
            ),
            title: Text(
              'Favorites',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: kTextBlackColor,
            ),
          ),
          ListTile(
            onTap: widget.toCheckoutScreen,
            leading: FaIcon(
              Icons.shopping_cart_checkout,
              size: 28,
              color: kAccentColor,
            ),
            title: Text(
              'Checkout',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: kTextBlackColor,
            ),
          ),
          ListTile(
            onTap: widget.toOrdersPage,
            leading: FaIcon(
              FontAwesomeIcons.boxOpen,
              color: kAccentColor,
            ),
            title: Text(
              'My Orders',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: kTextBlackColor,
            ),
          ),
          ListTile(
            onTap: widget.logOut,
            leading: FaIcon(
              FontAwesomeIcons.rightFromBracket,
              color: kAccentColor,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                color: kTextBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: kTextBlackColor,
            ),
          ),
        ],
      ),
    );
  }
}