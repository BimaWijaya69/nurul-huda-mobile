import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/core/routes/app_routes.dart';
import 'package:nurul_huda_mobile/data/models/absensi_guru.dart';
import 'package:nurul_huda_mobile/data/models/jadwal_kbm.dart';
import 'package:nurul_huda_mobile/data/services/absensi_service.dart';
import 'package:intl/intl.dart';
import 'package:nurul_huda_mobile/helpers/location_helper.dart';
import 'package:nurul_huda_mobile/views/auth/auth_controller.dart';

class AbsensiController extends GetxController {
  final AbsensiService _absensiService = AbsensiService();
  var isLoading = true.obs;

  var isError = false.obs;
  var errorType = 'server'.obs;
  var errorMessage = ''.obs;

  var isCheckingLocation = false.obs;
  var hariIni = ''.obs;
  var tanggalLengkap = ''.obs;
  var isSubmitting = false.obs;
  var listJadwal = <JadwalKbmItem>[].obs;
  var alasanError = ''.obs;

  final TextEditingController alasanController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchJadwalHariIni();

    alasanController.addListener(() {
      if (alasanError.value.isNotEmpty && alasanController.text.isNotEmpty) {
        alasanError.value = '';
      }
    });
  }

  @override
  void onClose() {
    alasanController.dispose();
    super.onClose();
  }

  Future<void> validasiLokasiDanAbsen(dynamic jadwal, bool isEditMode) async {
    try {
      isCheckingLocation(true);

      bool isDiPondok = await LocationHelper.isWithinRadius();

      if (isDiPondok) {
        Get.back();
        Get.toNamed(isEditMode ? Routes.EDIT_ABSENSI : Routes.CREATE_ABSENSI,
            arguments: {'jadwal': jadwal, 'isEdit': isEditMode});
      } else {
        Get.snackbar(
          'Di Luar Jangkauan',
          'Anda berada di luar area Pondok Pesantren. Silakan merapat ke area pondok untuk absen Hadir.',
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          icon: const Icon(Icons.location_off_rounded, color: Colors.white),
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      Get.snackbar('Gagal Membaca Lokasi', e.toString(),
          backgroundColor: Colors.red.shade800, colorText: Colors.white);
    } finally {
      isCheckingLocation(false);
    }
  }

  Future<void> fetchJadwalHariIni() async {
    try {
      isLoading(true);
      isError(false);
      errorMessage('');

      int? guruId = AuthController.to.currentUser.value?.id;

      final responseData = await _absensiService.getJadwalHariIni(guruId!);

      hariIni.value = responseData.hari;
      tanggalLengkap.value = responseData.tanggal;
      listJadwal.assignAll(responseData.jadwal);
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
      //     backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  Future<void> submitIzinGuru({
    required int mapel_kelas_id,
    required String label_status,
  }) async {
    String keterangan = alasanController.text.trim();

    if (keterangan.isEmpty) {
      alasanError.value = 'Keterangan alasan wajib diisi!';
      return;
    } else {
      alasanError.value = '';
    }
    try {
      isSubmitting(true);

      int statusCode = 2;
      if (label_status == 'Sakit') statusCode = 4;

      final payload = AbsensiGuru(
        mapel_kelas_id: mapel_kelas_id,
        status: statusCode,
        tanggal: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        ket_izin: keterangan,
        materi_pembelajaran: null,
      );

      bool success = await _absensiService.submitAbsensiGuru(payload);

      if (success) {
        alasanController.clear();
        Get.back();
        Get.snackbar('Berhasil', 'Data absensi berhasil dikirim',
            backgroundColor: Colors.green, colorText: Colors.white);
        fetchJadwalHariIni();
      }
    } catch (e) {
      Get.snackbar('Gagal', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSubmitting(false);
    }
  }
}
