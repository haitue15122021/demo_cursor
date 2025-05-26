# PROJECT REPLICATION GUIDE - MeeyId Flutter App

## Tổng quan
File hướng dẫn này giúp tái tạo lại hoàn toàn project MeeyId Flutter với Clean Architecture + GetX Pattern, bao gồm:
- Cấu trúc thư mục hoàn chỉnh
- Dependencies và cấu hình
- Base classes và patterns
- GetX implementation (State Management, Routing, DI, i18n)
- Firebase integration với flavors
- Screens và navigation hoàn chỉnh

## Bước 1: Khởi tạo Flutter Project

```bash
flutter create meeyid
cd meeyid
```

## Bước 2: Cấu hình pubspec.yaml

Thay thế nội dung `pubspec.yaml` với:

```yaml
name: meeyid
description: MeeyId Flutter application with Clean Architecture and GetX
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management & Navigation
  get: ^4.6.5
  
  # Networking
  dio: ^5.1.1
  
  # Reactive Programming
  rxdart: ^0.27.7
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_analytics: ^10.7.4
  firebase_crashlytics: ^3.4.8
  firebase_remote_config: ^4.3.8
  firebase_messaging: ^14.7.9
  
  # Local Storage
  shared_preferences: ^2.0.18
  
  # Environment & Configuration
  flutter_dotenv: ^5.0.2
  package_info_plus: ^4.2.0
  
  # UI & Utilities
  flutter_screenutil: ^5.7.0
  flutter_svg: ^2.0.5
  cached_network_image: ^3.2.3
  shimmer: ^3.0.0
  lottie: ^2.3.2
  
  # Authentication & Security
  local_auth: ^2.1.6
  permission_handler: ^10.2.0
  
  # Media
  camera: ^0.10.4
  image_picker: ^0.8.7+1
  image_cropper: ^3.0.3
  
  # JSON & Serialization
  json_annotation: ^4.8.1
  
  # Development
  flutter_launcher_icons: ^0.13.1
  flutter_native_splash: ^2.2.19

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
  build_runner: ^2.4.4
  json_serializable: ^6.6.2

flutter:
  uses-material-design: true
  assets:
    - assets/env/
    - assets/images/
    - assets/icons/
    - assets/fonts/
    - assets/json/
    - assets/locales/
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
        - asset: assets/fonts/Roboto-Bold.ttf
          weight: 700
```

## Bước 3: Tạo cấu trúc thư mục

```
lib/
├── app_config/
│   ├── app_config.dart
│   └── environment.dart
├── base/
│   ├── base_controller.dart
│   └── base_widget.dart
├── binding/
│   └── main_binding.dart
├── constants/
│   ├── app_constants.dart
│   └── api_constants.dart
├── custom_view/
├── extension/
├── gen/
├── middlewares/
├── mixin/
├── pages/
│   └── app_root/
│       └── presentation/
├── routes/
│   ├── app_pages.dart
│   └── app_routes.dart
├── service/
├── shared/
│   ├── api_client/
│   │   ├── api_client.dart
│   │   ├── base_model/
│   │   └── exceptions/
│   ├── data_manager/
│   │   └── data_manager.dart
│   ├── utils/
│   │   ├── language_controller.dart
│   │   └── app_translations.dart
│   └── index.dart
├── theme/
├── firebase_options.dart
└── main.dart

assets/
├── env/
│   ├── .env.dev
│   ├── .env.staging
│   └── .env.production
├── images/
├── icons/
├── fonts/
├── json/
└── locales/
```

## Bước 4: Tạo các file cấu hình môi trường

### assets/env/.env.dev
```
APP_NAME=MeeyId Dev
BASE_URL=https://api-dev.meeyid.com
FLAVOR=dev
```

### assets/env/.env.staging
```
APP_NAME=MeeyId Staging
BASE_URL=https://api-staging.meeyid.com
FLAVOR=staging
```

### assets/env/.env.production
```
APP_NAME=MeeyId
BASE_URL=https://api.meeyid.com
FLAVOR=production
```

## Bước 5: Tạo Base Classes

### lib/base/base_controller.dart
```dart
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseController extends GetxController {
  final CompositeSubscription compositeSubscription = CompositeSubscription();
  
  // Common reactive variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;

  // Navigation helpers
  void goBack() => Get.back();
  void goToNamed(String route, {dynamic arguments}) => 
      Get.toNamed(route, arguments: arguments);
  void goOffNamed(String route, {dynamic arguments}) => 
      Get.offNamed(route, arguments: arguments);
  void goOffAllNamed(String route, {dynamic arguments}) => 
      Get.offAllNamed(route, arguments: arguments);

  // Error handling
  void setError(String message) {
    errorMessage.value = message;
    hasError.value = true;
  }

  void clearError() {
    errorMessage.value = '';
    hasError.value = false;
  }

  // Loading state
  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  @override
  void onClose() {
    compositeSubscription.dispose();
    super.onClose();
  }
}
```

