import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/data/models/nilai_ujian.dart';
import 'package:nurul_huda_mobile/data/services/nilai_uijan_service.dart';
import 'package:nurul_huda_mobile/views/auth/auth_controller.dart';

class NilaiUjianController extends GetxController {
  final NilaiUjianService _service = NilaiUjianService();
  var isLoading = true.obs;
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

      int? guruId = AuthController.to.currentUser.value?.id;
      var data = await _service.getMapelGuru(guruId!);

      listMapel.assignAll(data);

      if (data.isNotEmpty) {
        tahun_ajaran.value = data.first.tahun_ajaran;
        semester.value = data.first.semester;
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Memuat Data',
        e.toString(),
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}
