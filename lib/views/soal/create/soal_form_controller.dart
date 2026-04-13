import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/data/models/soal.dart';
import 'package:nurul_huda_mobile/data/services/soal_service.dart';

class SoalFormController extends GetxController {
  final SoalService _service = SoalService();

  int? mapel_kelas_id;
  String? tahun_ajaran;
  String? semester;
  String? namaMapelKelas;

  var isLoading = false.obs;
  var currentIndex = 0.obs;
  final int totalSoal = 10;

  late PageController pageController;

  final List<TextEditingController> textControllers = List.generate(
    10,
    (index) => TextEditingController(),
  );

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);

    if (Get.arguments != null) {
      mapel_kelas_id = Get.arguments['mapel_kelas_id'];
      tahun_ajaran = Get.arguments['tahun_ajaran'];
      semester = Get.arguments['semester'];
      namaMapelKelas = Get.arguments['nama_mapel_kelas'];
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    for (var controller in textControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < totalSoal - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void prevPage() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> submitSoal() async {
    List<String> listSoal = textControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (listSoal.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Minimal isi satu soal!',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);

      Soal payload = Soal(
        mapel_kelas_id: mapel_kelas_id!,
        soal: listSoal,
        tahun_ajaran: tahun_ajaran!,
        semester: semester!,
      );

      bool success = await _service.submitBankSoal(payload);

      if (success) {
        Get.back(result: true);
        Get.snackbar(
          'Berhasil',
          'Soal ujian tersimpan dan otomatis jadi Pegon.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Menyimpan',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}
