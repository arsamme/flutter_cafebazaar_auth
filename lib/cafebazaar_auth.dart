import 'dart:async';

import 'package:cafebazaar_auth/src/bazaar_account.dart';
import 'package:cafebazaar_auth/src/bazaar_update_info.dart';
import 'package:flutter/services.dart';

class CafeBazaarAuth {
  static const MethodChannel _channel =
      const MethodChannel('ars_cafebazaar_auth/method_ch');

  Future<bool> isBazaarInstalledOnDevice() =>
      _channel.invokeMethod("isBazaarInstalledOnDevice");

  Future<BazaarUpdateInfo> isNeededToUpdateBazaar() async {
    var updateInfo = await _channel
        .invokeMapMethod<String, dynamic>("isNeededToUpdateBazaar");
    return BazaarUpdateInfo(updateInfo["needToUpdateForAuth"],
        updateInfo["needToUpdateForStorage"]);
  }

  Future<void> showInstallBazaarView() {
    return _channel.invokeMethod("showInstallBazaarView");
  }

  Future<void> showUpdateBazaarView() {
    return _channel.invokeMethod("showUpdateBazaarView");
  }

  Future<BazaarAccount> startSignIn() async {
    var bazaarAccount =
        await _channel.invokeMapMethod<String, dynamic>("startSignIn");
    return bazaarAccount == null
        ? null
        : BazaarAccount(bazaarAccount["accountId"]);
  }

  Future<BazaarAccount> getLastSignedInAccount() async {
    var bazaarAccount = await _channel
        .invokeMapMethod<String, dynamic>("getLastSignedInAccount");
    return bazaarAccount == null
        ? null
        : BazaarAccount(bazaarAccount["accountId"]);
  }

  Future<String> saveData(String data) =>
      _channel.invokeMethod("saveData", {"data": data});

  Future<String> getSavedData(String data) =>
      _channel.invokeMethod("getSavedData");
}
