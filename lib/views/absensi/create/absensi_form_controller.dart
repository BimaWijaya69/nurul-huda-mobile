import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nurul_huda_mobile/data/models/absensi_guru.dart';
import 'package:nurul_huda_mobile/data/models/absensi_santri.dart';
import 'package:nurul_huda_mobile/data/models/santri.dart';
import 'package:nurul_huda_mobile/data/services/absensi_service.dart';
import 'package:nurul_huda_mobile/helpers/arabic_helper.dart';
import 'package:nurul_huda_mobile/views/absensi/absensi_controller.dart';

class AbsensiSantriFormController extends GetxController {
  final AbsensiService _absensiService = AbsensiService();
  var isLoading = true.obs;
  var isSaving = false.obs;
  var searchQuery = ''.obs;
  var materiError = ''.obs;

  final TextEditingController materiController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  late int jadwal_mapel_kelas_id;
  late int kelas_id;
  late String nama_mapel_kelas;
  bool isEditMode = false;

  var listSantriUi = <SantriAbsenUi>[].obs;
  var filteredSantri = <SantriAbsenUi>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      var jadwal = Get.arguments['jadwal'];
      jadwal_mapel_kelas_id = jadwal.mapel_kelas_id;
      nama_mapel_kelas =
          "${jadwal.nama_mapel} - ${ArabicHelper.getKelasArab(jadwal.kelas_id)}";

      kelas_id = Get.arguments['kelas_id'] ?? 1;
      isEditMode = Get.arguments['isEdit'] ?? false;
    }

    searchController.addListener(() {
      searchQuery.value = searchController.text;
      filterSantri(searchController.text);
    });

    materiController.addListener(() {
      if (materiError.value.isNotEmpty && materiController.text.isNotEmpty) {
        materiError.value = '';
      }
    });

    if (isEditMode) {
      fetchDetailAbsensiEdit();
    } else {
      fetchDaftarSantri();
    }
  }

  Future<void> fetchDaftarSantri() async {
    try {
      isLoading(true);
      List<Santri> dataSantri =
          await _absensiService.getSantriByKelas(kelas_id);

      var uiModels =
          dataSantri.map((s) => SantriAbsenUi(santri: s, status: 1)).toList();

      listSantriUi.assignAll(uiModels);
      filteredSantri.assignAll(uiModels);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchDetailAbsensiEdit() async {
    try {
      isLoading(true);
      String hariIni = DateFormat('yyyy-MM-dd').format(DateTime.now());

      var detailData = await _absensiService.getDetailAbsensi(
          jadwal_mapel_kelas_id, kelas_id, hariIni);

      materiController.text = detailData['materi'];

      List<SantriAbsenUi> uiModels = detailData['list_santri'];
      listSantriUi.assignAll(uiModels);
      filteredSantri.assignAll(uiModels);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data edit: ${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  void filterSantri(String query) {
    if (query.isEmpty) {
      filteredSantri.assignAll(listSantriUi);
    } else {
      filteredSantri.assignAll(listSantriUi.where((item) {
        return item.santri.nama!.toLowerCase().contains(query.toLowerCase());
      }).toList());
    }
  }

  void ubahStatusSantri(int santri_id, int newStatus) {
    int index =
        listSantriUi.indexWhere((element) => element.santri.id == santri_id);
    if (index != -1) {
      var oldItem = listSantriUi[index];
      listSantriUi[index] =
          SantriAbsenUi(santri: oldItem.santri, status: newStatus);

      filterSantri(searchController.text);
    }
  }

  Future<void> submitSemuaAbsensi() async {
    String materi = materiController.text.trim();

    if (materi.isEmpty) {
      materiError.value = 'Materi pembelajaran wajib diisi!';
      return;
    } else {
      materiError.value = '';
    }

    try {
      isSaving(true);
      String hariIni = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final payloadGuru = AbsensiGuru(
        mapel_kelas_id: jadwal_mapel_kelas_id,
        status: 1,
        tanggal: hariIni,
        materi_pembelajaran: materi,
        ketIzin: null,
      );

      List<AbsensiItem> listAbsenSantri = listSantriUi.map((item) {
        return AbsensiItem(
          santri_id: item.santri.id!,
          status: item.status,
        );
      }).toList();

      final payloadSantri = AbsensiSantri(
        kelas_id: kelas_id,
        tanggal: hariIni,
        absensi: listAbsenSantri,
      );

      bool suksesGuru = await _absensiService.submitAbsensiGuru(payloadGuru);

      if (suksesGuru) {
        bool suksesSantri =
            await _absensiService.submitAbsensiSantriBulk(payloadSantri);

        if (suksesSantri) {
          Get.back();
          String pesansukses = isEditMode
              ? 'Perubahan absensi berhasil disimpan!'
              : 'Absensi berhasil disimpan!';
          Get.snackbar('Sukses', pesansukses,
              backgroundColor: Colors.green, colorText: Colors.white);

          Get.find<AbsensiController>().fetchJadwalHariIni();
        }
      }
    } catch (e) {
      Get.snackbar('Gagal Menyimpan', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving(false);
    }
  }

  @override
  void onClose() {
    materiController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
