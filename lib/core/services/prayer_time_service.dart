import 'dart:convert';
import 'package:adhan/adhan.dart';
import 'package:azkar/core/services/services_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class PrayerTimeService {
  static const _cacheKey = 'prayer_times_cache';

  // Returns cached prayer times if available for today, otherwise fetches fresh
  Future<PrayerTimes> getPrayerTimes() async {
    // Try to load from cache first
    final cached = await _loadFromCache();
    if (cached != null) return cached;

    // Fetch fresh position and compute prayer times
    final position = await _getCurrentLocation();

    double lat = 30.0444; // Default: Cairo
    double lng = 31.2357;
    if (position != null) {
      lat = position.latitude;
      lng = position.longitude;
    }

    final coordinates = Coordinates(lat, lng);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;

    final now = DateTime.now();
    final date = DateComponents.from(now);
    final prayerTimes = PrayerTimes(coordinates, date, params);

    // Save to cache with today's date
    await _saveToCache(lat, lng, now);

    return prayerTimes;
  }

  Future<PrayerTimes?> _loadFromCache() async {
    try {
      final storage = sl<FlutterSecureStorage>();
      final raw = await storage.read(key: _cacheKey);
      if (raw == null) return null;

      final map = jsonDecode(raw) as Map<String, dynamic>;
      final cachedDate = map['date'] as String;
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      if (cachedDate != today) return null; // Stale — fetch fresh

      final lat = map['lat'] as double;
      final lng = map['lng'] as double;

      final coordinates = Coordinates(lat, lng);
      final params = CalculationMethod.egyptian.getParameters();
      params.madhab = Madhab.shafi;
      final date = DateComponents.from(DateTime.now());

      return PrayerTimes(coordinates, date, params);
    } catch (e) {
      debugPrint('Prayer cache read error: $e');
      return null;
    }
  }

  Future<void> _saveToCache(double lat, double lng, DateTime date) async {
    try {
      final storage = sl<FlutterSecureStorage>();
      final data = jsonEncode({
        'date': DateFormat('yyyy-MM-dd').format(date),
        'lat': lat,
        'lng': lng,
      });
      await storage.write(key: _cacheKey, value: data);
    } catch (e) {
      debugPrint('Prayer cache write error: $e');
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 5),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  String formatTime(DateTime time) => DateFormat.jm().format(time);

  String getPrayerKey(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'prayer_fajr';
      case Prayer.sunrise:
        return 'prayer_sunrise';
      case Prayer.dhuhr:
        return 'prayer_dhuhr';
      case Prayer.asr:
        return 'prayer_asr';
      case Prayer.maghrib:
        return 'prayer_maghrib';
      case Prayer.isha:
        return 'prayer_isha';
      default:
        return '';
    }
  }

  String getPrayerName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'الفجر';
      case Prayer.sunrise:
        return 'الشروق';
      case Prayer.dhuhr:
        return 'الظهر';
      case Prayer.asr:
        return 'العصر';
      case Prayer.maghrib:
        return 'المغرب';
      case Prayer.isha:
        return 'العشاء';
      default:
        return '';
    }
  }

  String getPrayerIcon(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return '🌙';
      case Prayer.sunrise:
        return '🌅';
      case Prayer.dhuhr:
        return '☀️';
      case Prayer.asr:
        return '🌤';
      case Prayer.maghrib:
        return '🌇';
      case Prayer.isha:
        return '🌃';
      default:
        return '🕌';
    }
  }
}
