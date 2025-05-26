import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:meeyid/index.dart';

class MyApp extends StatelessWidget {
  final String? initRoute;
  final String? flavor;
  final bool showLog;

  const MyApp({super.key, this.initRoute, this.flavor, this.showLog = false});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // GetX Binding - Initialize MainBinding
      initialBinding: MainBinding(),

      // GetX Routing
      initialRoute: initRoute ?? AppPages.initial,
      getPages: AppPages.routes,

      // Localization with GetX
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      translations: AppTranslations(),

      // Standard Flutter Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],

      // Theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      // Dark theme
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),

      // Theme mode reactive - will be enhanced later
      themeMode: ThemeMode.light,

      // Default transition
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),

      // Enable logging in debug mode
      enableLog: showLog,
    );
  }
}

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'app_name': 'MeeyId',
      'welcome': 'Welcome',
      'login': 'Login',
      'register': 'Register',
      'home': 'Home',
      'profile': 'Profile',
      'settings': 'Settings',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'dont_have_account': "Don't have an account?",
      'already_have_account': 'Already have an account?',
      'sign_up': 'Sign Up',
      'sign_in': 'Sign In',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'cancel': 'Cancel',
      'ok': 'OK',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'search': 'Search',
      'no_data': 'No data available',
      'try_again': 'Try again',
      'network_error': 'Network error. Please check your connection.',
      'something_went_wrong': 'Something went wrong. Please try again.',
    },
    'vi_VN': {
      'app_name': 'MeeyId',
      'welcome': 'Chào mừng',
      'login': 'Đăng nhập',
      'register': 'Đăng ký',
      'home': 'Trang chủ',
      'profile': 'Hồ sơ',
      'settings': 'Cài đặt',
      'logout': 'Đăng xuất',
      'email': 'Email',
      'password': 'Mật khẩu',
      'confirm_password': 'Xác nhận mật khẩu',
      'forgot_password': 'Quên mật khẩu?',
      'dont_have_account': 'Chưa có tài khoản?',
      'already_have_account': 'Đã có tài khoản?',
      'sign_up': 'Đăng ký',
      'sign_in': 'Đăng nhập',
      'loading': 'Đang tải...',
      'error': 'Lỗi',
      'success': 'Thành công',
      'cancel': 'Hủy',
      'ok': 'Đồng ý',
      'save': 'Lưu',
      'delete': 'Xóa',
      'edit': 'Chỉnh sửa',
      'search': 'Tìm kiếm',
      'no_data': 'Không có dữ liệu',
      'try_again': 'Thử lại',
      'network_error': 'Lỗi mạng. Vui lòng kiểm tra kết nối.',
      'something_went_wrong': 'Có lỗi xảy ra. Vui lòng thử lại.',
    },
  };
}
