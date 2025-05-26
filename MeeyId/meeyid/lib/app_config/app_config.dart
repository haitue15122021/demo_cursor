import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meeyid/index.dart';

class AppConfig {
  static String _envConfig(String flavor) {
    switch (flavor) {
      case 'dev':
        return 'assets/env/.env.dev';
      case 'staging':
        return 'assets/env/.env.staging';
      case 'production':
        return 'assets/env/.env.production';
      default:
        return 'assets/env/.env.dev';
    }
  }

  static Future<String?> getFlavor() async {
    try {
      final String? flavor = await const MethodChannel(
        'flavor',
      ).invokeMethod<String>('getFlavor');
      return flavor;
    } catch (e) {
      // Return default flavor if method channel fails
      debugPrint('Failed to get flavor from native: $e');
      return 'dev';
    }
  }

  static Future<void> appConfig() async {
    WidgetsFlutterBinding.ensureInitialized();

    final flavor = await getFlavor();
    debugPrint('🎯 Current flavor: $flavor');

    // Load environment configuration
    try {
      await dotenv.load(fileName: _envConfig(flavor ?? 'dev'));
      debugPrint('✅ Environment loaded for flavor: $flavor');
      debugPrint('📱 App Name: ${dotenv.env['APP_NAME']}');
      debugPrint('🌐 API Base URL: ${dotenv.env['API_BASE_URL']}');
    } catch (e) {
      // If env file doesn't exist, continue without it
      debugPrint(
        '⚠️ Warning: Could not load environment file for flavor: $flavor',
      );
      debugPrint('Error: $e');
    }

    _initOrientations();
  }

  static void _initOrientations() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  // Environment getters - now using dotenv
  static String get appName => dotenv.env['APP_NAME'] ?? 'MeeyId';
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.meeyid.com';
  static String get flavor => dotenv.env['FLAVOR'] ?? 'dev';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static bool get isDebug => flavor == 'dev';
}
