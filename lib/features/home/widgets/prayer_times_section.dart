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

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    final times = await sl<PrayerTimeService>().getPrayerTimes();
    if (mounted) {
      setState(() {
        _prayerTimes = times;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primaryColor = colors.primary ?? Colors.teal;
    final secondaryColor = colors.secondary ?? Colors.orange;
    final service = sl<PrayerTimeService>();

    if (_isLoading) {
      return Container(
        height: 180,
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final prayerEnums = [
      Prayer.fajr,
      Prayer.sunrise,
      Prayer.dhuhr,
      Prayer.asr,
      Prayer.maghrib,
      Prayer.isha,
    ];

    final currentPrayer = _prayerTimes!.currentPrayer();
    final nextPrayer = _prayerTimes!.nextPrayer();
    final nextPrayerTime = _prayerTimes!.timeForPrayer(nextPrayer);

    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          // Main card for next prayer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "الصلاة القادمة: ${service.getPrayerName(nextPrayer)}",
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      service.formatTime(nextPrayerTime!),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          // Horizontal list of all prayers
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: prayerEnums.map((prayer) {
                  final isCurrent = currentPrayer == prayer;
                  final time = _prayerTimes!.timeForPrayer(prayer);

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Text(
                          service.getPrayerName(prayer),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            color: isCurrent ? primaryColor : colors.text,
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? secondaryColor
                                : Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            service.formatTime(time!),
                            style: TextStyle(
                              color: isCurrent
                                  ? Colors.white
                                  : colors.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
