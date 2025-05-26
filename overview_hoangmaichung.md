# Overview Dự Án HoangMaiChung-Dev

## 📋 Thông Tin Tổng Quan

- **Tên dự án**: HoangMaiChung-Dev (Base Flutter Project)
- **Platform**: Flutter (Cross-platform: Android, iOS, Web)
- **Phiên bản**: 1.12.0+80
- **SDK Flutter**: >=2.17.1 <3.0.0
- **Kiến trúc**: Clean Architecture + GetX Pattern
- **Ngôn ngữ**: Dart

## 🏗️ Kiến Trúc Dự Án

### 1. Kiến Trúc Tổng Thể
Dự án sử dụng **Clean Architecture** kết hợp với **GetX Pattern** để tạo ra một kiến trúc có thể mở rộng và bảo trì dễ dàng:

```
lib/
├── app_config/          # Cấu hình ứng dụng
├── base/               # Base classes (Controller, Widget)
├── binding/            # Dependency Injection
├── constants/          # Hằng số
├── custom_view/        # Custom widgets
├── database/           # Local database
├── extension/          # Extension methods
├── gen/               # Generated files (assets, localization)
├── middlewares/        # Route middlewares
├── mixin/             # Mixins
├── pages/             # Feature modules
├── routes/            # Navigation routing
├── service/           # Services (Dialog, BottomSheet, etc.)
├── shared/            # Shared utilities
├── theme/             # Theme configuration
└── thirt_party/       # Custom third-party widgets
```

### 2. Kiến Trúc Module (Feature-based)
Mỗi feature được tổ chức theo cấu trúc:

```
pages/[feature_name]/
├── di/                # Dependency Injection
├── entities/          # Data models
├── presentation/      # UI Layer
│   ├── controller/    # Business logic (GetX Controllers)
│   ├── view/         # UI Screens
│   └── widgets/      # Feature-specific widgets
└── repository/       # Data layer
```

## 🛠️ Công Nghệ Lõi

### 1. State Management & Architecture
- **GetX (4.6.5)**: State management, dependency injection, routing
- **RxDart (0.27.7)**: Reactive programming extensions
- **Event Bus (2.0.0)**: Global event communication

### 2. Network & API
- **Dio (5.1.1)**: HTTP client cho REST API
- **Pretty Dio Logger (1.3.1)**: API logging
- **Socket.IO Client (1.0.2)**: Real-time communication
- **Web Socket Channel (2.4.0)**: WebSocket support

### 3. Local Storage & Database
- **Shared Preferences (2.0.18)**: Key-value storage
- **Path Provider (2.0.13)**: File system paths
- **Local Storage**: Custom implementation

### 4. JSON & Serialization
- **JSON Annotation (4.8.0)**: JSON serialization annotations
- **JSON Serializable (6.6.1)**: Code generation for JSON
- **Build Runner (2.3.3)**: Code generation tool
- **Copy With Extension (5.0.0)**: Immutable object copying

### 5. UI & Styling
- **Flutter ScreenUtil (5.6.0)**: Screen adaptation
- **Flutter SVG (2.0.2)**: SVG support
- **Cached Network Image (3.2.3)**: Image caching
- **Shimmer (2.0.0)**: Loading animations
- **Lottie (2.2.2)**: Animation support

### 6. Navigation & Routing
- **GetX Navigation**: Declarative routing
- **Custom Route Management**: Centralized route definitions

### 7. Localization
- **Flutter Localizations**: Built-in i18n support
- **GetX Localization**: Dynamic language switching
- **Custom Locale Management**: JSON-based translations

### 8. Firebase Integration
- **Firebase Core (2.13.0)**: Firebase initialization
- **Firebase Crashlytics (3.3.1)**: Crash reporting
- **Firebase Analytics (10.4.1)**: Analytics tracking
- **Firebase Remote Config (4.2.1)**: Remote configuration
- **Firebase Dynamic Links (5.3.1)**: Deep linking
- **FCM Config (3.5.1)**: Push notifications

### 9. Authentication & Security
- **Local Auth (2.1.5)**: Biometric authentication
- **Permission Handler (10.2.0)**: Runtime permissions
- **Device Info Plus (8.1.0)**: Device information

### 10. Media & Camera
- **Camera (0.10.3+2)**: Camera functionality
- **Image Picker (0.8.7)**: Image selection
- **Image Cropper (3.0.1)**: Image editing
- **Flutter Native Image (0.0.6+1)**: Image processing

## 🔧 Patterns & Best Practices

