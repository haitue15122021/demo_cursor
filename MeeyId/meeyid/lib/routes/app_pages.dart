import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../shared/index.dart';
import '../app_config/app_config.dart';

part 'app_routes.dart';

// Controllers
class SplashController extends GetxController {
  String? currentFlavor;
  String? nativeFlavor;
  String? detectedFlavor;
  String appName = '';
  String apiBaseUrl = '';
  String firebaseStatus = 'Checking...';
  String remoteConfigFlavor = 'Loading...';

  @override
  void onInit() {
    super.onInit();
    _loadFlavorInfo();
    _testApiClient();
    _testFirebase();
    _testRemoteConfig();
  }

  Future<void> _loadFlavorInfo() async {
    // Get flavor from native
    nativeFlavor = await AppConfig.getFlavor();

    // Detect flavor from package info
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final packageName = packageInfo.packageName;

      if (packageName.endsWith('.dev')) {
        detectedFlavor = 'dev';
      } else if (packageName.endsWith('.staging')) {
        detectedFlavor = 'staging';
      } else if (packageName == 'com.meeyid.app') {
        detectedFlavor = 'production';
      } else {
        detectedFlavor = 'unknown';
      }

      debugPrint('📦 Package Name: $packageName');
      debugPrint('🔍 Detected Flavor: $detectedFlavor');
    } catch (e) {
      debugPrint('❌ Error detecting flavor: $e');
      detectedFlavor = 'unknown';
    }

    // Get info from AppConfig (dotenv)
    appName = AppConfig.appName;
    apiBaseUrl = AppConfig.baseUrl;
    currentFlavor = detectedFlavor; // Use detected flavor

    update();
  }

  Future<void> _testApiClient() async {
    try {
      // Test ApiClient base URL
      final apiClient = Get.find<ApiClient>();
      debugPrint(
        '🔗 Testing ApiClient base URL: ${apiClient.dio.options.baseUrl}',
      );
    } catch (e) {
      debugPrint('❌ Error testing ApiClient: $e');
    }
  }

  Future<void> _testFirebase() async {
    try {
      // Test Firebase Analytics
      await FirebaseAnalytics.instance.logEvent(
        name: 'app_start',
        parameters: {
          'flavor': currentFlavor ?? 'unknown',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      firebaseStatus = '✅ Firebase Connected';
      debugPrint('🔥 Firebase Analytics event logged successfully');
    } catch (e) {
      firebaseStatus = '❌ Firebase Error: $e';
      debugPrint('❌ Firebase error: $e');
    }
    update();
  }

  Future<void> _testRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      // Get flavor value from Remote Config
      final flavorFromRemoteConfig = remoteConfig.getString('flavor');

      remoteConfigFlavor =
          flavorFromRemoteConfig.isNotEmpty
              ? flavorFromRemoteConfig
              : 'Not set';

      debugPrint('🔧 Remote Config Flavor: $remoteConfigFlavor');
      debugPrint('🔧 Detected App Flavor: $detectedFlavor');
      debugPrint('🔧 Native App Flavor: $nativeFlavor');

      // Check if they match
      if (flavorFromRemoteConfig == detectedFlavor) {
        debugPrint('✅ Remote Config flavor matches detected flavor!');
      } else {
        debugPrint('⚠️ Remote Config flavor does NOT match detected flavor!');
        debugPrint(
          '   Expected: $detectedFlavor, Got: $flavorFromRemoteConfig',
        );
      }
    } catch (e) {
      remoteConfigFlavor = 'Error: $e';
      debugPrint('❌ Remote Config error: $e');
    }
    update();
  }
}

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
  ];
}

