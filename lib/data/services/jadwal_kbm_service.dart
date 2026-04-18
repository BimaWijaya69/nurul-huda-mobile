import 'package:dio/dio.dart';
import 'package:nurul_huda_mobile/core/utils/api.dart';
import 'package:nurul_huda_mobile/data/models/jadwal_kbm.dart';

class JadwalKbmService extends Api {
  Future<List<AgendaMengajarItem>> getJadwalGuru(int guruId) async {
    try {
      final response = await dio.get(
        '/jadwal-kbm/guru',
        queryParameters: {'guru_id': guruId},
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List data = response.data['data'];
        return AgendaMengajarItem.fromList(data);
      } else {
        throw Exception(response.data['message'] ?? 'Gagal mengambil jadwal');
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Kesalahan koneksi server');
    }
  }
}