### 1. Base Classes
```dart
// Base Controller với error handling và lifecycle
abstract class BaseController<T> extends GetxController 
    with WidgetsBindingObserver implements ErrorHandle

// Base Widget cho consistent UI
abstract class BaseWidget extends StatelessWidget
```

### 2. Dependency Injection Pattern
```dart
class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy loading dependencies
    Get.lazyPut<LocalStorage>(() => LocalStorageImpl(), fenix: true);
    Get.lazyPut(() => ApiClient(Dio(), Get.find()), fenix: true);
  }
}
```

### 3. API Response Pattern
```dart
// Standardized API response structure
class BaseData<T> {
  final T? response;
  final MetaModel? meta;
}

class BaseListData<T> {
  final List<T>? response;
  final MetaModel? meta;
}
```

### 4. Error Handling Pattern
- Centralized error handling trong BaseController
- Custom error types và field validation
- Global error event bus

### 5. Environment Configuration
- Multi-environment support (dev, production)
- Environment-specific configurations
- Flavor-based builds

## 🚀 Development Tools & Automation

### 1. Code Generation
- **Flutter Gen**: Asset và font generation
- **Build Runner**: JSON serialization
- **Copy With Extension**: Immutable objects

### 2. Quality Assurance
- **Lint (2.0.1)**: Code analysis rules
- **Analysis Options**: Custom linting rules
- **Alice (0.3.2)**: Network debugging

### 3. Build & Deployment
- **Flutter Native Splash**: Splash screen generation
- **Flutter Launcher Icons**: App icon generation
- **Multi-flavor builds**: dev/production environments

### 4. Testing & Debugging
- **Device Preview (1.1.0)**: Multi-device testing
- **Flutter Test**: Unit testing framework

## 📱 Platform-Specific Features

### Android
- Custom splash screens
- Adaptive icons
- Flavor-based configurations
- Gradle build system

### iOS
- Custom launch screens
- App icons
- Xcode project configuration
- iOS-specific permissions

### Web
- Web-specific assets
- Progressive Web App support

## 🔄 Reusable Components

### 1. Custom Widgets
- Bottom navigation bar
- Custom buttons
- Pie charts
- Smooth page indicators
- Custom switches
- Camera components

### 2. Services
- Dialog service
- Bottom sheet service
- Flush bar notifications
- Loading overlays

### 3. Utilities
- Network utilities
- Date/time helpers
- Validation helpers
- Image processing utilities

## 📦 Asset Management

### Organized Asset Structure
```
assets/
├── fonts/           # Custom fonts
├── flags/           # Country flags
├── icons/           # App icons
├── images/          # Static images
├── json/            # JSON data files
├── locales/         # Translation files
├── env/             # Environment configs
├── gif/             # Animated images
├── app_icon/        # App launcher icons
└── splash/          # Splash screen assets
```

## 🌐 Internationalization

- JSON-based translation files
- Dynamic language switching
- RTL support ready
- Automated translation workflow

## 🔐 Security Features

- Biometric authentication
- Secure storage
- API token management
- Certificate pinning ready
- Crash reporting với privacy

## 📊 Analytics & Monitoring

- Firebase Analytics integration
- Crash reporting
- Performance monitoring
- Remote configuration
- A/B testing ready

## 🎯 Khuyến Nghị Tái Sử Dụng

### Core Components Có Thể Tái Sử Dụng:
1. **Base Architecture**: BaseController, BaseWidget patterns
2. **API Client**: Dio configuration với interceptors
3. **Error Handling**: Centralized error management
4. **Dependency Injection**: GetX binding pattern
5. **Navigation System**: Route management
6. **Localization System**: JSON-based i18n
7. **Theme System**: Consistent styling approach
8. **Asset Generation**: Flutter Gen workflow
9. **Environment Configuration**: Multi-flavor setup
10. **Firebase Integration**: Complete Firebase setup

### Setup Commands Quan Trọng:
```bash
# Code generation
flutter packages pub run build_runner build --delete-conflicting-outputs

# Asset generation
fluttergen -c pubspec.yaml

# Localization
get generate locales assets/locales

# Splash screen
flutter pub run flutter_native_splash:create

# App icons
flutter pub run flutter_launcher_icons

# Build commands
flutter build apk --flavor production
flutter build ios --flavor production
```

Kiến trúc này cung cấp một foundation mạnh mẽ và có thể mở rộng cho các dự án Flutter enterprise-level với khả năng tái sử dụng cao. 