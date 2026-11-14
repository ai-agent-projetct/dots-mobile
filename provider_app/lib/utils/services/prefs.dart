import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const String isLogin = 'isLogin';
  static const String roleId = 'roleId';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String subscriptionStatus = 'lastName';

  static const String email = 'Email';
  static const String profileImage = 'profileImage';
  static const String gst = 'gst';
  static const String address = 'address';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';

  static const String userId = 'userId';
  static const String mobile = 'mobile';
  static const String token = 'token';
  static const String fcmToken = 'fcmToken';
  static const String appLanguage = 'appLanguage';
  static const String lastKnownLat = 'lastKnownLat';
  static const String lastKnownLong = 'lastKnownLong';

  static final Prefs _preference = Prefs._internal();

  factory Prefs() {
    return _preference;
  }

  Prefs._internal();

  static Prefs get shared => _preference;
  static SharedPreferences? _pref;

  Future<SharedPreferences?> instance() async {
    if (_pref != null) return _pref;
    await SharedPreferences.getInstance()
        .then((value) {
          _pref = value;
        })
        .catchError((onErr) {
          _pref = null;
        });

    return _pref;
  }

  String? getString(String key) {
    return _pref?.getString(key);
  }

  LatLng getLastKnownLatLng() {
    return LatLng(
      _pref?.getDouble(Prefs.lastKnownLat) ?? 0,
      _pref?.getDouble(Prefs.lastKnownLong) ?? 0,
    );
  }

  Future<bool> setLasKnowLatLng(double lat, double lng) async {
    await _pref!.setDouble(Prefs.lastKnownLat, lat);
    await _pref!.setDouble(Prefs.lastKnownLong, lng);
    return true;
  }

  Future<bool> setString(String key, String value) {
    return _pref!.setString(key, value);
  }

  int? getInt(String key) {
    return _pref?.getInt(key);
  }

  // Future<void> setConfigModel(ConfigModel configModel) async {
  //   Map<String, dynamic> json = configModel.toJson();
  //   String user = jsonEncode(json);
  //   _pref?.setString(config, user);
  // }

  // ConfigModel getConfigModel() {
  //   var data = _pref?.getString(config).toString();
  //   Map<String, dynamic> userMap = json.decode(data!);
  //   return ConfigModel.fromJson(userMap);
  // }

  Future<bool> setInt(String key, int value) {
    return _pref!.setInt(key, value);
  }

  bool getBool(String key) {
    if (_pref == null) return false;
    return _pref?.getBool(key) ?? false;
  }

  Future<bool> setBool(String key, bool value) {
    return _pref!.setBool(key, value);
  }

  double? getDouble(String key) {
    return _pref?.getDouble(key);
  }

  Future<bool> setDouble(String key, double value) {
    return _pref!.setDouble(key, value);
  }

  Future<bool?> clearPrefs() async {
    return await _pref?.clear();
  }

  Future<void> clearIndividualSharedPref(String key) async {
    if (_pref == null) return;
    if (_pref!.containsKey(key)) {
      await _pref!.remove(key);
      debugPrint('Stored value cleared in $key');
    } else {
      debugPrint('$key does not exist');
    }
  }
}
