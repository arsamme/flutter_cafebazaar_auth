import 'dart:async';

import 'package:cafebazaar_auth/src/cafebazaar_account.dart';
import 'package:cafebazaar_auth/src/cafebazaar_update_info.dart';
import 'package:flutter/services.dart';
export 'package:cafebazaar_auth/src/cafebazaar_account.dart';
export 'package:cafebazaar_auth/src/cafebazaar_update_info.dart';

class CafeBazaarAuth {
  static const MethodChannel _channel =
      const MethodChannel('ars_cafebazaar_auth/method_ch');

  /// To check if bazaar is installed on device or not, returns bool
  static Future<bool?> get isBazaarInstalledOnDevice =>
      _channel.invokeMethod("isBazaarInstalledOnDevice");

  /// To check if bazaar needs to update, to support auth or storage
  static Future<CafeBazaarUpdateInfo> get isNeededToUpdateBazaar async {
    var updateInfo = await (_channel
        .invokeMapMethod<String, dynamic>("isNeededToUpdateBazaar") as FutureOr<Map<String, dynamic>>);
    return CafeBazaarUpdateInfo(updateInfo["needToUpdateForAuth"],
        updateInfo["needToUpdateForStorage"]);
  }

  /// Shows a view to install bazaar app
  static Future<void> showInstallBazaarView() {
    return _channel.invokeMethod("showInstallBazaarView");
  }

  /// Shows a view to update bazaar app
  static Future<void> showUpdateBazaarView() {
    return _channel.invokeMethod("showUpdateBazaarView");
  }

  /// Sign in with bazaar
  static Future<CafeBazaarAccount?> signIn() async {
    var bazaarAccount =
        await _channel.invokeMapMethod<String, dynamic>("signIn");
    return bazaarAccount == null
        ? null
        : CafeBazaarAccount(accountID: bazaarAccount["accountId"]);
  }

  /// Get signed in account
  static Future<CafeBazaarAccount?> get lastSignedInAccount async {
    Map<String, dynamic>? bazaarAccount = await _channel
        .invokeMapMethod<String, dynamic>("getLastSignedInAccount");
    return bazaarAccount == null
        ? null
        : CafeBazaarAccount(accountID: bazaarAccount["accountId"]);
  }

  /// Save data
  static Future<String?> saveDsaveData(String data) =>
      _channel.invokeMethod("saveData", {"data": data});

  /// Get saved data
  static Future<String?> get savedData => _channel.invokeMethod("getSavedData");
}
