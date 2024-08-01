import 'package:azkar/core/utils/app_colors.dart';
import 'package:azkar/core/utils/app_images.dart';
import 'package:azkar/features/Azkar/manager/model/allah_names_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:widget_zoom/widget_zoom.dart';

class AllahNamesView extends StatelessWidget {
  const AllahNamesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: const Padding(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AllahNamesZoomWidget(),
                  MyCustomWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AllahNamesZoomWidget extends StatelessWidget {
  const AllahNamesZoomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: WidgetZoom(
        heroAnimationTag: 'allah_names',
        zoomWidget: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.asset(
            AppImages.allahnames,
            width: double.infinity,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}

class MyCustomWidget extends StatefulWidget {
  const MyCustomWidget({super.key});

  @override
  _MyCustomWidgetState createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget> {
  double _page = 99;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    PageController pageController;
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
                            color: Colors.black.withOpacity(.15),
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
