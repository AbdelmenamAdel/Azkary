import 'dart:math';

import 'package:azkar/core/utils/app_colors.dart';
import 'package:azkar/features/Azkar/manager/model/allah_names_model.dart';
import 'package:flutter/material.dart';

class CustomCardAnimation extends StatefulWidget {
  const CustomCardAnimation({super.key});

  @override
  State<CustomCardAnimation> createState() => _CustomCardAnimationState();
}

class _CustomCardAnimationState extends State<CustomCardAnimation> {
  double _page = 10;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 10);
    pageController.addListener(
      () {
        setState(
          () {
            _page = pageController.page!;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        SizedBox(
          height: width * 1.4,
          width: width * 1.1,
          child: LayoutBuilder(
            builder: (context, boxConstraints) {
              List<Widget> cards = [];

              for (int i = 0; i < AllahNamesModel.allahNames.length; i++) {
                double currentPageValue = i - _page;
                bool pageLocation = currentPageValue > 0;

                double start = 20 +
                    max(
                        (boxConstraints.maxWidth - width * .75) -
                            ((boxConstraints.maxWidth - width * .75) / 2) *
                                -currentPageValue *
                                (pageLocation ? 9 : 1),
                        0.0);

                var customizableCard = Positioned.directional(
                  top: 20 + 30 * max(-currentPageValue, 0.0),
                  bottom: 20 + 30 * max(-currentPageValue, 0.0),
                  start: start,
                  textDirection: TextDirection.ltr,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Container(
                      height: width * .67,
                      width: width * .67,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .15),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                AllahNamesModel.allahNames[i].name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                  color: AppColors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  AllahNamesModel.allahNames[i].description,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nabi',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
                cards.add(customizableCard);
              }
              return Stack(children: cards);
            },
          ),
        ),
        Positioned.fill(
          child: PageView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemCount: AllahNamesModel.allahNames.length,
            controller: pageController,
            itemBuilder: (context, index) {
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
