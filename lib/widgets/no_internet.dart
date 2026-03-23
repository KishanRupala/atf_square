import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../constant/colors.dart';

class MyNoInternetWidget extends StatelessWidget {
  final void Function() onPress;

  const MyNoInternetWidget(this.onPress, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/ic_no_internnet.png',
            width: 50,
            height: 50,
          ),
          const Gap(22),
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16),
            child: Text(
              " No Internet connection",
              style: TextStyle(
                  color: black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(12),
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16),
            child: Text(
              'Please check your internet connection and try again.',
              style: TextStyle(
                  color: black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(22),
          TextButton(
            onPressed: onPress,
            style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      side: const BorderSide(width: 1,color: black)
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(black)
            ),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: Text(
                'Try Again',
                style: TextStyle(
                    color: white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
