import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Api {
  final Dio dio = Dio(
    BaseOptions(
      // baseUrl: "http://192.168.1.4:8000/api",
      // baseUrl: "http://192.168.1.2:8000/api",
      baseUrl: "http://10.32.1.244:8000/api",
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
        String? token = box.read("access_token");

        if (token != null && !JwtDecoder.isExpired(token)) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      }, onError: (DioException e, handler) {
        return handler.next(e);
      }),
    );
  }
}