### lib/base/base_widget.dart
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseWidget<T extends GetxController> extends GetView<T> {
  const BaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget? buildAppBar() => null;
  Widget buildBody(BuildContext context);
  Widget? buildFloatingActionButton() => null;
  Widget? buildBottomNavigationBar() => null;
}
```

## Bước 6: Cấu hình App Config

### lib/app_config/app_config.dart
```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../shared/index.dart';

class AppConfig {
  static String get appName => dotenv.env['APP_NAME'] ?? 'MeeyId';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get flavor => dotenv.env['FLAVOR'] ?? 'dev';

  static Future<void> appConfig() async {
    try {
      // Load environment file based on flavor
      final flavorFromNative = await getFlavor();
      final envFile = '.env.${flavorFromNative ?? 'dev'}';
      
      await dotenv.load(fileName: 'assets/env/$envFile');
      debugPrint('🔧 Loaded environment: $envFile');
      
      // Initialize dependencies
      await _initDependencies();
      
    } catch (e) {
      debugPrint('❌ AppConfig error: $e');
      // Fallback to dev environment
      await dotenv.load(fileName: 'assets/env/.env.dev');
      await _initDependencies();
    }
  }

  static Future<void> _initDependencies() async {
    // Initialize ApiClient
    Get.put(ApiClient(), permanent: true);
    
    // Initialize DataManager
    Get.put(DataManager(), permanent: true);
    
    // Initialize LanguageController
    Get.put(LanguageController(), permanent: true);
    
    debugPrint('✅ Dependencies initialized');
  }

  static Future<String?> getFlavor() async {
    try {
      const platform = MethodChannel('flavor');
      final String flavor = await platform.invokeMethod('getFlavor');
      return flavor;
    } on PlatformException catch (e) {
      debugPrint('Failed to get flavor: ${e.message}');
      return null;
    }
  }
}
```

## Bước 7: Dependency Injection

### lib/binding/main_binding.dart
```dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/index.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize SharedPreferences
    Get.putAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance(),
      permanent: true,
    );

    // Global reactive variables
    Get.put(RxString(''), tag: 'user_token', permanent: true);
    Get.put(RxMap<String, dynamic>({}), tag: 'user_data', permanent: true);
    Get.put(RxString('en'), tag: 'app_language', permanent: true);
    Get.put(RxString('light'), tag: 'app_theme', permanent: true);
  }
}
```

## Bước 8: API Client

### lib/shared/api_client/api_client.dart
```dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../app_config/app_config.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
    dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
      ));
    }
  }
}
```

## Bước 9: Language Controller & Translations

### lib/shared/utils/language_controller.dart
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_translations.dart';

class LanguageController extends GetxController {
  final RxString _currentLanguage = 'en'.obs;
  
  String get currentLanguage => _currentLanguage.value;
  
  String get languageDisplayName {
    switch (_currentLanguage.value) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
      default:
        return 'English';
    }
  }

  final List<Map<String, String>> availableLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'vi', 'name': 'Vietnamese', 'nativeName': 'Tiếng Việt'},
  ];

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('app_language') ?? 'en';
      await changeLanguage(savedLanguage);
    } catch (e) {
      debugPrint('Error loading saved language: $e');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      final locale = Locale(languageCode);
      await Get.updateLocale(locale);
      _currentLanguage.value = languageCode;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language', languageCode);
      
      debugPrint('Language changed to: $languageCode');
    } catch (e) {
      debugPrint('Error changing language: $e');
    }
  }

  Future<void> toggleLanguage() async {
    final newLanguage = _currentLanguage.value == 'en' ? 'vi' : 'en';
    await changeLanguage(newLanguage);
  }
}
```

### lib/shared/utils/app_translations.dart
```dart
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'app_name': 'MeeyId',
      'welcome': 'Welcome to MeeyId',
      'login': 'Login',
      'register': 'Register',
      'home': 'Home',
      'profile': 'Profile',
      'settings': 'Settings',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'dont_have_account': "Don't have an account? Register",
      'already_have_account': 'Already have an account? Login',
    },
    'vi': {
      'app_name': 'MeeyId',
      'welcome': 'Chào mừng đến với MeeyId',
      'login': 'Đăng nhập',
      'register': 'Đăng ký',
      'home': 'Trang chủ',
      'profile': 'Hồ sơ',
      'settings': 'Cài đặt',
      'email': 'Email',
      'password': 'Mật khẩu',
      'confirm_password': 'Xác nhận mật khẩu',
      'sign_in': 'Đăng nhập',
      'sign_up': 'Đăng ký',
      'dont_have_account': 'Chưa có tài khoản? Đăng ký',
      'already_have_account': 'Đã có tài khoản? Đăng nhập',
    },
  };
}
```

## Bước 10: Data Manager

