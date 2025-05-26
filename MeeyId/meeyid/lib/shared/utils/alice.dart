import 'dart:convert';
import 'package:flutter/material.dart';

// Temporary Alice implementation - will be replaced with actual alice package
class AliceUtils {
  static final _singleton = AliceUtils._internal();

  factory AliceUtils() {
    return _singleton;
  }

  AliceUtils._internal() {
    _initAlice();
  }

  Alice? alice;

  GlobalKey<NavigatorState>? get getNavigatorKey => alice?.getNavigatorKey();

  void _initAlice() {
    // For now, we'll create a mock Alice
    // In production, use: alice = Alice(showInspectorOnShake: true, maxCallsCount: 10000, showNotification: false);
    alice = null; // Temporarily disabled
  }

  void addLogSocketEvent({
    required String channel,
    required Map<String, dynamic> data,
    required bool isSend,
  }) {
    // alice?.addLog(AliceLog(
    //   message: '-----------------------------------\n${!isSend ? 'CHANNEL_RECEIVER' : 'CHANNEL_EMIT'} : =====> $channel <=====\n\n DATA: ${_getPrettyJSONString(data)}\n'
    // ));
    debugPrint('Socket Event: $channel - ${_getPrettyJSONString(data)}');
  }

  String _getPrettyJSONString(jsonObject) {
    const encoder = JsonEncoder.withIndent("     ");
    return encoder.convert(jsonObject);
  }
}

// Mock Alice class - replace with actual alice package
class Alice {
  Alice({
    bool showInspectorOnShake = true,
    int maxCallsCount = 10000,
    bool showNotification = false,
  });

  GlobalKey<NavigatorState>? getNavigatorKey() => null;

  dynamic getDioInterceptor() => null;

  void addLog(dynamic log) {}
}