// Temporary screens - will be replaced with actual implementations
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder:
          (controller) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Name from dotenv
                  Text(
                    controller.appName.isNotEmpty
                        ? controller.appName
                        : 'app_name'.tr,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('welcome'.tr, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 32),

                  // Flavor Information Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Flavor Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Native Flavor
                        Row(
                          children: [
                            const Icon(Icons.phone_android, size: 16),
                            const SizedBox(width: 8),
                            const Text('Native: '),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getFlavorColor(controller.nativeFlavor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                controller.nativeFlavor ?? 'Unknown',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Dotenv Flavor
                        Row(
                          children: [
                            const Icon(Icons.settings, size: 16),
                            const SizedBox(width: 8),
                            const Text('Config: '),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getFlavorColor(
                                  controller.currentFlavor,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                controller.currentFlavor ?? 'Unknown',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // API Base URL
                        Row(
                          children: [
                            const Icon(Icons.cloud, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'API: ${controller.apiBaseUrl}',
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Firebase Status
                        Row(
                          children: [
                            const Icon(Icons.local_fire_department, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Firebase: ${controller.firebaseStatus}',
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Remote Config Flavor
                        Row(
                          children: [
                            const Icon(Icons.cloud_sync, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Remote Config: ${controller.remoteConfigFlavor}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      controller.remoteConfigFlavor ==
                                              controller.detectedFlavor
                                          ? Colors.green
                                          : Colors.orange,
                                  fontWeight:
                                      controller.remoteConfigFlavor ==
                                              controller.detectedFlavor
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.offNamed(Routes.login),
                    child: Text('login'.tr),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Color _getFlavorColor(String? flavor) {
    switch (flavor) {
      case 'dev':
        return Colors.orange;
      case 'staging':
        return Colors.purple;
      case 'production':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('login'.tr)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('login'.tr, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 32),

            // Email field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'email'.tr,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'password'.tr,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Login button
            ElevatedButton(
              onPressed: () => Get.offNamed(Routes.home),
              child: Text('sign_in'.tr),
            ),
            const SizedBox(height: 16),

            // Register link
            TextButton(
              onPressed: () => Get.toNamed(Routes.register),
              child: Text('dont_have_account'.tr),
            ),

            // Language toggle
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                final langController = Get.find<LanguageController>();
                await langController.toggleLanguage();
              },
              icon: const Icon(Icons.language),
              label: Text(
                'Language: ${Get.find<LanguageController>().languageDisplayName}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('register'.tr)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('register'.tr, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 32),

            // Email field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'email'.tr,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'password'.tr,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Password field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'confirm_password'.tr,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Register button
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('sign_up'.tr),
            ),
            const SizedBox(height: 16),

            // Login link
            TextButton(
              onPressed: () => Get.back(),
              child: Text('already_have_account'.tr),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
        actions: [
          IconButton(
            onPressed: () async {
              final langController = Get.find<LanguageController>();
              await langController.toggleLanguage();
            },
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('welcome'.tr, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Get.toNamed(Routes.profile),
              child: Text('profile'.tr),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Get.toNamed(Routes.settings),
              child: Text('settings'.tr),
            ),
            const SizedBox(height: 32),

            // Language info
            Obx(() {
              final langController = Get.find<LanguageController>();
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Current Language: ${langController.languageDisplayName}',
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => langController.toggleLanguage(),
                        child: const Text('Toggle Language'),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('profile'.tr)),
      body: Center(
        child: Text('profile'.tr, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('settings'.tr, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 32),

            // Language settings
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Language Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      final langController = Get.find<LanguageController>();
                      return Column(
                        children:
                            langController.availableLanguages.map((lang) {
                              final isSelected =
                                  langController.currentLanguage ==
                                  lang['code'];
                              return ListTile(
                                title: Text(lang['nativeName']!),
                                subtitle: Text(lang['name']!),
                                trailing:
                                    isSelected
                                        ? const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        )
                                        : null,
                                onTap:
                                    () => langController.changeLanguage(
                                      lang['code']!,
                                    ),
                              );
                            }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Temporary bindings - will be replaced with actual implementations
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // Add login dependencies here
  }
}

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    // Add register dependencies here
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Add home dependencies here
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Add profile dependencies here
  }
}

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    // Add settings dependencies here
  }
}
