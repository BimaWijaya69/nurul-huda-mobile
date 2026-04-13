import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/data/services/soal_service.dart';

class SoalPreviewController extends GetxController {
  final SoalService _service = SoalService();

  var isLoading = true.obs;
  var isSaving = false.obs;
  var currentIndex = 0.obs;
  final int totalSoal = 10;

  int? bankSoalId;
  String? namaMapelKelas;

  late PageController pageController;

  final List<TextEditingController> latinControllers =
      List.generate(10, (_) => TextEditingController());
  final List<TextEditingController> pegonControllers =
      List.generate(10, (_) => TextEditingController());

  var isGenerating = List.generate(10, (_) => false).obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    if (Get.arguments != null) {
      namaMapelKelas = Get.arguments['nama_mapel_kelas'];
    }
    fetchDataSoal();
  }

  Future<void> fetchDataSoal() async {
    try {
      isLoading(true);
      int mapel_kelas_id = Get.arguments['mapel_kelas_id'];
      String tahun_ajaran = Get.arguments['tahun_ajaran'];
      String semester = Get.arguments['semester'];

      final res =
          await _service.getSoalMobile(mapel_kelas_id, tahun_ajaran, semester);

      bankSoalId = res['data']['bank_soal_id'];
      List<dynamic> listSoal = res['data']['soal'] ?? [];

      for (int i = 0; i < listSoal.length; i++) {
        if (i < 10) {
          latinControllers[i].text = listSoal[i]['soal_latin'] ?? '';
          pegonControllers[i].text = listSoal[i]['soal_pegon'] ?? '';
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data soal: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  Future<void> hitGeneratePegon(int index) async {
    String teksLatin = latinControllers[index].text.trim();
    if (teksLatin.isEmpty) {
      Get.snackbar('Kosong', 'Teks latin tidak boleh kosong!',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      isGenerating[index] = true;
      String hasilPegon = await _service.generatePegon(teksLatin);
      pegonControllers[index].text = hasilPegon;
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal translate ke Pegon',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isGenerating[index] = false;
    }
  }

  Future<void> updateSoal() async {
    List<Map<String, String>> payloadSoal = [];

    for (int i = 0; i < totalSoal; i++) {
      if (latinControllers[i].text.isNotEmpty ||
          pegonControllers[i].text.isNotEmpty) {
        payloadSoal.add({
          'latin': latinControllers[i].text.trim(),
          'pegon': pegonControllers[i].text.trim(),
        });
      }
    }

    try {
      isSaving(true);
      await _service.updateSoal(bankSoalId!, payloadSoal);

      Get.back(result: true);
      Get.snackbar('Sukses', 'Perubahan soal berhasil disimpan!',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal menyimpan perubahan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving(false);
    }
  }

  void onPageChanged(int index) => currentIndex.value = index;
  void nextPage() {
    if (currentIndex.value < totalSoal - 1)
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void prevPage() {
    if (currentIndex.value > 0)
      pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  void onClose() {
    pageController.dispose();
    for (var c in latinControllers) {
      c.dispose();
    }
    for (var c in pegonControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
