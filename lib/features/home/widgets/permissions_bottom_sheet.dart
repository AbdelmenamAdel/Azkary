import 'dart:io';
import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsBottomSheet extends StatefulWidget {
  const PermissionsBottomSheet({super.key});

  @override
  State<PermissionsBottomSheet> createState() => _PermissionsBottomSheetState();
}

class _PermissionsBottomSheetState extends State<PermissionsBottomSheet>
    with TickerProviderStateMixin {
  bool _notifGranted = false;
  bool _locationGranted = false;
  bool _exactAlarmGranted = false;
  bool _isLoading = true;

  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    );
    _loadStatuses();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadStatuses() async {
    final notif = await Permission.notification.status;
    final loc = await Permission.locationWhenInUse.status;
    bool exactAlarm = false;
    if (Platform.isAndroid) {
      exactAlarm = await Permission.scheduleExactAlarm.isGranted;
    }
    if (mounted) {
      setState(() {
        _notifGranted = notif.isGranted;
        _locationGranted = loc.isGranted;
        _exactAlarmGranted = exactAlarm;
        _isLoading = false;
      });
      _slideController.forward(from: 0);
    }
  }

  Future<void> _toggle(Permission permission, bool current) async {
    if (current) {
      await openAppSettings();
    } else {
      final result = await permission.request();
      if (result.isPermanentlyDenied) await openAppSettings();
    }
    setState(() => _isLoading = true);
    await _loadStatuses();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primary = colors.primary ?? Colors.teal;
    final secondary = colors.secondary ?? Colors.orange;
    final surface = colors.surface ?? Colors.white;
    final textColor = colors.text ?? Colors.black;
    final subtext = colors.subtext ?? Colors.grey;

    // Determine if this is a "dark" theme by checking text brightness
    final isDark =
        ThemeData.estimateBrightnessForColor(textColor) == Brightness.light;

    final sheetBg = isDark ? Color.lerp(surface, Colors.black, 0.15)! : surface;

    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──────────────────────────────────────
          Padding(
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

          // ── Header ────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primary.withValues(alpha: isDark ? 0.25 : 0.12),
                  primary.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.security_rounded, color: primary, size: 24),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.translate('permissions'),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    Text(
                      context.translate('permissions_subtitle'),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: subtext,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Global status badge
                if (!_isLoading)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _allGranted
                          ? Colors.green.withValues(alpha: 0.15)
                          : secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _allGranted
                            ? Colors.green.withValues(alpha: 0.4)
                            : secondary.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      _allGranted
                          ? context.translate('perm_all_granted')
                          : context.translate('perm_incomplete'),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _allGranted ? Colors.green : secondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Divider(color: dividerColor, height: 1),

          // ── Body ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _isLoading
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context.translate('perm_loading'),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: subtext,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) => Column(
                      children: [
                        _buildTile(
                          index: 0,
                          icon: Icons.notifications_active_rounded,
                          title: context.translate('perm_notifications'),
                          subtitle: context.translate('perm_notifications_sub'),
                          isGranted: _notifGranted,
                          primary: primary,
                          secondary: secondary,
                          textColor: textColor,
                          subtext: subtext,
                          sheetBg: sheetBg,
                          isDark: isDark,
                          onToggle: () =>
                              _toggle(Permission.notification, _notifGranted),
                        ),
                        const SizedBox(height: 10),
                        _buildTile(
                          index: 1,
                          icon: Icons.my_location_rounded,
                          title: context.translate('perm_location'),
                          subtitle: context.translate('perm_location_sub'),
                          isGranted: _locationGranted,
                          primary: primary,
                          secondary: secondary,
                          textColor: textColor,
                          subtext: subtext,
                          sheetBg: sheetBg,
                          isDark: isDark,
                          onToggle: () => _toggle(
                            Permission.locationWhenInUse,
                            _locationGranted,
                          ),
                        ),
                        if (Platform.isAndroid) ...[
                          const SizedBox(height: 10),
                          _buildTile(
                            index: 2,
                            icon: Icons.alarm_on_rounded,
                            title: context.translate('perm_exact_alarm'),
                            subtitle: context.translate('perm_exact_alarm_sub'),
                            isGranted: _exactAlarmGranted,
                            primary: primary,
                            secondary: secondary,
                            textColor: textColor,
                            subtext: subtext,
                            sheetBg: sheetBg,
                            isDark: isDark,
                            onToggle: () => _toggle(
                              Permission.scheduleExactAlarm,
                              _exactAlarmGranted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),

          // ── Footer ────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _isLoading = true);
                      _loadStatuses();
                    },
                    icon: Icon(Icons.refresh_rounded, color: primary, size: 18),
                    label: Text(
                      context.translate('perm_refresh'),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primary.withValues(alpha: 0.4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => openAppSettings(),
                    icon: const Icon(
                      Icons.settings_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Text(
                      context.translate('perm_open_settings'),
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool get _allGranted {
    if (Platform.isAndroid) {
      return _notifGranted && _locationGranted && _exactAlarmGranted;
    }
    return _notifGranted && _locationGranted;
  }

  Widget _buildTile({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isGranted,
    required Color primary,
    required Color secondary,
    required Color textColor,
    required Color subtext,
    required Color sheetBg,
    required bool isDark,
    required VoidCallback onToggle,
  }) {
    final delay = index * 0.12;
    final t =
        (_slideAnimation.value - delay).clamp(0.0, 1.0) /
        (1.0 - delay.clamp(0.0, 0.5));

    final statusColor = isGranted ? Colors.green : secondary;
    final tileColor = isGranted
        ? Colors.green.withValues(alpha: isDark ? 0.12 : 0.07)
        : secondary.withValues(alpha: isDark ? 0.12 : 0.07);
    final borderColor = isGranted
        ? Colors.green.withValues(alpha: isDark ? 0.35 : 0.25)
        : secondary.withValues(alpha: isDark ? 0.3 : 0.2);

    return Transform.translate(
      offset: Offset(0, 20 * (1 - t)),
      child: Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: isDark ? 0.2 : 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: statusColor, size: 22),
              ),
              const SizedBox(width: 14),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: subtext,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Status badge + toggle
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isGranted
                          ? context.translate('perm_enabled')
                          : context.translate('perm_disabled'),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Custom animated toggle
                  GestureDetector(
                    onTap: onToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 50,
                      height: 26,
                      decoration: BoxDecoration(
                        color: isGranted
                            ? Colors.green
                            : (isDark
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : Colors.black.withValues(alpha: 0.12)),
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: isGranted
                            ? [
                                BoxShadow(
                                  color: Colors.green.withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            alignment: isGranted
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.all(3),
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: isGranted
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 12,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
