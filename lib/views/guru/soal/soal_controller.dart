import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/data/models/soal.dart';
import 'package:nurul_huda_mobile/core/repository/soal_repository.dart';

class SoalController extends GetxController {
  // Repository — otomatis mock atau real tergantung flag useMock
  final SoalRepository _repository = SoalRepository();

  // ── Form header ujian ──────────────────────────────
  final RxString judul = ''.obs;
  final RxString mapel = ''.obs;
  final RxString kelas = 'Ula'.obs;
  final RxString tanggal = ''.obs;
  final RxInt durasi = 90.obs;

  // ── Daftar soal ───────────────────────────────────
  final RxList<SoalModel> soalList = <SoalModel>[].obs;
  final RxSet<int> expandedIds = <int>{}.obs;
  final RxSet<int> loadingTransIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Jalankan setelah frame build selesai
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeSoalList();
    });
  }

  void _initializeSoalList() {
    // Buat 10 soal essay dengan ID 1-10
    for (int i = 1; i <= 10; i++) {
      soalList.add(
        SoalModel(
          id: i,
        ),
      );
    }
    // Expand soal pertama
    if (soalList.isNotEmpty) {
      expandedIds.add(soalList.first.id);
    }
  }

  void toggleExpand(int id) {
    expandedIds.contains(id) ? expandedIds.remove(id) : expandedIds.add(id);
  }

  bool isExpanded(int id) => expandedIds.contains(id);

  // ── Update fields ─────────────────────────────────

  void updateSoalLatin(int id, String val) {
    _updateSoal(id, (s) => s.copyWith(soalLatin: val));
  }

  void updatePedomanEssay(int id, String val) {
    _updateSoal(id, (s) => s.copyWith(pedomanEssay: val));
  }

  void _updateSoal(int id, SoalModel Function(SoalModel) updater) {
    final idx = soalList.indexWhere((s) => s.id == id);
    if (idx == -1) return;
    soalList[idx] = updater(soalList[idx]);
    soalList.refresh();
  }

  Future<void> transliterasi(int id) async {
    final idx = soalList.indexWhere((s) => s.id == id);
    if (idx == -1) return;

    final soal = soalList[idx];
    if (soal.soalLatin.trim().isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Tulis soal dalam huruf Latin terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    loadingTransIds.add(id);
    try {
      final result = await _repository.transliterasi(soal.soalLatin);
      _updateSoal(id, (s) => s.copyWith(soalPegon: result));
    } catch (e) {
      Get.snackbar('Error', 'Gagal transliterasi: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      loadingTransIds.remove(id);
    }
  }

  bool isLoadingTrans(int id) => loadingTransIds.contains(id);

  Future<void> simpan() async {
    final pesan = validasiPesan;
    if (pesan != null) {
      Get.snackbar('Belum lengkap', pesan,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade50,
          colorText: Colors.orange.shade800);
      return;
    }

    try {
      final sukses = await _repository.simpanSoal(
        judul: judul.value,
        mapel: mapel.value,
        kelas: kelas.value,
        tanggal: tanggal.value,
        durasi: durasi.value,
        soalList: soalList.toList(),
      );

      if (sukses) {
        Get.snackbar(
          'Berhasil',
          'Soal berhasil disimpan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFE8F5EE),
          colorText: const Color(0xFF1B7A3E),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  String? get validasiPesan {
    if (judul.value.trim().isEmpty) return 'Judul ujian belum diisi';
    if (soalList.isEmpty) return 'Belum ada soal';
    final blumTrans =
        soalList.where((s) => s.soalPegon.trim().isEmpty).toList();
    if (blumTrans.isNotEmpty) {
      final nomors = blumTrans.map((s) => soalList.indexOf(s) + 1).join(', ');
      return 'Soal nomor $nomors belum ditransliterasi';
    }
    return null;
  }
}
