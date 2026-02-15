import 'package:azkar/core/common/custom_appbar.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/core/utils/azkar.dart';
import 'package:azkar/features/Azkar/manager/model/zekr_model.dart';
import 'package:flutter/material.dart';
import 'widgets/zekr_card.dart';

class WidgetsWithoutCounter extends StatelessWidget {
  const WidgetsWithoutCounter({super.key, required this.zekrName});
  final String zekrName;
  @override
  Widget build(BuildContext context) {
    late ZekrModel model;
    late int length;
    String title = "أذكاري";
    switch (zekrName) {
      case 'motafareqah':
        title = "أذكار متفرقة";
        length = Azkar().motafareqah.length;
        break;
      case 'roqiah':
        title = "الرقية الشرعية";
        length = Azkar().roqiah.length;
        break;
      case 'fadlElzekr':
        title = "فضل الذكر";
        length = Azkar().fadlElzekr.length;
        break;
      case 'fadlEldo3a':
        title = "فضل الدعاء";
        length = Azkar().fadlEldo3a.length;
        break;
      default:
        length = 0;
    }
    return Container(
      color: context.colors.primary,
      child: SafeArea(
        child: Scaffold(
          appBar: customAppbar(context, title: title),
          body: ListView.builder(
            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
            itemBuilder: (context, index) {
              switch (zekrName) {
                case 'motafareqah':
                  model = Azkar().motafareqah[index];
                  break;
                case 'roqiah':
                  model = Azkar().roqiah[index];
                  break;
                case 'fadlElzekr':
                  model = Azkar().fadlElzekr[index];
                  break;
                case 'fadlEldo3a':
                  model = Azkar().fadlEldo3a[index];
                  break;
              }
              return ZekrCardWidget(
                model: model,
                zekrName: zekrName,
                sort: index + 1,
              );
            },
            itemCount: length,
          ),
        ),
      ),
    );
  }
}
