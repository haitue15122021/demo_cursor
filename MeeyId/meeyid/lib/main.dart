import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'app_config/app_config.dart';
import 'binding/main_binding.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase - check if already initialized
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      debugPrint('Firebase already initialized');
    } else {
      debugPrint('Firebase initialization error: $e');
      rethrow;
    }
  }

  // Initialize Firebase Remote Config
  await _initRemoteConfig();

  // Initialize app configuration
  await AppConfig.appConfig();

  runApp(const MyApp());
}

Future<void> _initRemoteConfig() async {
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;

    // Set config settings
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    // Set default values
    await remoteConfig.setDefaults({'flavor': 'unknown'});

    // Fetch and activate
    await remoteConfig.fetchAndActivate();

    debugPrint('🔧 Remote Config initialized successfully');
  } catch (e) {
    debugPrint('❌ Remote Config initialization error: $e');
  }
}

class MyApp extends StatelessWidget {
  // Firebase Analytics instance
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MeeyId',
      initialBinding: MainBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      navigatorObservers: [observer],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
