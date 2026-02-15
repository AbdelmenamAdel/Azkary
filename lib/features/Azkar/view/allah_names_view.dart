import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/core/utils/app_images.dart';
import 'package:azkar/features/Azkar/manager/model/allah_names_model.dart';
import 'package:azkar/features/Azkar/view/widgets/allah_name_grid_item.dart';
import 'package:flutter/material.dart';

class AllahNamesView extends StatelessWidget {
  const AllahNamesView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context);
    return Scaffold(
      // backgroundColor is handled by global theme (primary)
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: colors.primary,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    AppImages.allahnames,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          colors.primary!,
                          colors.primary!.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    // textDirection: Directionality.of(context),
                    bottom: 60,
                    left: 20,
                    right: 20,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        context.translate('allah_names'),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          color: const Color(0xFFFFD700), // Gold
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              locale.languageCode == 'ar' ? 'Cairo' : null,
                          shadows: const [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surface?.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFFD700)
                      .withValues(alpha: 0.3), // Gold border
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    context.translate('allah_verse'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Nabi',
                      fontSize: 24,
                      color: Color(0xFFFFD700), // Premium Gold
                      height: 1.8,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.translate('subhan_allah'),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      color: colors.text?.withValues(alpha: 0.75),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AllahNameGridItem(
                    model: AllahNamesModel.allahNames[index],
                    index: index,
                  );
                },
                childCount: AllahNamesModel.allahNames.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 50),
          ),
        ],
      ),
    );
  }
}
