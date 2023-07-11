import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late SharedPreferences? _prefs;
  SharedPreferencesService._(); // Private constructor

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> clearLocalStorage() async {
    _prefs?.clear();
  }

  static Future<void> setStringPreference(
    String email,
    String password,
  ) async {
    await _prefs?.setString('email', email);
    await _prefs?.setString('password', password);
  }

  static Future<String> getEmailPreference() async {
    return _prefs!.getString('email') ?? '';
  }

  static Future<String> getPasswordPreference() async {
    return _prefs!.getString('password') ?? '';
  }

  static Future<bool> saveImage(List<int> imageBytes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String base64Image = base64Encode(imageBytes);
    return prefs.setString("image", base64Image);
  }

  static Future<Image> getImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Uint8List bytes = base64Decode(prefs.getString("image") ?? '');
    return Image.memory(bytes);
  }
}
