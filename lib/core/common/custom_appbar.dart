import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget? customAppbar(BuildContext context,
    {Color? backgroundColor, String? title}) {
  final colors = context.colors;

  return AppBar(
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
        )),
    backgroundColor: backgroundColor ?? colors.primary,
    elevation: 5,
    shadowColor: Colors.black.withValues(alpha: 0.5),
    centerTitle: true,
    title: Text(
      title ?? context.translate('app_title'),
      style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
    ),
  );
}
