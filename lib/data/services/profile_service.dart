import 'package:dio/dio.dart';
import 'package:nurul_huda_mobile/core/utils/api.dart';
import 'package:nurul_huda_mobile/data/models/guru.dart';

class ProfilService extends Api {
  Future<Guru?> getDetailGuru(String kodeGuru) async {
    try {
      final response = await dio.get('');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return Guru.fromJson(response.data['data']);
      }
      return null;
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Gagal memuat profil guru');
    }
  }
}
