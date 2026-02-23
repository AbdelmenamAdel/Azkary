import 'package:azkar/core/common/url_launcher.dart';
import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BugReportSheet extends StatefulWidget {
  const BugReportSheet({super.key});

  @override
  State<BugReportSheet> createState() => _BugReportSheetState();
}

class _BugReportSheetState extends State<BugReportSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _expectedController = TextEditingController();
  final TextEditingController _actualController = TextEditingController();

  String _selectedSeverity = 'medium';

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
    _descriptionController.dispose();
    _stepsController.dispose();
    _expectedController.dispose();
    _actualController.dispose();
    super.dispose();
  }

  Future<void> _submitBugReport() async {
    final description = _descriptionController.text.trim();
    final steps = _stepsController.text.trim();
    final expected = _expectedController.text.trim();
    final actual = _actualController.text.trim();

    if (description.isEmpty ||
        steps.isEmpty ||
        expected.isEmpty ||
        actual.isEmpty) {
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
Bug Report - Severity: $_selectedSeverity

Description:
$description

Steps to Reproduce:
$steps

Expected Behavior:
$expected

Actual Behavior:
$actual
''';

    await urlLauncher(
      context,
      "mailto:abdelmoneim.adel5@gmail.com?subject=Azkary Bug Report&body=${Uri.encodeComponent(body)}",
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _submitViaWhatsApp() async {
    final description = _descriptionController.text.trim();
    final steps = _stepsController.text.trim();
    final expected = _expectedController.text.trim();
    final actual = _actualController.text.trim();

    if (description.isEmpty) {
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
        '''🐛 Bug Report - Severity: $_selectedSeverity

📝 Description:
$description

🔧 Steps:
$steps

✅ Expected:
$expected

❌ Actual:
$actual''';

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
                          color: Colors.red.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.bug_report_rounded,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.translate('bug_title'),
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
                              context.translate('feedback_bugs_desc'),
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
                    // Severity Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.h,
                      children: [
                        Text(
                          context.translate('bug_severity'),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: dividerColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.teal.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedSeverity,
                            isExpanded: true,
                            underline: const SizedBox.shrink(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'low',
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      context.translate('bug_severity_low'),
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'medium',
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      context.translate('bug_severity_medium'),
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'high',
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      context.translate('bug_severity_high'),
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'critical',
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      context.translate('bug_critical'),
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedSeverity = value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    _buildTextField(
                      controller: _descriptionController,
                      label: context.translate('bug_description'),
                      hint: context.translate('bug_description_hint'),
                      maxLines: 4,
                      icon: Icons.description,
                      textColor: textColor,
                      dividerColor: dividerColor,
                    ),
                    _buildTextField(
                      controller: _stepsController,
                      label: context.translate('bug_steps'),
                      hint: context.translate('bug_steps_hint'),
                      maxLines: 4,
                      icon: Icons.list_alt,
                      textColor: textColor,
                      dividerColor: dividerColor,
                    ),
                    _buildTextField(
                      controller: _expectedController,
                      label: context.translate('bug_expected'),
                      hint: context.translate('bug_expected_hint'),
                      maxLines: 3,
                      icon: Icons.check_circle,
                      textColor: textColor,
                      dividerColor: dividerColor,
                    ),
                    _buildTextField(
                      controller: _actualController,
                      label: context.translate('bug_actual'),
                      hint: context.translate('bug_actual_hint'),
                      maxLines: 3,
                      icon: Icons.error_outline,
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
                mainAxisSize: MainAxisSize.min,
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
                      onPressed: _submitBugReport,
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
                  OutlinedButton.icon(
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
                      minimumSize: const Size.fromHeight(48),
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
              Icon(icon, color: Colors.teal.withValues(alpha: 0.7), size: 16),
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
                color: Colors.teal.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
