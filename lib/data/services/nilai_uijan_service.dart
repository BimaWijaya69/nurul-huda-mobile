import 'package:dio/dio.dart';
import 'package:nurul_huda_mobile/core/utils/api.dart';
import 'package:nurul_huda_mobile/data/models/nilai_ujian.dart';

class NilaiUjianService extends Api {
  Future<List<MapelUjianItem>> getMapelGuru(int guruId) async {
    try {
      final response =
          await dio.get('/nilai-ujian/get-list-mapel-guru', queryParameters: {
        'guru_id': guruId,
      });

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        List data = response.data['data'];

        return data.map((e) => MapelUjianItem.fromJson(e)).toList();
      } else {
        throw Exception(
            response.data['message'] ?? 'Gagal mengambil data mapel');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ??
          'Terjadi kesalahan jaringan atau server');
    }
  }

  Future<bool> submitNilaiUjianBulk(NilaiUjian payload) async {
    try {
      final response = await dio.post(
        '/nilai-ujian',
        data: payload.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      String errorMsg = 'Gagal menyimpan nilai ujian';
      if (e.response != null && e.response?.data['message'] != null) {
        errorMsg = e.response?.data['message'];
      }
      throw Exception(errorMsg);
    }
  }

  Future<List<Map<String, dynamic>>> getDetailNilai(
      int kelasId, int mapelId, String tahunAjaran, String semester) async {
    try {
      final response =
          await dio.get('/nilai-ujian/detail-nilai', queryParameters: {
        'kelas_id': kelasId,
        'mapel_id': mapelId,
        'tahun_ajaran': tahunAjaran,
        'semester': semester,
      });

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return List<Map<String, dynamic>>.from(response.data['data']);
      } else {
        throw Exception('Gagal memuat detail nilai');
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Terjadi kesalahan jaringan');
    }
  }
}
