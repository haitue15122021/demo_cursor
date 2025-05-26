import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/index.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();

  final _currentLanguage = 'en'.obs;
  String get currentLanguage => _currentLanguage.value;

  final _isVietnamese = false.obs;
  bool get isVietnamese => _isVietnamese.value;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  /// Load saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(AppConstants.languageKey) ?? 'en';
      await changeLanguage(savedLanguage);
    } catch (e) {
      debugPrint('Error loading saved language: $e');
    }
  }

  /// Change app language
  Future<void> changeLanguage(String languageCode) async {
    try {
      Locale locale;

      switch (languageCode) {
        case AppConstants.vietnamese:
          locale = const Locale('vi', 'VN');
          _isVietnamese.value = true;
          break;
        case AppConstants.english:
        default:
          locale = const Locale('en', 'US');
          _isVietnamese.value = false;
          languageCode = AppConstants.english;
          break;
      }

      _currentLanguage.value = languageCode;

      // Update GetX locale
      await Get.updateLocale(locale);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.languageKey, languageCode);

      // Update global language reactive variable
      final globalLang = Get.find<RxString>(tag: 'app_language');
      globalLang.value = languageCode;

      debugPrint('Language changed to: $languageCode');
    } catch (e) {
      debugPrint('Error changing language: $e');
    }
  }

  /// Toggle between Vietnamese and English
  Future<void> toggleLanguage() async {
    final newLanguage =
        isVietnamese ? AppConstants.english : AppConstants.vietnamese;
    await changeLanguage(newLanguage);
  }

  /// Get localized text
  String tr(String key) {
    return key.tr;
  }

  /// Get current locale
  Locale get currentLocale {
    return isVietnamese ? const Locale('vi', 'VN') : const Locale('en', 'US');
  }

  /// Check if current language is Vietnamese
  bool get isVi => currentLanguage == AppConstants.vietnamese;

  /// Check if current language is English
  bool get isEn => currentLanguage == AppConstants.english;

  /// Get language display name
  String get languageDisplayName {
    return isVietnamese ? 'Tiếng Việt' : 'English';
  }

  /// Get available languages
  List<Map<String, String>> get availableLanguages => [
    {'code': AppConstants.english, 'name': 'English', 'nativeName': 'English'},
    {
      'code': AppConstants.vietnamese,
      'name': 'Vietnamese',
      'nativeName': 'Tiếng Việt',
    },
  ];
}
