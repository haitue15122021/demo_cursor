import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../base/index.dart';
import '../../../../shared/index.dart';
import '../../../../constants/index.dart';

/// Class này để xử lý những logic dùng cho toàn app và sẽ được register ở main binding
class AppController extends BaseController {
  AppController();

  // Global reactive variables
  final settingInfoRxn = Get.find<Rxn<Map<String, dynamic>>>(
    tag: 'setting_info',
  );
  final userInfoRxn = Get.find<Rxn<Map<String, dynamic>>>(tag: 'user_info');
  final localStorage = Get.find<LocalStorage>();

  Future<bool> checkEmailValidated({required String email}) async {
    showLoading();
    // TODO: Implement email validation API call
    // final request = CheckEmailRequestEntity(email: email);
    // final res = await appRepository.checkEmailRegister(request).onDioCatchError(erb);
    // final emailExisted = res?.response?.isExist ?? false;
    hideLoading();
    return false; // Temporary return
  }

  Future<bool> checkLoggedIn() async {
    final token = await localStorage.get<String?>(AppConstants.tokenKey);
    final isLoggedIn = (token ?? "").isNotEmpty;
    return isLoggedIn;
  }

  Future<void> logout() async {
    showLoading();
    // TODO: Implement logout API call
    // final deviceId = await DeviceUtils.getId();
    // final platform = DeviceUtils.getPlatform();
    // final request = LogoutRequest(device: deviceId ?? "", platform: platform);
    // await appRepository.logout(request).onDioCatchError(erb);
    hideLoading();
    await localStorage.clearSession();
    userInfoRxn.value = null;
  }

  /// Lấy thông tin setting
  Future<void> getSettingInfo() async {
    // TODO: Implement get setting info API call
    // final settingInfo = await appRepository.getSettingInfo().onDioCatchError(erb);
    // settingInfoRxn.value = settingInfo?.response;
  }

  /// Lấy thông tin user
  Future<void> getUserInfo() async {
    // TODO: Implement get user info API call
    // final userInfo = await appRepository.getUserInfo().onDioCatchError(erb);
    // userInfoRxn.value = userInfo?.response;
  }

  @override
  void onError(String message) {
    super.onError(message);
    // TODO: Show error message with FlushBar or SnackBar
    debugPrint('AppController Error: $message');
  }
}
