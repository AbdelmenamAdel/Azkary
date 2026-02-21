import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:azkar/core/services/prayer_time_service.dart';
import 'package:azkar/core/services/services_locator.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';

class PrayerTimesSection extends StatefulWidget {
  const PrayerTimesSection({super.key});

  @override
  State<PrayerTimesSection> createState() => _PrayerTimesSectionState();
}

class _PrayerTimesSectionState extends State<PrayerTimesSection> {
  PrayerTimes? _prayerTimes;
  bool _isLoading = true;
  Timer? _countdownTimer;
  Duration _timeUntilNext = Duration.zero;

  final _prayerEnums = const [
    Prayer.fajr,
    Prayer.sunrise,
    Prayer.dhuhr,
    Prayer.asr,
    Prayer.maghrib,
    Prayer.isha,
  ];

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadPrayerTimes() async {
    final times = await sl<PrayerTimeService>().getPrayerTimes();
    if (!mounted) return;
    setState(() {
      _prayerTimes = times;
      _isLoading = false;
    });
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _updateCountdown();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _updateCountdown();
    });
  }

  void _updateCountdown() {
    if (_prayerTimes == null) return;
    final next = _prayerTimes!.nextPrayer();
    final nextTime = _prayerTimes!.timeForPrayer(next);
    if (nextTime == null) return;
    final remaining = nextTime.difference(DateTime.now());
    setState(() {
      _timeUntilNext = remaining.isNegative ? Duration.zero : remaining;
    });
  }

  String _formatCountdown(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primary = colors.primary ?? Colors.teal;
    final secondary = colors.secondary ?? Colors.orange;
    final surface = colors.surface ?? Colors.white;
    final textColor = colors.text ?? Colors.black;
    final subtext = colors.subtext ?? Colors.grey;
    final service = sl<PrayerTimeService>();

    if (_isLoading) {
      return Container(
        height: 190,

        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primary.withValues(alpha: 0.18),
              surface.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primary.withValues(alpha: 0.15)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'جاري تحميل المواقيت...',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: subtext,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final currentPrayer = _prayerTimes!.currentPrayer();
    final nextPrayer = _prayerTimes!.nextPrayer();
    final nextPrayerTime = _prayerTimes!.timeForPrayer(nextPrayer);

    return Column(
      children: [
        // ── Next Prayer Hero Card ──────────────────────────────
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, primary.withValues(alpha: 0.75)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.25),
                blurRadius: 18,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: next prayer info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الصلاة القادمة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${service.getPrayerIcon(nextPrayer)}  ${service.getPrayerName(nextPrayer)}',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nextPrayerTime != null
                          ? service.formatTime(nextPrayerTime)
                          : '--:--',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Right: countdown
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'متبقي',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatCountdown(_timeUntilNext),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Daily Prayer List ──────────────────────────────────
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),

          decoration: BoxDecoration(
            color: surface,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _prayerEnums.map((prayer) {
                final isCurrent = currentPrayer == prayer;
                final isNext = nextPrayer == prayer;
                final time = _prayerTimes!.timeForPrayer(prayer);

                Color indicatorColor;
                if (isCurrent) {
                  indicatorColor = primary;
                } else if (isNext) {
                  indicatorColor = secondary;
                } else {
                  indicatorColor = Colors.transparent;
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      service.getPrayerIcon(prayer),
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      service.getPrayerName(prayer),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: isCurrent
                            ? primary
                            : isNext
                            ? secondary
                            : textColor.withValues(alpha: 0.6),
                        fontWeight: (isCurrent || isNext)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? primary.withValues(alpha: 0.12)
                            : isNext
                            ? secondary.withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        time != null ? service.formatTime(time) : '--:--',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isCurrent
                              ? primary
                              : isNext
                              ? secondary
                              : textColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // dot indicator
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: indicatorColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
