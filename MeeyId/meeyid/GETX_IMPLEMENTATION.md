# GetX Implementation Guide - MeeyId

## 📋 Tổng quan

Dự án MeeyId đã được triển khai đầy đủ với GetX pattern **giống hệt hoangmaichung-dev** bao gồm:
- ✅ **Routing**: Navigation với GetX
- ✅ **State Management**: Reactive programming với Rx
- ✅ **Dependency Injection**: Bindings pattern giống hoangmaichung-dev
- ✅ **Multilanguage**: Internationalization với GetX
- ✅ **API Client**: Dio với interceptors giống hoangmaichung-dev
- ✅ **Local Storage**: LocalStorage pattern giống hoangmaichung-dev
- ✅ **MainBinding**: Sử dụng GetX Bindings với initialBinding

## 🏗️ Kiến trúc GetX (Giống hoangmaichung-dev)

### 1. Base Controller
```dart
// lib/base/base_controller.dart
abstract class BaseController<T> extends GetxController {
  T? arguments = Get.arguments;
  
  // Reactive states
  final _isLoading = false.obs;
  final _errorMessage = Rxn<String>();
  
  // Navigation helpers
  void back() => Get.back();
  void toNamed(String route, {dynamic arguments}) => Get.toNamed(route, arguments: arguments);
}
```

### 2. MainBinding (Sử dụng GetX Bindings)
```dart
// lib/binding/main_binding.dart
import 'package:get/get.dart';

class MainBinding extends Bindings {  // ✅ Kế thừa từ GetX Bindings
  @override
  void dependencies() {
    // Core storage - giống hoangmaichung-dev
    Get.lazyPut<LocalStorage>(() => LocalStorageImpl(), fenix: true);
    
    // API clients - giống hoangmaichung-dev
    Get.lazyPut(() => ApiClient(Dio(), Get.find()), fenix: true);
    
    // Global reactive variables - giống hoangmaichung-dev
    Get.put(Rxn<Map<String, dynamic>>(), tag: 'setting_info');
    Get.put(Rxn<Map<String, dynamic>>(), tag: 'user_info');
    Get.lazyPut(() => RxBool(false), fenix: true, tag: 'is_loading');
    
    // Language controller
    Get.lazyPut(() => LanguageController(), fenix: true);
    
    // Global controllers - giống hoangmaichung-dev
    Get.lazyPut(() => AppController(), fenix: true);
  }
}
```

### 3. MyApp Configuration (Với initialBinding)
```dart
// lib/app_config/my_app.dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      
      // ✅ GetX Binding - Initialize MainBinding
      initialBinding: MainBinding(),
      
      // GetX Routing
      initialRoute: initRoute ?? AppPages.initial,
      getPages: AppPages.routes,
      
      // Localization with GetX
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      translations: AppTranslations(),
      
      // Theme configuration...
    );
  }
}
```

### 4. LocalStorage (Giống hoangmaichung-dev)
```dart
// lib/shared/data_manager/local_storage.dart
abstract class LocalStorage {
  Future<T> get<T>(String key);
  Future<bool> validateKey(String key);
  Future<bool> remove(String key);
  Future<bool> clearSession();
  Future<void> reload();
  Future<dynamic> save(String key, dynamic value);
}

class LocalStorageImpl extends LocalStorage {
  // Implementation giống hệt hoangmaichung-dev
}
```

### 5. ApiClient (Giống hoangmaichung-dev)
```dart
// lib/shared/api_client/api_client.dart
class ApiClient {
  final LocalStorage localStorage;
  final Dio dio;
  late DioInterceptors _interceptors;

  ApiClient(this.dio, this.localStorage) {
    // Configuration giống hoangmaichung-dev
    dio.options.baseUrl = "https://api.meeyid.com/api/";
    dio.options.connectTimeout = const Duration(minutes: 5);
    dio.options.receiveTimeout = const Duration(minutes: 5);
    
    // Interceptors giống hoangmaichung-dev
    _interceptors = DioInterceptors(localStorage);
    dio.interceptors.add(_interceptors);
  }
}
```

### 6. AppController (Giống hoangmaichung-dev)
```dart
// lib/pages/app_root/presentation/controller/app_controller.dart
class AppController extends BaseController {
  // Global reactive variables
  final settingInfoRxn = Get.find<Rxn<Map<String, dynamic>>>(tag: 'setting_info');
  final userInfoRxn = Get.find<Rxn<Map<String, dynamic>>>(tag: 'user_info');
  final localStorage = Get.find<LocalStorage>();
  
  Future<bool> checkLoggedIn() async {
    final token = await localStorage.get<String?>(AppConstants.tokenKey);
    return (token ?? "").isNotEmpty;
  }
  
  Future<void> logout() async {
    await localStorage.clearSession();
    userInfoRxn.value = null;
  }
}
```

## 🔄 So sánh với hoangmaichung-dev

### ✅ Giống hệt hoangmaichung-dev:

1. **MainBinding Structure**:
   ```dart
   // hoangmaichung-dev
   class MainBinding extends Bindings {  // ✅ Sử dụng GetX Bindings
     @override
     void dependencies() {
       Get.lazyPut<LocalStorage>(() => LocalStorageImpl(), fenix: true);
       Get.lazyPut(() => ApiClient(Dio(), Get.find()), fenix: true);
       Get.put(Rxn<SettingInfoModel>());
       Get.put(Rxn<UserInfoRootModel>());
       Get.lazyPut(() => AppController(Get.find()), fenix: true);
     }
   }
   
   // MeeyId (tương tự)
   class MainBinding extends Bindings {  // ✅ Sử dụng GetX Bindings
     @override
     void dependencies() {
       Get.lazyPut<LocalStorage>(() => LocalStorageImpl(), fenix: true);
       Get.lazyPut(() => ApiClient(Dio(), Get.find()), fenix: true);
       Get.put(Rxn<Map<String, dynamic>>(), tag: 'setting_info');
       Get.put(Rxn<Map<String, dynamic>>(), tag: 'user_info');
       Get.lazyPut(() => AppController(), fenix: true);
     }
   }
   ```

