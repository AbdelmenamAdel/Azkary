import 'package:azkar/core/common/custom_appbar.dart';
import 'package:azkar/core/common/custom_zoom_image.dart';
import 'package:azkar/core/utils/app_colors.dart';
import 'package:azkar/core/utils/app_images.dart';
import 'package:flutter/material.dart';

class Algmo3ahView extends StatelessWidget {
  const Algmo3ahView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          appBar: customAppbar(context),
          backgroundColor: AppColors.primary,
          body: const Padding(
            padding: EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomZoomImage(
                    tag: 'image1',
                    image: AppImages.image1,
                  ),
                  CustomZoomImage(
                    tag: 'image4',
                    image: AppImages.image4,
                  ),
                  CustomZoomImage(
                    tag: 'image5',
                    image: AppImages.image5,
                  ),
                  CustomZoomImage(
                    tag: 'image7',
                    image: AppImages.image7,
                  ),
                  CustomZoomImage(
                    tag: 'image2',
                    image: AppImages.image2,
                  ),
                  CustomZoomImage(
                    tag: 'image3',
                    image: AppImages.image3,
                  ),
                  CustomZoomImage(
                    tag: 'image9',
                    image: AppImages.image9,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
