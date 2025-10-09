import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iss_cleancare/constants/connenction.dart';
import 'package:iss_cleancare/constants/general.dart';
import 'package:iss_cleancare/main.dart';
import 'package:iss_cleancare/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // ============================== API REQUEST ============================== //
  static Future<Map<String, dynamic>?> apiRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    List<http.MultipartFile> listFile = const [],
    String? token,
    String contentType = 'application/json',
  }) async {
    // init
    http.Response response;
    final url = '$baseUrl$endpoint';
    Map<String, String> header = {'Content-Type': contentType};

    if (token != null) {
      header['Authorization'] = 'Bearer $token';
    }

    try {
      // function hit api
      Future<http.Response> hitAPI() async {
        switch (method.toUpperCase()) {
          case 'POST':
            if (contentType == 'application/json') {
              log("body : $body");
              return http.post(
                Uri.parse(url),
                headers: header,
                body: jsonEncode(body),
              );
            }
            return _handleMultipartRequest(method, url, header, listFile, body);
          case 'GET':
            return http.get(Uri.parse(url), headers: header);
          case 'PUT':
            if (contentType == 'application/json') {
              return http.put(
                Uri.parse(url),
                headers: header,
                body: jsonEncode(body),
              );
            }
            return _handleMultipartRequest(method, url, header, listFile, body);
          // return contentType == 'application/json'
          //     ? http.put(Uri.parse(url),
          //         headers: header, body: jsonEncode(body))
          //     : await _handleMultipartRequest(method, url, header, body);
          case 'DELETE':
            return http.delete(Uri.parse(url), headers: header);
          case 'PATCH':
            return contentType == 'application/json'
                ? http.patch(
                    Uri.parse(url),
                    headers: header,
                    body: jsonEncode(body),
                  )
                : await _handleMultipartRequest(
                    method,
                    url,
                    header,
                    listFile,
                    body,
                  );
          default:
            throw Exception('Unsupported HTTP method: $method');
        }
      }

      // hit api
      response = await hitAPI();
      // cek if refresh token needed
      if (response.statusCode == 401 &&
          (endpoint != "/auth/login" ||
              endpoint != "/auth/send-email/forgot-password")) {
        final newToken = await _refreshToken(token);

        if (newToken != null) {
          header['Authorization'] = 'Bearer $newToken';
          response = await hitAPI();
        } else {
          throw Exception('Your Session Is Expired, Please Re-Login...');
        }
      } else if (response.statusCode == 422 &&
          (endpoint != "/auth/login" ||
              endpoint != "/auth/send-email/forgot-password")) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

        try {
          final response = await apiRequest(
            method: 'POST',
            endpoint: '/auth/logout',
            body: {'logout_from': 'mobile'},
            token: token,
            contentType: 'application/json',
          );

          if (response != null && response['code'] == 200) {
            General.clearSharedPreferences();
          } else {
            debugPrint("Logout API gagal: ${response?['code']}");
            General.clearSharedPreferences();
          }
        } catch (e) {
          debugPrint("Error when logout: $e");
        } finally {
          General.clearSharedPreferences();
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false,
          );
        }
      }

      // return body
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      return jsonBody;
    } catch (e, trace) {
      debugPrint("trace :>>> $trace");
      // return null;
      rethrow;
    }
  }

  // ============================== API REQUEST (PRIVATE FUNCTION) ============================== //
  static Future<http.Response> _handleMultipartRequest(
    String method,
    String url,
    Map<String, String> header,
    List<http.MultipartFile> listFile,
    Map<String, dynamic>? body,
  ) async {
    var request = http.MultipartRequest(method, Uri.parse(url))
      ..headers.addAll(header);
    body?.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    request.files.addAll(listFile);
    return await http.Response.fromStream(await request.send());
  }

  static Future<String?> _refreshToken(String? token) async {
    try {
      final response = await authRefeshToken(token!);
      if (response!['success'] == true) {
        final newToken = response['data']['token'];
        General.editSharedPreferences('token', newToken);
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        return token;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // ============================== AUTH ============================== //
  static Future<Map<String, dynamic>?> authLogin(
    String email,
    String password,
  ) async {
    final response = await apiRequest(
      method: 'POST',
      endpoint: '/auth/login',
      body: {'email': email, 'password': password, 'login_from': 'mobile'},
      token: null,
      contentType: 'application/json',
    );

    return response;
  }

  static Future<Map<String, dynamic>?> authRefeshToken(String token) async {
    final url = '$baseUrl/auth/refresh-token';
    Map<String, String> header = {'Content-Type': 'application/json'};
    header['Authorization'] = 'Bearer $token';
    final response = await http.post(
      Uri.parse(url),
      body: null,
      headers: header,
    );
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    return jsonBody;
  }

  static Future<void> authLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await apiRequest(
        method: 'POST',
        endpoint: '/auth/logout',
        body: {'logout_from': 'mobile'},
        token: token,
        contentType: 'application/json',
      );

      if (response != null && response['code'] == 200) {
        General.clearSharedPreferences();
      } else {
        debugPrint("Logout API gagal: ${response?['code']}");
        General.clearSharedPreferences();
      }
    } catch (e) {
      debugPrint("Error when logout: $e");
    }
    // Pastikan context masih valid sebelum navigasi
    finally {
      General.clearSharedPreferences();

      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false,
        );
      }
    }
  }

  static Future<Map<String, dynamic>?> sendForgotPasswordEmail(
    String email,
  ) async {
    try {
      final response = await apiRequest(
        method: 'POST',
        endpoint: '/auth/send-email/forgot-password',
        body: {'email': email},
        token: null,
        contentType: 'application/json',
      );

      if (response != null && response['code'] == 401) {
        return {'success': false, 'message': 'Email tidak terdaftar'};
      }

      // Jika response sukses (kode selain 401)
      return response;
    } catch (e) {
      // Menangani kesalahan yang terjadi pada saat pemanggilan API
      debugPrint('Error when sent email reset: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat mengirim email reset: $e',
      };
    }
  }

  static Future<String?> refreshTokenForWebSocket(String? token) async {
    try {
      final response = await authRefeshToken(token!);
      if (response!['success'] == true) {
        final newToken = response['data']['token'];
        General.editSharedPreferences('token', newToken);
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        return token;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
