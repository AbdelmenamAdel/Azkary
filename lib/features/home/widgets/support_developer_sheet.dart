import 'package:azkar/core/common/url_launcher.dart';
import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SupportDeveloperSheet extends StatefulWidget {
  const SupportDeveloperSheet({super.key});

  @override
  State<SupportDeveloperSheet> createState() => _SupportDeveloperSheetState();
}

class _SupportDeveloperSheetState extends State<SupportDeveloperSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideController.forward(from: 0);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _contactViaWhatsApp() async {
    const whatsapp = "+201556878109";
    final message = _messageController.text.trim();
    final text = message.isEmpty
        ? '💖 Hey Abdelmoneim! I want to support your app development!'
        : '💖 $message';

    String url =
        "whatsapp://send?phone=$whatsapp&text=${Uri.encodeComponent(text)}";

    await urlLauncher(context, url);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _contactViaEmail() async {
    const email = "abdelmoneim.adel5@gmail.com";
    final message = _messageController.text.trim();
    const subject = 'Support for Athkary App Development';
    final body = message.isEmpty
        ? "Hi Abdelmoneim,\n\nI want to support your app development.\n\nBest regards"
        : "Hi Abdelmoneim,\n\n$message\n\nBest regards";

    await urlLauncher(
      context,
      "mailto:$email?subject=$subject&body=${Uri.encodeComponent(body)}",
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _openPayPal() async {
    // Replace with actual PayPal link
    const paypalLink = "https://www.paypal.com/paypalme/AbdelmoneimAdel";
    await urlLauncher(context, paypalLink);
  }

  Future<void> _openBuyMeCoffee() async {
    // Replace with actual Buy Me a Coffee link
    const coffeeLink = "https://buymeacoffee.com/abdelmoneim";
    await urlLauncher(context, coffeeLink);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primary = colors.primary ?? Colors.teal;
    final surface = colors.surface ?? Colors.white;
    final textColor = colors.text ?? Colors.black87;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);

    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            100 * (1 - Curves.easeOutCubic.transform(_slideController.value)),
          ),
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 36, 24, 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.pink.withValues(alpha: isDark ? 0.50 : 0.2),
                        Colors.pink.withValues(alpha: 0.00),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.pink.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.pink,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.translate('support_title'),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: textColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              context.translate('support_message'),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 10,
                                color: textColor.withValues(alpha: 0.6),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14, bottom: 4),
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.25)
                            : Colors.black.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: dividerColor, height: 1),
            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.h,
                  children: [
                    // Optional Message
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.h,
                      children: [
                        Text(
                          context.translate('feedback_label'),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        TextField(
                          controller: _messageController,
                          maxLines: 4,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: textColor,
                            fontSize: 13.sp,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                "Share your support thoughts (optional)...",
                            hintStyle: TextStyle(
                              fontFamily: 'Cairo',
                              color: textColor.withValues(alpha: 0.4),
                              fontSize: 12.sp,
                            ),
                            filled: true,
                            fillColor: dividerColor,
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.pink.withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Support Methods
                    Text(
                      context.translate('support_method'),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
            Divider(color: dividerColor, height: 1),
            // Footer with support methods
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 12.h,
                children: [
                  // WhatsApp button
                  _SupportButton(
                    icon: FontAwesomeIcons.whatsapp,
                    iconColor: Colors.green,
                    label: context.translate('support_whatsapp'),
                    onTap: _contactViaWhatsApp,
                  ),
                  // Email button
                  _SupportButton(
                    icon: Icons.email_rounded,
                    iconColor: primary,
                    label: 'Contact via Email',
                    onTap: _contactViaEmail,
                  ),
                  // Coffee button
                  _SupportButton(
                    icon: FontAwesomeIcons.mugHot,
                    iconColor: Colors.brown,
                    label: context.translate('support_coffee'),
                    onTap: _openBuyMeCoffee,
                  ),
                  // PayPal button
                  _SupportButton(
                    icon: FontAwesomeIcons.paypal,
                    iconColor: const Color(0xFF003087),
                    label: context.translate('support_paypal'),
                    onTap: _openPayPal,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _SupportButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textColor = colors.text ?? Colors.black87;

    return SizedBox(
      width: double.infinity,
      child: Expanded(
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, color: iconColor, size: 18.sp),
          label: Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: textColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(
              color: iconColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
            backgroundColor: iconColor.withValues(alpha: 0.08),
          ),
        ),
      ),
    );
  }
}
