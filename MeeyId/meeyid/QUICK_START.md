# MeeyId - Quick Start Guide 🚀

## 📋 Prerequisites

- Flutter SDK ^3.7.2
- Dart SDK
- Android Studio / VS Code
- Git

## ⚡ Quick Setup

### 1. Clone & Install
```bash
git clone <repository-url>
cd MeeyId/meeyid
flutter pub get
```

### 2. Run the App
```bash
# Development
flutter run

# With flavor (when configured)
flutter run --flavor dev
```

### 3. Generate Assets (when needed)
```bash
dart run flutter_gen_runner
```

## 🏗️ Architecture Overview

```
lib/
├── app_config/     # App initialization
├── base/          # Base classes
├── binding/       # Dependency injection
├── constants/     # App constants
├── pages/         # Feature modules
├── routes/        # Navigation
├── shared/        # Utilities
└── main.dart      # Entry point
```

## 🔧 Adding New Features

### 1. Create Feature Module
```bash
mkdir -p lib/pages/[feature_name]/{bindings,entities,presentation/{controller,view,widgets},repository}
```

### 2. Feature Structure
```
pages/[feature_name]/
├── bindings/
│   └── [feature]_binding.dart
├── entities/
│   └── [feature]_model.dart
├── presentation/
│   ├── controller/
│   │   └── [feature]_controller.dart
│   ├── view/
│   │   └── [feature]_screen.dart
│   └── widgets/
│       └── [feature]_widget.dart
└── repository/
    └── [feature]_repository.dart
```

### 3. Add Route
```dart
// lib/routes/app_routes.dart
static const newFeature = '/new-feature';

// lib/routes/app_pages.dart
GetPage(
  name: Routes.newFeature,
  page: () => NewFeatureScreen(),
  binding: NewFeatureBinding(),
),
```

## 📱 Common Commands

```bash
# Install dependencies
flutter pub get

# Run code generation
flutter packages pub run build_runner build --delete-conflicting-outputs

# Generate assets
dart run flutter_gen_runner

# Analyze code
flutter analyze

# Run tests
flutter test

# Build APK
flutter build apk --flavor dev

# Build iOS
flutter build ios --flavor dev
```

## 🎯 Development Guidelines

### Base Classes Usage

#### Controller
```dart
class MyController extends BaseController<MyArguments> {
  @override
  void onError(String message) {
    // Handle errors
  }
  
  @override
  void onListenEvent(dynamic event) {
    // Handle events
  }
}
```

#### Widget
```dart
class MyScreen extends BaseWidget {
  @override
  Widget buildBody(BuildContext context) {
    return Container(
      child: Text('My Screen'),
    );
  }
}
```

### Constants Usage
```dart
// App constants
AppConstants.appName
AppConstants.defaultPadding

// API constants
ApiConstants.baseUrl
ApiConstants.login
```

## 🔐 Environment Configuration

### Development
```bash
# assets/env/.env.dev
BASE_URL=https://dev-api.meeyid.com
DEBUG=true
```

### Production
```bash
# assets/env/.env.production
BASE_URL=https://api.meeyid.com
DEBUG=false
```

## 🎨 Assets Management

### Adding Assets
1. Add files to appropriate folders:
   ```
   assets/
   ├── images/     # PNG, JPG files
   ├── icons/      # Icon files
   ├── fonts/      # Font files
   └── json/       # JSON data
   ```

2. Generate asset classes:
   ```bash
   dart run flutter_gen_runner
   ```

3. Use in code:
   ```dart
   Assets.images.logo.image()
   Assets.icons.home.svg()
   ```

## 🚀 Ready to Code!

Your MeeyId project is now ready with:
- ✅ Clean Architecture setup
- ✅ GetX pattern ready
- ✅ All core dependencies installed
- ✅ Base classes implemented
- ✅ Environment configuration
- ✅ Asset management ready
- ✅ Code quality rules configured

Start building your features! 🎉 