### lib/shared/data_manager/data_manager.dart
```dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataManager extends GetxService {
  late SharedPreferences _prefs;

  Future<DataManager> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Token management
  String? getToken() => _prefs.getString('user_token');
  Future<bool> setToken(String token) => _prefs.setString('user_token', token);
  Future<bool> removeToken() => _prefs.remove('user_token');

  // User data
  String? getUserData() => _prefs.getString('user_data');
  Future<bool> setUserData(String userData) => _prefs.setString('user_data', userData);
  Future<bool> removeUserData() => _prefs.remove('user_data');

  // Language
  String getLanguage() => _prefs.getString('app_language') ?? 'en';
  Future<bool> setLanguage(String language) => _prefs.setString('app_language', language);

  // Theme
  String getTheme() => _prefs.getString('app_theme') ?? 'light';
  Future<bool> setTheme(String theme) => _prefs.setString('app_theme', theme);

  // Clear all data
  Future<bool> clearAll() => _prefs.clear();
}
```

## Bước 11: Shared Index File

### lib/shared/index.dart
```dart
// API Client
export 'api_client/api_client.dart';

// Data Manager
export 'data_manager/data_manager.dart';

// Utils
export 'utils/language_controller.dart';
export 'utils/app_translations.dart';
```

## Bước 12: Routes Configuration

### lib/routes/app_routes.dart
```dart
part of 'app_pages.dart';

abstract class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const profile = '/profile';
  static const settings = '/settings';
}
```

## Bước 13: Main App File

### lib/main.dart
```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'app_config/app_config.dart';
import 'binding/main_binding.dart';
import 'routes/app_pages.dart';
import 'shared/utils/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
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

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await remoteConfig.setDefaults({'flavor': 'unknown'});
    await remoteConfig.fetchAndActivate();

    debugPrint('🔧 Remote Config initialized successfully');
  } catch (e) {
    debugPrint('❌ Remote Config initialization error: $e');
  }
}

class MyApp extends StatelessWidget {
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
      translations: AppTranslations(),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
```

## Bước 14: Firebase Configuration

### Tạo Firebase Project và cấu hình flavors:

1. Tạo Firebase project
2. Thêm Android/iOS apps cho từng flavor:
   - `com.meeyid.app.dev` (dev)
   - `com.meeyid.app.staging` (staging)  
   - `com.meeyid.app` (production)
3. Download `google-services.json` và `GoogleService-Info.plist`
4. Chạy FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

## Bước 15: Android Flavor Configuration

### android/app/build.gradle
```gradle
android {
    flavorDimensions "default"
    productFlavors {
        dev {
            dimension "default"
            applicationIdSuffix ".dev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "MeeyId Dev"
        }
        staging {
            dimension "default"
            applicationIdSuffix ".staging"
            versionNameSuffix "-staging"
            resValue "string", "app_name", "MeeyId Staging"
        }
        production {
            dimension "default"
            resValue "string", "app_name", "MeeyId"
        }
    }
}
```

## Bước 16: iOS Flavor Configuration

Sử dụng script Python để tự động tạo schemes và configurations cho iOS:

```bash
python3 setup_ios_flavors.py
```

## Bước 17: Analysis Options

### analysis_options.yaml
```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "build/**"
  
linter:
  rules:
    prefer_single_quotes: true
    sort_constructors_first: true
    sort_unnamed_constructors_first: true
```

## Bước 18: Build và Test

```bash
# Install dependencies
flutter pub get

# Build runner (nếu có code generation)
flutter packages pub run build_runner build

# Run dev flavor
flutter run --flavor dev -t lib/main.dart

# Run staging flavor  
flutter run --flavor staging -t lib/main.dart

# Run production flavor
flutter run --flavor production -t lib/main.dart

# Build APK
flutter build apk --flavor production -t lib/main.dart

# Build iOS
flutter build ios --flavor production -t lib/main.dart
```

## Đặc điểm chính của Architecture

### 1. Clean Architecture
- Separation of concerns
- Feature-based module structure
- Dependency inversion

### 2. GetX Pattern
- **State Management**: Reactive programming với `.obs`
- **Dependency Injection**: Lazy loading với `Get.lazyPut`
- **Routing**: Declarative routing với `GetPage`
- **Internationalization**: Built-in i18n support

### 3. Firebase Integration
- Analytics tracking
- Remote Config cho feature flags
- Crashlytics cho error tracking
- Multi-flavor support

### 4. Multi-Environment Support
- Dev, Staging, Production flavors
- Environment-specific configurations
- Automatic flavor detection

### 5. Reactive UI
- Real-time language switching
- Automatic UI updates với `Obx()`
- Global state management

## Kết luận

Hướng dẫn này cung cấp blueprint hoàn chỉnh để tái tạo project MeeyId với:
- ✅ Clean Architecture structure
- ✅ GetX ecosystem hoàn chỉnh
- ✅ Firebase integration với flavors
- ✅ Multilanguage support
- ✅ Production-ready configuration
- ✅ Comprehensive documentation

Chỉ cần follow từng bước trong hướng dẫn này là có thể tạo ra một project tương tự với đầy đủ tính năng và cấu trúc như MeeyId hiện tại. 