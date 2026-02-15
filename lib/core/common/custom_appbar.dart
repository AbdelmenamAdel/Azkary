import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget? customAppbar(BuildContext context,
    {Color? backgroundColor, String? title}) {
  return AppBar(
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.white,
        )),
    backgroundColor: backgroundColor ?? AppColors.primary,
    elevation: 5,
    shadowColor: AppColors.blueGrey,
    centerTitle: true,
    title: Text(
      title ?? context.translate('app_title'),
      style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
    ),
  );
}
