import 'package:dio/dio.dart';
import 'package:nurul_huda_mobile/core/utils/api.dart';
import 'package:nurul_huda_mobile/data/models/soal.dart';

class SoalService extends Api {
  Future<Map<String, dynamic>> getMapelKelas(int guruId) async {
    try {
      final res = await dio.get('/bank-soal/guru/$guruId');

      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print('E${e.toString()}');
      print(
          'Error API getMapelKelas: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Gagal ambil data mapel');
    }
  }

  Future<bool> submitBankSoal(Soal payload) async {
    try {
      final res = await dio.post('/bank-soal', data: payload.toJson());

      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('E${e.toString()}');
      print(
          'Error API submitBankSoal: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Gagal submit soal');
    }
  }

  Future<Map<String, dynamic>> getSoalMobile(
      int mapel_kelas_id, String tahun_ajaran, String semester) async {
    try {
      final res = await dio.get('/bank-soal', queryParameters: {
        'mapel_kelas_id': mapel_kelas_id,
        'tahun_ajaran': tahun_ajaran,
        'semester': semester,
      });

      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print('E${e.toString()}');
      print(
          'Error API getSoalMobile: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Gagal ambil data soal');
    }
  }

  Future<String> generatePegon(String teksLatin) async {
    try {
      final res =
          await dio.post('/bank-soal/generate', data: {'text': teksLatin});

      if (res.statusCode == 200) {
        return res.data['text_pegon'] as String;
      } else {
        throw Exception('Gagal generate pegon');
      }
    } on DioException catch (e) {
      print('E${e.toString()}');
      print(
          'Error API generatePegon: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Gagal generate pegon');
    }
  }

  Future<bool> updateSoal(
      int bank_soal_id, List<Map<String, String>> soal) async {
    try {
      final res = await dio
          .post('/bank-soal/$bank_soal_id/update-soal', data: {'soal': soal});

      if (res.statusCode == 200) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      print('E${e.toString()}');
      print(
          'Error API updateSoal: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception('Gagal update soal');
    }
  }
}
