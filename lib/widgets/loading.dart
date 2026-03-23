import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constant/colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      child: Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child:  Lottie.asset('assets/images/loader.json',width: 100,height: 100),
          )),
    );
  }
}
