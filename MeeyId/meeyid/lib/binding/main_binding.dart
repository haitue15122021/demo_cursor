import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../shared/index.dart';
import '../pages/index.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Core storage
    Get.lazyPut<LocalStorage>(() => LocalStorageImpl(), fenix: true);

    // API clients
    Get.lazyPut(() => ApiClient(Dio(), Get.find()), fenix: true);

    // Global reactive variables - similar to hoangmaichung-dev
    Get.put(
      Rxn<Map<String, dynamic>>(),
      tag: 'setting_info',
    ); // SettingInfoModel equivalent
    Get.put(
      Rxn<Map<String, dynamic>>(),
      tag: 'user_info',
    ); // UserInfoRootModel equivalent
    Get.lazyPut(
      () => RxBool(false),
      fenix: true,
      tag: 'is_loading',
    ); // Global loading state

    // Language controller
    Get.lazyPut(() => LanguageController(), fenix: true);

    // Global controllers - giống hoangmaichung-dev
    Get.lazyPut(() => AppController(), fenix: true);

    debugPrint('MainBinding: Dependencies initialized');
  }
}
