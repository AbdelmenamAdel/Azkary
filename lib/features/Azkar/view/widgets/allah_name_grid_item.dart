import 'package:azkar/core/manager/app_cubit.dart';
import 'package:azkar/core/theme/app_theme_enum.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/features/Azkar/manager/model/allah_names_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

class AllahNameGridItem extends StatelessWidget {
  final AllahNamesModel model;
  final int index;

  const AllahNameGridItem({
    super.key,
    required this.model,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isMidnight =
        context.read<AppCubit>().state.theme == AppTheme.midnight;
    final primaryColor = isMidnight
        ? const Color(0xFFFFD700)
        : colors.secondary!;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (index % 10 * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _showDetail(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.surface!, colors.surface!.withValues(alpha: 0.8)],
            ),
            border: Border.all(
              color: colors.primary!.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.primary!.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Subtle Islamic Pattern Pattern Overlay
                Positioned(
                  right: -20,
                  top: -20,
                  child: Icon(
                    Icons.mosque,
                    size: 80,
                    color: colors.primary!.withValues(
                      alpha: 0.05,
                    ), // Subtle theme accent icon
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        model.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'Nabi',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          shadows: [
                            Shadow(
                              color: primaryColor.withValues(alpha: 0.1),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    final colors = context.colors;
    final isMidnight =
        context.read<AppCubit>().state.theme == AppTheme.midnight;
    final primaryColor = isMidnight
        ? const Color(0xFFFFD700)
        : colors.secondary!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: .1, sigmaY: .1),
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: colors.background?.withValues(alpha: 0.9),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              border: Border.all(
                color: colors.secondary!.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colors.secondary!.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  model.name,
                  style: TextStyle(
                    fontFamily: 'Nabi',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    model.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 20,
                      color: colors.text,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
