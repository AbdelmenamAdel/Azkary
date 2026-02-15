// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:easy_bio/core/database/secure_storage.dart';
// import 'package:easy_bio/core/remote-config/auther_media.dart';
// import 'package:easy_bio/core/routes/app_routes.dart';
// import 'package:easy_bio/core/services/services_locator.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// enum AppConfigStatus { enabled, disabled, configError }

// class RemoteConfigService {
//   static bool? autherMedia;
//   static String? baseUrl;

//   static Future<AppConfigStatus> checkAppStatus() async {
//     bool enabled =
//         await SecureStorage.getBoolean(key: 'easy_bio_enabled') ?? true;
//     String? cachedBaseUrl = await SecureStorage.getString(
//       key: 'easy_bio_base_url',
//     );

//     // Basic validation for cached URL
//     if (cachedBaseUrl != null && cachedBaseUrl.isNotEmpty) {
//       final uri = Uri.tryParse(cachedBaseUrl);
//       if (uri == null ||
//           !uri.hasAbsolutePath ||
//           (uri.scheme != 'http' && uri.scheme != 'https')) {
//         log(
//           'Cached Base URL is invalid: $cachedBaseUrl. Falling back to default.',
//         );
//         cachedBaseUrl = null;
//       }
//     }
//     baseUrl = cachedBaseUrl;

//     log('Initial app enabled status from prefs: $enabled');
//     log('Initial base URL: ${baseUrl ?? "default"}');

//     try {
//       final remoteConfig = FirebaseRemoteConfig.instance;

//       await remoteConfig.setConfigSettings(
//         RemoteConfigSettings(
//           fetchTimeout: const Duration(seconds: 8),
//           minimumFetchInterval: Duration.zero,
//         ),
//       );

//       await remoteConfig.fetchAndActivate();
//       enabled = remoteConfig.getBool('easy_bio_enabled');
//       autherMedia = remoteConfig.getBool('easy_bio_auther_media');
//       String fetchedBaseUrl = remoteConfig.getString('easy_bio_base_url');

//       log('Fetched app enabled status from Remote Config: $enabled');
//       log('Fetched base URL from Remote Config: $fetchedBaseUrl');

//       await SecureStorage.setBoolean(key: 'easy_bio_enabled', value: enabled);

//       if (enabled) {
//         if (fetchedBaseUrl.isNotEmpty) {
//           final uri = Uri.tryParse(fetchedBaseUrl);
//           if (uri == null ||
//               !uri.hasAbsolutePath ||
//               (uri.scheme != 'http' && uri.scheme != 'https')) {
//             log(
//               'CRITICAL: Invalid Base URL fetched from Remote Config: $fetchedBaseUrl',
//             );
//             // If the fetched URL is invalid, we MUST stop the app
//             return AppConfigStatus.configError;
//           }

//           baseUrl = fetchedBaseUrl;
//           await SecureStorage.setString(
//             key: 'easy_bio_base_url',
//             value: fetchedBaseUrl,
//           );

//           // Update Dio if it's already initialized
//           if (sl.isRegistered<Dio>()) {
//             try {
//               sl<Dio>().options.baseUrl = fetchedBaseUrl;
//               log('Updated Dio base URL to: $fetchedBaseUrl');
//             } catch (e) {
//               log('Dio rejected the baseUrl: $fetchedBaseUrl. Error: $e');
//               return AppConfigStatus.configError;
//             }
//           }
//         }
//         return AppConfigStatus.enabled;
//       } else {
//         return AppConfigStatus.disabled;
//       }
//     } catch (e) {
//       log('Failed to fetch Remote Config, using cached values. Error: $e');
//       return enabled ? AppConfigStatus.enabled : AppConfigStatus.disabled;
//     }
//   }

//   static void showBaseUrlErrorDialog() {
//     final context = AppRoutes.navigatorKey.currentContext;
//     if (context == null) return;

//     showCupertinoDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (dialogContext) => CupertinoAlertDialog(
//         title: const Column(
//           children: [
//             Icon(Icons.report_problem, color: Colors.red, size: 40),
//             SizedBox(height: 10),
//             Text('Critical Configuration Error'),
//           ],
//         ),
//         content: const Padding(
//           padding: EdgeInsets.only(top: 12.0),
//           child: Text(
//             'The application configuration is invalid or the server address is incorrect.\n\nAccess is restricted until this is resolved by the developer.',
//             style: TextStyle(fontSize: 15),
//           ),
//         ),
//         actions: [
//           CupertinoDialogAction(
//             onPressed: () {
//               // We do NOT pop the dialog. We show the developer contact over it.
//               showModalBottomSheet(
//                 context: context,
//                 isScrollControlled: true,
//                 backgroundColor: Colors.transparent,
//                 builder: (context) => const AutherMedia(),
//               );
//             },
//             child: const Text(
//               'Contact Developer',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
