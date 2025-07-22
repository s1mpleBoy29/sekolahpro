import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieWidget extends StatelessWidget {
  final double width;
  final double height;
  final double overlayWidth;
  final double overlayHeight;
  final Color color;
  final String path;

  const LottieWidget({
    super.key,
    required this.width,
    required this.height,
    required this.overlayWidth,
    required this.overlayHeight,
    required this.color,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Lottie.asset(
          path,
          width: width,
          height: height,
          fit: BoxFit.fill,
        ),
        Positioned(
          bottom: 0, // Adjusting the position of the SizedBox vertically
          right: 0, // Adjusting the position of the SizedBox horizontally
          child: SizedBox(
            width: overlayWidth,
            height: overlayHeight,
            child: Container(color: color),
          ),
        )
      ],
    );
  }
}
