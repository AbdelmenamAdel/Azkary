import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/core/common/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedbackHubPage extends StatefulWidget {
  const FeedbackHubPage({super.key});

  @override
  State<FeedbackHubPage> createState() => _FeedbackHubPageState();
}

class _FeedbackHubPageState extends State<FeedbackHubPage> {
  String _selectedBugSeverity = 'medium';
  final TextEditingController _bugDescriptionController =
      TextEditingController();
  final TextEditingController _bugStepsController = TextEditingController();
  final TextEditingController _bugExpectedController = TextEditingController();
  final TextEditingController _bugActualController = TextEditingController();

  final TextEditingController _suggestionFeatureController =
      TextEditingController();
  final TextEditingController _suggestionWhyController =
      TextEditingController();
  final TextEditingController _suggestionExampleController =
      TextEditingController();

  final TextEditingController _supportMessageController =
      TextEditingController();

  @override
  void dispose() {
    _bugDescriptionController.dispose();
    _bugStepsController.dispose();
    _bugExpectedController.dispose();
    _bugActualController.dispose();
    _suggestionFeatureController.dispose();
    _suggestionWhyController.dispose();
    _suggestionExampleController.dispose();
    _supportMessageController.dispose();
    super.dispose();
  }

  Future<void> _submitBugReport() async {
    final description = _bugDescriptionController.text.trim();
    final steps = _bugStepsController.text.trim();
    final expected = _bugExpectedController.text.trim();
    final actual = _bugActualController.text.trim();

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
Bug Report - Severity: $_selectedBugSeverity

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
    _clearBugForm();
  }

  Future<void> _submitBugViaWhatsApp() async {
    final description = _bugDescriptionController.text.trim();
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
        '''🐛 Bug Report - Severity: $_selectedBugSeverity

📝 Description:
$description

🔧 Steps:
${_bugStepsController.text.trim()}

✅ Expected:
${_bugExpectedController.text.trim()}

❌ Actual:
${_bugActualController.text.trim()}''';

    String url =
        "whatsapp://send?phone=$whatsapp&text=${Uri.encodeComponent(message)}";
    await urlLauncher(context, url);
    _clearBugForm();
  }

  void _clearBugForm() {
    _bugDescriptionController.clear();
    _bugStepsController.clear();
    _bugExpectedController.clear();
    _bugActualController.clear();
    setState(() => _selectedBugSeverity = 'medium');
  }

  Future<void> _submitSuggestion() async {
    final feature = _suggestionFeatureController.text.trim();

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
${_suggestionWhyController.text.trim().isEmpty ? 'Not specified' : _suggestionWhyController.text.trim()}

Example:
${_suggestionExampleController.text.trim().isEmpty ? 'Not specified' : _suggestionExampleController.text.trim()}
''';

    await urlLauncher(
      context,
      "mailto:abdelmoneim.adel5@gmail.com?subject=Azkary Feature Suggestion&body=${Uri.encodeComponent(body)}",
    );
    _clearSuggestionForm();
  }

  Future<void> _submitSuggestionViaWhatsApp() async {
    final feature = _suggestionFeatureController.text.trim();

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
${_suggestionWhyController.text.trim().isEmpty ? 'Not specified' : _suggestionWhyController.text.trim()}

📱 Example:
${_suggestionExampleController.text.trim().isEmpty ? 'Not specified' : _suggestionExampleController.text.trim()}''';

    String url =
        "whatsapp://send?phone=$whatsapp&text=${Uri.encodeComponent(message)}";
    await urlLauncher(context, url);
    _clearSuggestionForm();
  }

  void _clearSuggestionForm() {
    _suggestionFeatureController.clear();
    _suggestionWhyController.clear();
    _suggestionExampleController.clear();
  }

  Future<void> _contactSupportViaWhatsApp() async {
    const whatsapp = "+201556878109";
    final message = _supportMessageController.text.trim();
    final text = message.isEmpty
        ? '💖 Hey Abdelmoneim! I want to support your app development!'
        : '💖 $message';

    String url =
        "whatsapp://send?phone=$whatsapp&text=${Uri.encodeComponent(text)}";
    await urlLauncher(context, url);
    _supportMessageController.clear();
  }

