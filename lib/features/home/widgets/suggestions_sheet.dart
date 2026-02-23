import 'package:azkar/core/common/url_launcher.dart';
import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SuggestionsSheet extends StatefulWidget {
  const SuggestionsSheet({super.key});

  @override
  State<SuggestionsSheet> createState() => _SuggestionsSheetState();
}

class _SuggestionsSheetState extends State<SuggestionsSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  final TextEditingController _featureController = TextEditingController();
  final TextEditingController _whyController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();

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
    _featureController.dispose();
    _whyController.dispose();
    _exampleController.dispose();
    super.dispose();
  }

  Future<void> _submitSuggestion() async {
    final feature = _featureController.text.trim();
    final why = _whyController.text.trim();
    final example = _exampleController.text.trim();

    if (feature.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate('feedback_error')),
          backgroundColor: context.colors.secondary,
        ),
      );
      return;
    }

    final body =
        '''
Feature Suggestion

Feature:
$feature

Why:
${why.isEmpty ? 'Not specified' : why}

Example:
${example.isEmpty ? 'Not specified' : example}
''';

    await urlLauncher(
      context,
      "mailto:abdelmoneim.adel5@gmail.com?subject=Azkary Feature Suggestion&body=${Uri.encodeComponent(body)}",
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _submitViaWhatsApp() async {
    final feature = _featureController.text.trim();
    final why = _whyController.text.trim();
    final example = _exampleController.text.trim();

    if (feature.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate('feedback_error')),
          backgroundColor: context.colors.secondary,
        ),
      );
      return;
    }

    const whatsapp = "+201556878109";
    final message =
        '''💡 Feature Suggestion

✨ Feature:
$feature

🎯 Why:
${why.isEmpty ? 'Not specified' : why}

📱 Example:
${example.isEmpty ? 'Not specified' : example}''';

    String url =
        "whatsapp://send?phone=$whatsapp&text=${Uri.encodeComponent(message)}";

    await urlLauncher(context, url);
    if (mounted) Navigator.pop(context);
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
                        primary.withValues(alpha: isDark ? 0.50 : 0.2),
                        primary.withValues(alpha: 0.00),
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
                          color: Colors.amber.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lightbulb_rounded,
                          color: Colors.amber,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.translate('suggestion_title'),
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
                              context.translate('feedback_suggestions_desc'),
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
                    _buildTextField(
                      controller: _featureController,
                      label: context.translate('suggestion_feature'),
                      hint: context.translate('suggestion_feature_hint'),
                      maxLines: 4,
                      icon: Icons.lightbulb_circle,
                      textColor: textColor,
                      dividerColor: dividerColor,
                    ),
                    _buildTextField(
                      controller: _whyController,
                      label: context.translate('suggestion_why'),
                      hint: context.translate('suggestion_why_hint'),
                      maxLines: 3,
                      icon: Icons.question_answer,
                      textColor: textColor,
                      dividerColor: dividerColor,
                    ),
                    _buildTextField(
                      controller: _exampleController,
                      label: context.translate('suggestion_example'),
                      hint: context.translate('suggestion_example_hint'),
                      maxLines: 4,
                      icon: Icons.description,
                      textColor: textColor,
                      dividerColor: dividerColor,
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: dividerColor, height: 1),
            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 12.h,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primary, primary.withValues(alpha: 0.8)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _submitSuggestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.translate('feedback_submit'),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _submitViaWhatsApp,
                        icon: const Icon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.green,
                          size: 18,
                        ),
                        label: Text(
                          context.translate('feedback_whatsapp'),
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
                            color: Colors.green.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required int maxLines,
    required Color textColor,
    required Color dividerColor,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.h,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.amber.withValues(alpha: 0.7), size: 16),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: textColor,
            fontSize: 13.sp,
          ),
          decoration: InputDecoration(
            hintText: hint,
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
                color: Colors.amber.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
