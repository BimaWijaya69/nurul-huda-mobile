import 'dart:io';
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nurul_huda_mobile/core/utils/api.dart';
import 'package:nurul_huda_mobile/data/models/user.dart';
import 'package:nurul_huda_mobile/views/auth/auth_controller.dart';

class AuthService extends Api {
  final box = GetStorage();

  Future<String> _getUniqueDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor ?? 'unknown_ios';
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    }
    return 'unknown_device';
  }

  Future<AuthResponse> loginWithQr(String qrToken) async {
    try {
      String deviceId = await _getUniqueDeviceId();

      Map<String, dynamic> payload = {
        'qr_token': qrToken,
        'device_id': deviceId,
      };

      final response = await dio.post(
        '/login-qr',
        data: payload,
      );

      AuthResponse authData = AuthResponse.fromJson(response.data);

      if (authData.status == 'success' && authData.token != null) {
        box.write('token', authData.token);

        if (authData.user != null) {
          AuthController.to.saveUser(authData.user!);
        }
      }

      return authData;
    } on DioException catch (e) {
      if (e.response != null) {
        return AuthResponse.fromJson(e.response!.data);
      } else {
        return AuthResponse(
            status: 'error',
            message:
                'Tidak dapat terhubung ke server. Cek koneksi internet Anda.');
      }
    } catch (e) {
      return AuthResponse(
          status: 'error',
          message: 'Terjadi kesalahan sistem: ${e.toString()}');
    }
  }

  bool isLoggedIn() {
    String? token = box.read('token');
    return token != null && token.isNotEmpty;
  }

  Future<bool> logout() async {
    try {
      String? token = box.read('token');
      if (token != null) {
        final res = await dio.post('/logout');

        if (res.statusCode == 200) {
          return true;
        } else {
          debugPrint('Logout gagal di server: ${res.statusCode} - ${res.data}');
          return false;
        }
      }
      return true;
    } catch (e) {
      debugPrint('🚨 [AUTH SERVICE] LOGOUT ERROR: $e');
      return false;
    } finally {
      box.erase();
    }
  }
}
