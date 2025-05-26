# MeeyId - Flutter Clean Architecture + GetX

## 📋 Overview

MeeyId is a Flutter application built with Clean Architecture pattern and **GetX** for state management, dependency injection, routing, and internationalization.

## 🏗️ Architecture

This project follows Clean Architecture principles with **GetX Pattern**:

```
lib/
├── app_config/          # App configuration and initialization
├── base/               # Base classes (GetxController, Widget)
├── binding/            # GetX Dependency Injection
├── constants/          # App constants and API endpoints
├── custom_view/        # Custom widgets
├── extension/          # Extension methods
├── gen/               # Generated files (assets, localization)
├── middlewares/        # Route middlewares
├── mixin/             # Mixins
├── pages/             # Feature modules
├── routes/            # GetX Navigation routing
├── service/           # Services (Dialog, BottomSheet, etc.)
├── shared/            # Shared utilities (LanguageController)
└── theme/             # Theme configuration
```

## 🛠️ Core Technologies

- **Flutter SDK**: ^3.7.2
- **GetX**: ^4.6.5 - State management, DI, routing, internationalization
- **RxDart**: ^0.27.7 - Reactive programming
- **Dio**: ^5.1.1 - HTTP client for REST API
- **Flutter ScreenUtil**: ^5.6.0 - Screen adaptation
- **Shared Preferences**: ^2.0.18 - Local storage
- **Flutter Gen**: ^5.2.0 - Asset generation

## ✨ GetX Features Implemented

### 🔄 State Management
- Reactive programming with `.obs` variables
- `Obx()` widgets for automatic UI updates
- `GetxController` base class with lifecycle management
- Error handling and loading states

### 🧭 Navigation & Routing
- Declarative routing with `GetPage`
- Named routes with `Get.toNamed()`
- Arguments passing between screens
- Route bindings for dependency injection

### 💉 Dependency Injection
- `Bindings` pattern for feature-based DI
- `Get.lazyPut()` for lazy initialization
- `Get.putAsync()` for async dependencies
- Global and local dependency management

### 🌍 Internationalization
- Built-in GetX translations
- `LanguageController` for language management
- Support for English and Vietnamese
- Persistent language selection
- Real-time language switching

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ^3.7.2
- Dart SDK
- Android Studio / VS Code
- iOS development tools (for iOS builds)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate assets (after adding assets):
   ```bash
   dart run flutter_gen_runner
   ```

4. Run the app:
   ```bash
   # Development
   flutter run
   
   # With specific route
   flutter run --dart-define=INITIAL_ROUTE=/splash
   ```

## 📱 Implemented Screens

### 🎯 Splash Screen (`/splash`)
- App logo and loading indicator
- Automatic navigation to login
- Localized welcome message

### 🔐 Login Screen (`/login`)
- Email/password form
- Language toggle button
- Navigation to register and home
- Form validation ready

### 📝 Register Screen (`/register`)
- Registration form with validation
- Password confirmation
- Navigation back to login

### 🏠 Home Screen (`/home`)
- Welcome message
- Language display and toggle
- Navigation to profile and settings
- Reactive language updates

### 👤 Profile Screen (`/profile`)
- User profile display
- Localized content

### ⚙️ Settings Screen (`/settings`)
- Language selection interface
- Visual language indicators
- Persistent language settings

## 🔧 GetX Usage Examples

### Navigation
```dart
// Basic navigation
Get.toNamed(Routes.home);
Get.offNamed(Routes.login);
Get.offAllNamed(Routes.splash);

// With arguments
Get.toNamed(Routes.profile, arguments: {'userId': 123});
```

### State Management
```dart
class HomeController extends BaseController {
  final _counter = 0.obs;
  int get counter => _counter.value;
  
  void increment() => _counter.value++;
}

// In UI
Obx(() => Text('${controller.counter}'))
```

