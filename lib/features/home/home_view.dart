import 'package:flutter/material.dart';
import 'package:azkar/core/utils/app_colors.dart';
import 'widgets/azkar_names_section.dart';
import 'widgets/doaa_image_section.dart';
import 'widgets/e_rosary.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: const Padding(
            padding: EdgeInsets.all(3.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DoaaImageSection(),
                  AzkarNamesSection(),
                  ERosarySection()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
