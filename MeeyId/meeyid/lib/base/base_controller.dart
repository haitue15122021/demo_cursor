import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

abstract class ErrorHandle {
  void onError(String message);
  void onListenEvent(dynamic event);
}

abstract class BaseController<T> extends GetxController
    with WidgetsBindingObserver
    implements ErrorHandle {
  T? arguments = Get.arguments == null ? null : Get.arguments as T;

  // Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // Error state
  final _errorMessage = Rxn<String>();
  String? get errorMessage => _errorMessage.value;

  // Composite subscription for RxDart
  final compositeSubscription = CompositeSubscription();
  final eventBus = BehaviorSubject<Object>();

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    _listenEventBus();
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    compositeSubscription.dispose();
    eventBus.close();
    super.onClose();
  }

  void showLoading() {
    _isLoading.value = true;
  }

  void hideLoading() {
    _isLoading.value = false;
  }

  void setError(String? error) {
    _errorMessage.value = error;
  }

  void clearError() {
    _errorMessage.value = null;
  }

  @override
  void onError(String message) {
    setError(message);
    hideLoading();
  }

  @override
  void onListenEvent(dynamic event) {
    // Override in subclasses to handle specific events
  }

  /// Listen to event bus
  void _listenEventBus() {
    eventBus
        .listen((event) {
          if (isClosed) return;
          onListenEvent(event);
        })
        .addTo(compositeSubscription);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.paused:
        onPause();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.hidden:
        onHidden();
        break;
    }
  }

  void onResume() {}
  void onPause() {}
  void onDetached() {}
  void onInactive() {}
  void onHidden() {}

  // Navigation helpers
  void back() => Get.back();
  void toNamed(String route, {dynamic arguments}) =>
      Get.toNamed(route, arguments: arguments);
  void offNamed(String route, {dynamic arguments}) =>
      Get.offNamed(route, arguments: arguments);
  void offAllNamed(String route, {dynamic arguments}) =>
      Get.offAllNamed(route, arguments: arguments);
}