2. **GetMaterialApp Configuration**:
   ```dart
   // Cả 2 projects đều sử dụng
   GetMaterialApp(
     initialBinding: MainBinding(),  // ✅ Khởi tạo dependencies ngay từ đầu
     // ... other configurations
   )
   ```

3. **LocalStorage Implementation**: Hoàn toàn giống
4. **ApiClient Pattern**: Giống với Dio + Interceptors
5. **AppController Pattern**: Giống với global state management
6. **Dependency Injection**: Cùng pattern với `fenix: true`

### 🔧 Khác biệt nhỏ:

1. **Model Types**: 
   - hoangmaichung-dev: `SettingInfoModel`, `UserInfoRootModel`
   - MeeyId: `Map<String, dynamic>` với tags (để flexible hơn)

2. **API Endpoints**: Khác base URL và endpoints
3. **Business Logic**: Khác theo domain của từng app

## 🚀 Cách sử dụng (Giống hoangmaichung-dev)

### Dependency Injection trong Feature Bindings
```dart
// Trong feature binding
class FeatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IFeatureRepository>(() => FeatureRepository(Get.find()), fenix: true);
    Get.lazyPut(() => FeatureController(Get.find()), fenix: true);
  }
}
```

### LocalStorage Usage
```dart
final localStorage = Get.find<LocalStorage>();
await localStorage.save('key', 'value');
final value = await localStorage.get<String>('key');
await localStorage.remove('key');
await localStorage.clearSession();
```

### ApiClient Usage
```dart
final apiClient = Get.find<ApiClient>();
final response = await apiClient.get('/endpoint');
final postResponse = await apiClient.post('/endpoint', data: {...});
```

### Global State Access
```dart
final settingInfo = Get.find<Rxn<Map<String, dynamic>>>(tag: 'setting_info');
final userInfo = Get.find<Rxn<Map<String, dynamic>>>(tag: 'user_info');
final isLoading = Get.find<RxBool>(tag: 'is_loading');
```

## 📱 Architecture Benefits

### 1. **Consistent Pattern**: Giống hệt hoangmaichung-dev
- Dễ maintain và scale
- Team đã quen thuộc với pattern
- Code reusability cao

### 2. **Proper GetX Integration**:
- ✅ Sử dụng `Bindings` của GetX thay vì tự tạo abstract class
- ✅ Sử dụng `initialBinding` trong GetMaterialApp
- ✅ Dependencies được khởi tạo ngay từ đầu app lifecycle

### 3. **Global State Management**:
- Centralized user info
- Centralized settings
- Centralized loading states

### 4. **Dependency Injection**:
- Lazy loading với `fenix: true`
- Automatic cleanup
- Easy testing và mocking

### 5. **API Layer**:
- Consistent error handling
- Automatic token injection
- Request/response logging
- CURL logging for debugging

## 🔧 Development Workflow

### 1. Thêm Feature mới:
```dart
// 1. Tạo Repository
abstract class INewFeatureRepository {
  Future<Response> getData();
}

class NewFeatureRepository implements INewFeatureRepository {
  final ApiClient apiClient;
  NewFeatureRepository(this.apiClient);
  
  @override
  Future<Response> getData() async {
    return await apiClient.get('/new-feature');
  }
}

// 2. Tạo Controller
class NewFeatureController extends BaseController {
  final INewFeatureRepository repository;
  NewFeatureController(this.repository);
  
  Future<void> loadData() async {
    showLoading();
    try {
      final response = await repository.getData();
      // Process data
    } catch (e) {
      onError(e.toString());
    } finally {
      hideLoading();
    }
  }
}

// 3. Tạo Binding
class NewFeatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<INewFeatureRepository>(() => NewFeatureRepository(Get.find()));
    Get.lazyPut(() => NewFeatureController(Get.find()));
  }
}

// 4. Thêm vào Routes
GetPage(
  name: '/new-feature',
  page: () => NewFeatureScreen(),
  binding: NewFeatureBinding(),
),
```

## ✅ **Checklist Implementation**

- [x] **MainBinding extends GetX Bindings** (không tự tạo abstract class)
- [x] **initialBinding trong GetMaterialApp** 
- [x] **LocalStorage pattern giống hoangmaichung-dev**
- [x] **ApiClient với Dio + Interceptors**
- [x] **AppController với global state management**
- [x] **Dependency injection với fenix: true**
- [x] **Zero linter errors**
- [x] **Ready for development**

## 🎯 Kết luận

MeeyId đã được triển khai **hoàn toàn đúng** với GetX pattern của hoangmaichung-dev:

- ✅ **MainBinding**: Kế thừa từ GetX `Bindings` (không tự tạo abstract class)
- ✅ **initialBinding**: Được khai báo trong `GetMaterialApp`
- ✅ **LocalStorage**: Cùng abstract class và implementation  
- ✅ **ApiClient**: Cùng pattern với Dio và interceptors
- ✅ **AppController**: Cùng global state management
- ✅ **Dependency Injection**: Cùng lazy loading pattern
- ✅ **Architecture**: Cùng Clean Architecture + GetX

**Lợi ích**:
- Team không cần học pattern mới
- Code có thể reuse giữa 2 projects
- Maintenance dễ dàng
- Scaling theo cùng một hướng
- **Đúng chuẩn GetX framework**

**Dự án sẵn sàng để phát triển với pattern đã proven và đúng chuẩn GetX!** 🚀 