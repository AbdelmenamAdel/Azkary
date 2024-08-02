import 'package:flutter/material.dart';
import 'package:widget_zoom/widget_zoom.dart';

class CustomZoomImage extends StatelessWidget {
  const CustomZoomImage({
    super.key,
    required this.tag,
    required this.image,
  });
  final String tag;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: WidgetZoom(
        heroAnimationTag: tag,
        zoomWidget: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.asset(
            image,
            width: double.infinity,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
