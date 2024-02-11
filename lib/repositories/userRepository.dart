import 'dart:convert';
import 'dart:typed_data';

import 'package:berry_buddy/constants.dart';
import 'package:dio/adapter_browser.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  BaseOptions options = BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      });

  Dio dio() {
    final dio = Dio(options);

    var adapter = BrowserHttpClientAdapter();
    adapter.withCredentials = true;
    dio.httpClientAdapter = adapter;

    return dio;
  }

  Future<bool> signInWithEmail(String email, String password) async {
    Response response = await dio().post('/api/v1/login',
        data: jsonEncode({
          'username': email,
          'password': password,
        }));
    if (response.statusCode == 200) {
      print(response.headers);
      print(response.data);
      await _saveUserDataLocally(response.data);

      return true;
    } else {
      return false;
    }
  }

  Future<void> _saveUserDataLocally(Map<String, dynamic> sessionInfo) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefsSessionInfo, json.encode(sessionInfo));
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    http.Response response =
        await http.get(Uri.parse("$apiBaseUrl/api/v2/user/$userId"));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  Future<bool> isFirstTime(String userId) async {
    bool? exists;

    http.Response response =
        await http.get(Uri.parse("$apiBaseUrl/api/v2/user/$userId"));

    exists = response.statusCode == 200;

    return exists;
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    http.Response response =
        await http.post(Uri.parse('$apiBaseUrl/api/v1/register'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }));

    return response.statusCode == 200;
  }

  Future<void> signOut() async {
    // TODO: Return signOut
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefsSessionInfo);
  }

  Future<bool> isSignedIn() async {
    // TODO: Fetch currentUser and check if its != null. (as return)

    // For testing purposes
    return false;
  }

  Future<String> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionInfoStr = prefs.getString(prefsSessionInfo);
    if (sessionInfoStr != null) {
      final Map<String, dynamic> sessionInfo = json.decode(sessionInfoStr);
      final id = sessionInfo['userData']['id'];
      return id.toString();
    }
    return "";
  }

  // Profile Setup
  Future<bool> profileSetup(Uint8List photo, String userId, String name,
      String gender, DateTime age, Position position) async {
    return false;
  }
}