### Multilanguage
```dart
// In UI
Text('welcome'.tr)
Text('login'.tr)

// Change language
final langController = Get.find<LanguageController>();
await langController.changeLanguage('vi');
```

### Dependency Injection
```dart
class FeatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FeatureController());
  }
}
```

## 📦 Available Commands

### Code Generation
```bash
# Generate JSON serialization
flutter packages pub run build_runner build --delete-conflicting-outputs

# Generate assets
dart run flutter_gen_runner
```

### Build Commands
```bash
# Build APK
flutter build apk --flavor dev
flutter build apk --flavor production

# Build iOS
flutter build ios --flavor dev
flutter build ios --flavor production
```

### GetX Commands
```bash
# Run with specific initial route
flutter run --dart-define=INITIAL_ROUTE=/login

# Run with language
flutter run --dart-define=INITIAL_LANGUAGE=vi
```

## 🔧 Development Guidelines

### Adding New Features with GetX

1. Create feature folder in `lib/pages/[feature_name]/`
2. Follow the GetX structure:
   ```
   pages/[feature_name]/
   ├── bindings/        # GetX Bindings
   │   └── feature_binding.dart
   ├── entities/        # Data models
   ├── presentation/    # UI layer
   │   ├── controller/  # GetxController
   │   ├── view/       # UI screens
   │   └── widgets/    # Feature widgets
   └── repository/     # Data layer
   ```

3. Add route to `app_pages.dart`:
   ```dart
   GetPage(
     name: Routes.newFeature,
     page: () => NewFeatureScreen(),
     binding: NewFeatureBinding(),
   ),
   ```

### Base Classes Usage

#### Controller
```dart
class MyController extends BaseController<MyArguments> {
  @override
  void onInit() {
    super.onInit();
    // Initialize data
  }
  
  @override
  void onError(String message) {
    // Handle errors
  }
}
```

#### Reactive UI
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyController>(
      builder: (controller) => Scaffold(
        body: Obx(() {
          if (controller.isLoading) {
            return CircularProgressIndicator();
          }
          return YourContent();
        }),
      ),
    );
  }
}
```

## 🌍 Multilanguage Setup

### Adding New Languages

1. Update `AppTranslations` in `my_app.dart`:
   ```dart
   'fr_FR': {
     'welcome': 'Bienvenue',
     'login': 'Connexion',
     // ... more translations
   },
   ```

2. Add to supported locales:
   ```dart
   supportedLocales: const [
     Locale('en', 'US'),
     Locale('vi', 'VN'),
     Locale('fr', 'FR'), // New language
   ],
   ```

3. Update `LanguageController` if needed.

### Using Translations
```dart
// Simple translation
Text('key'.tr)

// With parameters
Text('welcome_user'.trParams({'name': userName}))

// Pluralization
Text('items_count'.trPlural('item', itemCount))
```

## 🎯 Features Ready to Implement

- ✅ Authentication system (UI ready)
- ✅ API integration with Dio
- ✅ Local storage with SharedPreferences
- ✅ Image handling and caching
- ✅ Localization support (English/Vietnamese)
- ✅ Theme management (structure ready)
- ✅ Error handling with GetX
- ✅ Loading states with reactive programming

## 🚀 Next Steps

1. Implement actual authentication logic
2. Add API client implementation
3. Create custom widgets and themes
4. Add more languages
5. Implement data persistence
6. Add unit tests for GetX controllers

## 📚 Documentation

- [GetX Implementation Guide](./GETX_IMPLEMENTATION.md) - Detailed GetX usage
- [Quick Start Guide](./QUICK_START.md) - Development setup

## 📄 License

This project is private and confidential.

---

## 🎉 GetX Implementation Complete!

✅ **Routing**: Declarative navigation with GetX  
✅ **State Management**: Reactive programming with Rx  
✅ **Dependency Injection**: Bindings pattern  
✅ **Multilanguage**: English/Vietnamese support  
✅ **Base Architecture**: Ready for feature development  

**Ready to build amazing features!** 🚀
