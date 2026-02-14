import 'package:azkar/core/common/url_launcher.dart';
import 'package:azkar/core/utils/app_images.dart';
import 'package:flutter/material.dart';

class ERosarySection extends StatelessWidget {
  const ERosarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(10),
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Electronic Rosary",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        """Rosary ia a different tool that enables you to Praise Allah with the traditional 'Sebha' with a counter of 99 or 33.""",
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          const Text(
                            "This Link For More : ",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await urlLauncher(context,
                                  "https://drive.google.com/drive/folders/1lX17PZ0SNJozKlH3wXeWQHy3y08O0hFH?usp=drive_link");
                            },
                            child: const Text(
                              "click here",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
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
