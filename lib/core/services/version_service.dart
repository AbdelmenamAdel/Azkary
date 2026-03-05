import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

class VersionService {
  static const String _playStoreLink =
      'https://play.google.com/store/apps/details?id=com.abdelmoneim.athkary';

  // Get current app version
  static Future<String> getAppVersion() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version; // Returns format like "2.0.3"
    } catch (e) {
      debugPrint('Error getting app version: $e');
      return '0.0.0';
    }
  }

  // Get current app build number
  static Future<String> getBuildNumber() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.buildNumber; // Returns build number like "4"
    } catch (e) {
      debugPrint('Error getting build number: $e');
      return '0';
    }
  }

  // Get full version string (version + build number)
  static Future<String> getFullVersionString() async {
    try {
      final version = await getAppVersion();
      final buildNumber = await getBuildNumber();
      return 'v$version+$buildNumber';
    } catch (e) {
      debugPrint('Error getting full version string: $e');
      return 'v0.0.0+0';
    }
  }

  // Fetch the latest version from the Play Store
  static Future<String?> getStoreVersion() async {
    try {
      final response = await http.get(Uri.parse(_playStoreLink));
      if (response.statusCode == 200) {
        // Play Store often hides the version in a specific pattern
        // This is a common heuristic to find it
        final RegExp regExp = RegExp(r'\[\[\["(\d+\.\d+\.\d+)"\]\]');
        final match = regExp.firstMatch(response.body);
        if (match != null) {
          return match.group(1);
        }

        // Fallback for newer Play Store layout if available
        final RegExp altRegExp = RegExp(
          r'"softwareVersion"\s*:\s*"(\d+\.\d+\.\d+)"',
        );
        final altMatch = altRegExp.firstMatch(response.body);
        if (altMatch != null) {
          return altMatch.group(1);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching store version: $e');
      return null;
    }
  }

  // Compare versions: returns -1 if current < remote, 0 if equal, 1 if current > remote
  static int compareVersions(String currentVersion, String remoteVersion) {
    try {
      final current = _parseVersion(currentVersion);
      final remote = _parseVersion(remoteVersion);

      for (int i = 0; i < 3; i++) {
        if (current[i] < remote[i]) return -1;
        if (current[i] > remote[i]) return 1;
      }
      return 0;
    } catch (e) {
      debugPrint('Error comparing versions: $e');
      return 0;
    }
  }

  // Parse version string like "2.0.3" to [2, 0, 3]
  static List<int> _parseVersion(String version) {
    try {
      final parts = version.split('.');
      return [
        int.parse(parts[0]),
        parts.length > 1 ? int.parse(parts[1]) : 0,
        parts.length > 2 ? int.parse(parts[2]) : 0,
      ];
    } catch (e) {
      debugPrint('Error parsing version: $e');
      return [0, 0, 0];
    }
  }

  // Get Google Play Store link
  static String getPlayStoreLink() => _playStoreLink;
}