  Future<void> _contactSupportViaEmail() async {
    const email = "abdelmoneim.adel5@gmail.com";
    final message = _supportMessageController.text.trim();
    final subject = 'Support for Azkary App Development';
    final body = message.isEmpty
        ? "Hi Abdelmoneim,\n\nI want to support your app development.\n\nBest regards"
        : "Hi Abdelmoneim,\n\n$message\n\nBest regards";

    await urlLauncher(
      context,
      "mailto:$email?subject=$subject&body=${Uri.encodeComponent(body)}",
    );
    _supportMessageController.clear();
  }

  Future<void> _openPayPal() async {
    const paypalLink = "https://www.paypal.com/paypalme/AbdelmoneimAdel";
    await urlLauncher(context, paypalLink);
  }

  Future<void> _openBuyMeCoffee() async {
    const coffeeLink = "https://buymeacoffee.com/abdelmoneim";
    await urlLauncher(context, coffeeLink);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: colors.background,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            backgroundColor: colors.primary,
            elevation: 5,
            shadowColor: colors.primary?.withValues(alpha: 0.5),
            title: Text(
              context.translate('feedback_hub_title'),
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0).r,
              child: Column(
                spacing: 12.h,
                children: [
                  SizedBox(height: 8.h),
                  // Bug Report Expansion Tile
                  _buildBugReportExpansion(isDark),
                  // Suggestions Expansion Tile
                  _buildSuggestionsExpansion(isDark),
                  // Support Developer Expansion Tile
                  _buildSupportExpansion(isDark),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBugReportExpansion(bool isDark) {
    final colors = context.colors;
    final textColor = colors.text ?? Colors.black87;
    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);

    return Card(
      margin: EdgeInsets.zero,
      color: colors.surface ?? Colors.white,
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: const Icon(Icons.bug_report_rounded, color: Colors.red),
          title: Text(
            context.translate('feedback_bugs'),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          subtitle: Text(
            context.translate('feedback_bugs_desc'),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12.sp,
              color: textColor.withValues(alpha: 0.6),
            ),
          ),
          collapsedBackgroundColor: (colors.primary ?? Colors.teal).withValues(
            alpha: 0.05,
          ),
          backgroundColor: (colors.primary ?? Colors.teal).withValues(
            alpha: 0.02,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ).r,
              child: Column(
                spacing: 16.h,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: dividerColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedBugSeverity,
                          isExpanded: true,
                          underline: const SizedBox.shrink(),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          items: [
                            DropdownMenuItem(
                              value: 'low',
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    context.translate('bug_severity_low'),
                                    style: TextStyle(fontFamily: 'Cairo'),
                                  ),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'medium',
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    context.translate('bug_severity_medium'),
                                    style: TextStyle(fontFamily: 'Cairo'),
                                  ),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'high',
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.deepOrange,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    context.translate('bug_severity_high'),
                                    style: TextStyle(fontFamily: 'Cairo'),
                                  ),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'critical',
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    context.translate('bug_critical'),
                                    style: TextStyle(fontFamily: 'Cairo'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedBugSeverity = value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  _buildFormField(
                    controller: _bugDescriptionController,
                    label: context.translate('bug_description'),
                    hint: context.translate('bug_description_hint'),
                    maxLines: 3,
                    textColor: textColor,
                    dividerColor: dividerColor,
                  ),
                  _buildFormField(
                    controller: _bugStepsController,
                    label: context.translate('bug_steps'),
                    hint: context.translate('bug_steps_hint'),
                    maxLines: 3,
                    textColor: textColor,
                    dividerColor: dividerColor,
                  ),
                  _buildFormField(
                    controller: _bugExpectedController,
                    label: context.translate('bug_expected'),
                    hint: context.translate('bug_expected_hint'),
                    maxLines: 2,
                    textColor: textColor,
                    dividerColor: dividerColor,
                  ),
                  _buildFormField(
                    controller: _bugActualController,
                    label: context.translate('bug_actual'),
                    hint: context.translate('bug_actual_hint'),
                    maxLines: 2,
                    textColor: textColor,
                    dividerColor: dividerColor,
                  ),
                  Row(
                    spacing: 10.w,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _submitBugReport,
                          icon: const Icon(Icons.email_rounded, size: 18),
                          label: Text(
                            context.translate('feedback_submit'),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _submitBugViaWhatsApp,
                          icon: const Icon(
                            FontAwesomeIcons.whatsapp,
                            size: 16,
                            color: Colors.green,
                          ),
                          label: Text(
                            'WhatsApp',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12.sp,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            side: const BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsExpansion(bool isDark) {
    final colors = context.colors;
    final textColor = colors.text ?? Colors.black87;
    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);

    return Card(
      margin: EdgeInsets.zero,
      color: colors.surface ?? Colors.white,
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: const Icon(Icons.lightbulb_rounded, color: Colors.amber),
          title: Text(
            context.translate('feedback_suggestions'),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          subtitle: Text(
            context.translate('feedback_suggestions_desc'),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12.sp,
              color: textColor.withValues(alpha: 0.6),
            ),
          ),
          collapsedBackgroundColor: (colors.primary ?? Colors.teal).withValues(
            alpha: 0.05,
          ),
          backgroundColor: (colors.primary ?? Colors.teal).withValues(
            alpha: 0.02,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ).r,
              child: Column(
                spacing: 16.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormField(
                    controller: _suggestionFeatureController,
                    label: context.translate('suggestion_feature'),
                    hint: context.translate('suggestion_feature_hint'),
                    maxLines: 3,
                    textColor: textColor,
                    dividerColor: dividerColor,
                  ),
                  _buildFormField(
                    controller: _suggestionWhyController,
                    label: context.translate('suggestion_why'),
                    hint: context.translate('suggestion_why_hint'),
                    maxLines: 2,
                    textColor: textColor,
                    dividerColor: dividerColor,
                  ),
                  _buildFormField(
                    controller: _suggestionExampleController,
                    label: context.translate('suggestion_example'),
                    hint: context.translate('suggestion_example_hint'),
                    maxLines: 3,
                    textColor: textColor,
                    dividerColor: dividerColor,
                  ),
                  Row(
                    spacing: 10.w,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _submitSuggestion,
                          icon: const Icon(Icons.email_rounded, size: 18),
                          label: Text(
                            context.translate('feedback_submit'),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _submitSuggestionViaWhatsApp,
                          icon: const Icon(
                            FontAwesomeIcons.whatsapp,
                            size: 16,
                            color: Colors.green,
                          ),
                          label: Text(
                            'WhatsApp',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12.sp,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            side: const BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportExpansion(bool isDark) {
    final colors = context.colors;
    final textColor = colors.text ?? Colors.black87;
    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);

    return Card(
      margin: EdgeInsets.zero,
      color: colors.surface ?? Colors.white,
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: const Icon(Icons.favorite_rounded, color: Colors.pink),
          title: Text(
            context.translate('feedback_support'),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          subtitle: Text(
            context.translate('feedback_support_desc'),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12.sp,
              color: textColor.withValues(alpha: 0.6),
            ),
          ),
          collapsedBackgroundColor: Colors.pink.withValues(alpha: 0.05),
          backgroundColor: Colors.pink.withValues(alpha: 0.02),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ).r,
              child: Column(
                spacing: 12.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormField(
                    controller: _supportMessageController,
                    label: context.translate('feedback_label'),
                    hint: 'Share your support thoughts (optional)...',
                    maxLines: 3,
                    textColor: textColor,
                    dividerColor: dividerColor,
                  ),
                  Text(
                    context.translate('support_method'),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  _buildSupportButton(
                    icon: FontAwesomeIcons.whatsapp,
                    iconColor: Colors.green,
                    label: context.translate('support_whatsapp'),
                    onTap: _contactSupportViaWhatsApp,
                  ),
                  _buildSupportButton(
                    icon: Icons.email_rounded,
                    iconColor: context.colors.primary ?? Colors.teal,
                    label: 'Contact via Email',
                    onTap: _contactSupportViaEmail,
                  ),
                  _buildSupportButton(
                    icon: FontAwesomeIcons.mugHot,
                    iconColor: Colors.brown,
                    label: context.translate('support_coffee'),
                    onTap: _openBuyMeCoffee,
                  ),
                  _buildSupportButton(
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

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required int maxLines,
    required Color textColor,
    required Color dividerColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6.h,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: textColor,
            fontSize: 12.sp,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'Cairo',
              color: textColor.withValues(alpha: 0.4),
              fontSize: 11.sp,
            ),
            filled: true,
            fillColor: dividerColor,
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: (context.colors.primary ?? Colors.teal).withValues(
                  alpha: 0.5,
                ),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportButton({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12).r,
        decoration: BoxDecoration(
          border: Border.all(
            color: iconColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 18.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.text ?? Colors.black87,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: iconColor, size: 16.sp),
          ],
        ),
      ),
    );
  }
}
