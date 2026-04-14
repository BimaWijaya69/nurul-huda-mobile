import 'package:dio/dio.dart';
import 'package:nurul_huda_mobile/core/utils/api.dart';
import 'package:nurul_huda_mobile/data/models/absensi_guru.dart';
import 'package:nurul_huda_mobile/data/models/absensi_santri.dart';
import 'package:nurul_huda_mobile/data/models/jadwal_kbm.dart';
import 'package:nurul_huda_mobile/data/models/santri.dart';

class AbsensiService extends Api {
  Future<JadwalKbm> getJadwalHariIni(int guruId) async {
    try {
      final response = await dio.get('/jadwal-kbm/hari-ini', queryParameters: {
        'guru_id': guruId,
      });

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return JadwalKbm.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Gagal mengambil jadwal');
      }
    } on DioException catch (e) {
      print('Error Dio Get Jadwal: ${e.message}');
      throw Exception('Terjadi kesalahan jaringan atau server');
    }
  }

  Future<bool> submitAbsensiGuru(AbsensiGuru payload) async {
    try {
      final response = await dio.post('/absensi-guru', data: payload.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      String errorMsg = e.response?.data['message'] ?? 'Gagal simpan absensi';
      throw Exception(errorMsg);
    }
  }

  Future<List<Santri>> getSantriByKelas(int kelasId) async {
    try {
      final response = await dio.get('/kelas/santri/$kelasId');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        List data = response.data['data'];
        return data.map((e) => Santri.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat data santri');
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Terjadi kesalahan jaringan');
    }
  }

  Future<bool> submitAbsensiSantriBulk(AbsensiSantri payload) async {
    try {
      final response =
          await dio.post('/absensi-santri/bulk', data: payload.toJson());

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Gagal menyimpan absensi santri');
    }
  }
}
