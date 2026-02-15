import 'package:azkar/core/common/url_launcher.dart';
import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AutherMedia extends StatelessWidget {
  const AutherMedia({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Text(
              context.translate('meet_developer'),
              style: TextStyle(
                color: colors.secondary,
                fontWeight: FontWeight.w700,
                fontSize: 22,
                fontFamily: 'Cairo',
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 24),

            // Profile Card
            Card(
              color: colors.surface,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile Image
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.secondary!,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colors.secondary!.withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: colors.primary,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Image.asset(
                            AppImages.men3em,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Name
                    Text(
                      context.translate('developer_name'),
                      style: TextStyle(
                        color: colors.text,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title
                    Text(
                      context.translate('developer_title'),
                      style: TextStyle(
                        color: colors.secondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontFamily: 'Cairo',
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Social Links
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildSocialButton(
                            context,
                            FontAwesomeIcons.whatsapp,
                            Colors.green,
                            () async {
                              const whatsapp = '+201556878109';
                              await urlLauncher(
                                context,
                                'whatsapp://send?phone=$whatsapp',
                              );
                            },
                          ),
                          _buildSocialButton(
                            context,
                            FontAwesomeIcons.facebook,
                            Colors.blue,
                            () async {
                              await urlLauncher(
                                context,
                                'https://www.facebook.com/abdelmenam.adel.10',
                              );
                            },
                          ),
                          _buildSocialButton(
                            context,
                            FontAwesomeIcons.github,
                            colors.text!,
                            () async {
                              await urlLauncher(
                                context,
                                'https://github.com/AbdelmenamAdel/',
                              );
                            },
                          ),
                          _buildSocialButton(
                            context,
                            FontAwesomeIcons.linkedinIn,
                            Colors.blue[700]!,
                            () async {
                              await urlLauncher(
                                context,
                                'https://www.linkedin.com/in/abdelmoneim-adel',
                              );
                            },
                          ),
                          _buildSocialButton(
                            context,
                            FontAwesomeIcons.googlePlay,
                            colors.text!.withValues(alpha: 0.7),
                            () async {
                              await urlLauncher(
                                context,
                                'https://play.google.com/store/apps/dev?id=5304471113374404966',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.1),
            ),
            child: FaIcon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }
}
