import 'package:azkar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ShareWidget extends StatelessWidget {
  const ShareWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: InkWell(
        splashColor: Colors.white,
        // highlightColor: Colors.white,
        focusColor: Colors.white,
        onTap: () {},
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(
            Icons.share,
            color: AppColors.blueGrey,
            size: 28,
          ),
        ),
      ),
    );
  }
}
