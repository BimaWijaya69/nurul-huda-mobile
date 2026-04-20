import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/data/models/nilai_ujian.dart';
import 'package:nurul_huda_mobile/data/services/nilai_uijan_service.dart';
import 'package:nurul_huda_mobile/views/auth/auth_controller.dart';

class NilaiUjianController extends GetxController {
  final NilaiUjianService _service = NilaiUjianService();
  var isLoading = true.obs;

  var isError = false.obs;
  var errorType = 'server'.obs;
  var errorMessage = ''.obs;

  var listMapel = <MapelUjianItem>[].obs;

  var tahun_ajaran = ''.obs;
  var semester = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMapelGuru();
  }

  Future<void> fetchMapelGuru() async {
    try {
      isLoading(true);
      isError(false);
      errorMessage('');

      int? guruId = AuthController.to.currentUser.value?.id;
      var data = await _service.getMapelGuru(guruId!);

      listMapel.assignAll(data);

      if (data.isNotEmpty) {
        tahun_ajaran.value = data.first.tahun_ajaran;
        semester.value = data.first.semester;
      }
    } catch (e) {
      isError(true);
      String errorMsg = e.toString().toLowerCase();

      if (errorMsg.contains('timeout') || errorMsg.contains('waktu habis')) {
        errorType.value = 'timeout';
      } else if (errorMsg.contains('internet') ||
          errorMsg.contains('network') ||
          errorMsg.contains('socket')) {
        errorType.value = 'network';
      } else if (errorMsg.contains('401') ||
          errorMsg.contains('unauthorized')) {
        errorType.value = 'unauthorized';
      } else {
        errorType.value = 'server';
        errorMessage(
            e.toString()); // Simpan pesan asli jika error tidak dikenali
      }

      // Get.snackbar('Error', e.toString(),
      //     backgroundColor: Colors.red, colorText: Colors.white); // Tambahkan ini biar kalau ada error, gampang dilacak di console
    } finally {
      isLoading(false);
    }
  }
}
