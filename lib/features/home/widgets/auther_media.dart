import 'package:azkar/core/common/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthorMedia extends StatelessWidget {
  const AuthorMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12).r,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Row(
              children: [
                Text(
                  "Auther Media",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: "Limelight",
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12).r,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async {
                      var whatsapp = "+201556878109";
                      await urlLauncher(
                        context,
                        "whatsapp://send?phone=$whatsapp&text= السلام عليكم يا بشمهندس ",
                      );
                    },
                    icon: const Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.green,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await urlLauncher(context,
                          "https://www.facebook.com/abdelmenam.adel.10");
                    },
                    icon: const Icon(
                      FontAwesomeIcons.facebook,
                      color: Colors.blue,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await urlLauncher(
                          context, "https://github.com/AbdelmenamAdel/");
                    },
                    icon: const Icon(
                      FontAwesomeIcons.github,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await urlLauncher(context,
                          "https://www.linkedin.com/in/abdelmenam-adel-175b35265/");
                    },
                    icon: Icon(
                      FontAwesomeIcons.linkedinIn,
                      color: Colors.blue[300]!,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "Azkary",
              style: TextStyle(
                fontFamily: 'Limelight',
                color: Theme.of(context).textTheme.displaySmall!.color,
                letterSpacing: 3,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
