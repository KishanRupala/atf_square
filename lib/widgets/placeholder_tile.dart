import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constant/colors.dart';
import 'common_widget.dart';

class ShimmerWidget extends StatelessWidget {
  final Widget child;
  const ShimmerWidget({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: child,
    );
  }
}






ShimmerWidget dynamicContainerBuild(double height) {
  return ShimmerWidget(
    child: Container(
    height: height,
      margin: EdgeInsets.only(left: 10,right: 10,top: 8,bottom: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(kButtonCornerRadius),
      ),
    ),
    );
}


