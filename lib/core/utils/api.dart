import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nurul_huda_mobile/core/routes/app_routes.dart';

class Api {
  static bool _isLoggingOut = false;
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.1.7:8000/api",
      // baseUrl: "http://192.168.1.3:8000/api",
      // baseUrl: "http://10.32.1.244:8000/api",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Api() {
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) {
        final box = GetStorage();
        String? token = box.read("token");

        if (token != null && token.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
        }

        return handler.next(options);
      }, onError: (DioException e, handler) {
        if (e.response?.statusCode == 401 &&
            !e.requestOptions.path.contains('login-qr')) {
          if (!_isLoggingOut) {
            _isLoggingOut = true;

            final box = GetStorage();
            box.erase();

            Get.offAllNamed(Routes.STARTED);

            Future.delayed(const Duration(seconds: 2), () {
              _isLoggingOut = false;
            });
          }
        }
        return handler.next(e);
      }),
    );
  }
}
