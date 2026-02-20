import 'package:azkar/core/utils/capture_and_share_utils.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_cubit.dart';
import 'package:azkar/features/Azkar/manager/model/zekr_model.dart';
import 'package:azkar/features/Azkar/view/widgets/share.dart';
import 'package:flutter/material.dart';

import 'zekr_section.dart';

class ZekrCardWidget extends StatefulWidget {
  const ZekrCardWidget({
    super.key,
    this.model,
    required this.sort,
    required this.zekrName,
  });
  final ZekrModel? model;
  final String zekrName;
  final int sort;

  @override
  State<ZekrCardWidget> createState() => _ZekrCardWidgetState();
}

class _ZekrCardWidgetState extends State<ZekrCardWidget> {
  final GlobalKey _cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var cubit = ZekrCounterCubit.get(context);
    final colors = context.colors;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        switch (widget.zekrName) {
          case 'morning':
            cubit.updateMorningCurrentStep(widget.sort - 1);
            break;
          case 'night':
            cubit.updateNightCurrentStep(widget.sort - 1);
            break;
          case 'afterPray':
            cubit.updateAfterPrayCurrentStep(widget.sort - 1);
            break;
          case 'sleeping':
            cubit.updateSleepingCurrentStep(widget.sort - 1);
            break;
          case 'werdak':
            cubit.updateWerdakCurrentStep(widget.sort - 1);
            break;
          case 'goame3Eldo3a':
            cubit.updateGoame3Eldo3aCurrentStep(widget.sort - 1);
            break;
        }
      },
      child: RepaintBoundary(
        key: _cardKey,
        child: Card(
          color: colors.surface,
          margin: const EdgeInsets.all(5),
          child: Stack(
            children: [
              Positioned.directional(
                textDirection: Directionality.of(context),
                top: 0,
                end: 0,
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors.secondary!,
                        colors.secondary!.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: const BorderRadiusDirectional.only(
                      topEnd: Radius.circular(12),
                      bottomStart: Radius.circular(4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.secondary!.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "${widget.sort}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: colors.surface,
                        shadows: const [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ZekrSection(model: widget.model!, zekrName: widget.zekrName),
              ShareWidget(
                onTap: () => CaptureAndShareUtils.captureAndShare(
                  _cardKey,
                  fileName: 'zekr_${widget.sort}',
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.mosque_rounded,
                    color: colors.secondary?.withValues(alpha: 0.8),
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
