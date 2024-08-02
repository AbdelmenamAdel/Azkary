import 'package:azkar/core/common/custom_appbar.dart';
import 'package:azkar/core/utils/app_colors.dart';
import 'package:azkar/core/utils/app_images.dart';
import 'package:azkar/core/common/custom_zoom_Image.dart';
import 'package:flutter/material.dart';
import 'widgets/custom_card_animation.dart';

class AllahNamesView extends StatelessWidget {
  const AllahNamesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          appBar: customAppbar(context),
          backgroundColor: AppColors.primary,
          body: const Padding(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomZoomImage(
                    tag: 'allah_names',
                    image: AppImages.allahnames,
                  ),
                  CustomCardAnimation(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
