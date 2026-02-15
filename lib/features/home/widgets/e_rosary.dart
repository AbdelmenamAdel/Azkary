import 'package:azkar/core/common/url_launcher.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/core/utils/app_images.dart';
import 'package:flutter/material.dart';

class ERosarySection extends StatelessWidget {
  const ERosarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(10),
        child: Card(
          elevation: 10,
          color: colors.surface,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Electronic Rosary",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors.text,
                        ),
                      ),
                      Text(
                        """Rosary ia a different tool that enables you to Praise Allah with the traditional 'Sebha' with a counter of 99 or 33.""",
                        style: TextStyle(fontSize: 16, color: colors.text),
                      ),
                      Row(
                        children: [
                          Text(
                            "This Link For More : ",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: colors.text,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await urlLauncher(context,
                                  "https://drive.google.com/drive/folders/1lX17PZ0SNJozKlH3wXeWQHy3y08O0hFH?usp=drive_link");
                            },
                            child: Text(
                              "click here",
                              style: TextStyle(
                                color: colors.primary,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: colors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  child: Image.asset(
                    AppImages.eRosary,
                    height: 100,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
