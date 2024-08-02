import 'package:azkar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget? customAppbar(BuildContext context) {
  return AppBar(
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.white,
        )),
    backgroundColor: AppColors.primary,
    elevation: 5,
    shadowColor: AppColors.blueGrey,
    centerTitle: true,
    title: const Text("Believe In Allah and Yourself"),
  );
}
