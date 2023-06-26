import 'package:flutter/material.dart';

import '../theme/colors.dart';

class SeeAllContainer extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const SeeAllContainer({
    super.key,
    required this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(
                0xFF222222,
              ),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.40,
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              elevation: .5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'See all',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kAccentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.28,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: kAccentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
