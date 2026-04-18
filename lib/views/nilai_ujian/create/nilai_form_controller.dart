import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/data/models/nilai_ujian.dart';
import 'package:nurul_huda_mobile/data/models/santri.dart';
import 'package:nurul_huda_mobile/data/services/absensi_service.dart';
import 'package:nurul_huda_mobile/data/services/nilai_uijan_service.dart';
import 'package:nurul_huda_mobile/views/nilai_ujian/nilai_controller.dart';

class NilaiUjianFormController extends GetxController {
  final NilaiUjianService _nilaiService = NilaiUjianService();
  final AbsensiService _absensiService = AbsensiService();

  var isLoading = true.obs;
  var isSaving = false.obs;
  var searchQuery = ''.obs;

  late MapelUjianItem mapelData;
  late bool isEditMode;

  var listSantri = <Santri>[].obs;
  var filteredSantri = <Santri>[].obs;

  final Map<int, TextEditingController> nilaiControllers = {};

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      mapelData = Get.arguments['mapel'];
      isEditMode = Get.arguments['isEdit'] ?? false;
    }

    searchController.addListener(() {
      searchQuery.value = searchController.text;
      _filterSantri(searchController.text);
    });

    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      isLoading(true);

      if (isEditMode) {
        await _fetchDetailNilai();
      } else {
        await _fetchDaftarSantri();
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> _fetchDaftarSantri() async {
    try {
      var data = await _absensiService.getSantriByKelas(mapelData.kelas_id);
      listSantri.assignAll(data);
      filteredSantri.assignAll(data);

      for (var santri in data) {
        nilaiControllers[santri.id!] = TextEditingController(text: '');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> _fetchDetailNilai() async {
    try {
      var dataDetail = await _nilaiService.getDetailNilai(mapelData.kelas_id,
          mapelData.mapel_id, mapelData.tahun_ajaran, mapelData.semester);

      List<Santri> santriList = [];

      for (var item in dataDetail) {
        var s = Santri.fromJson(item['santri']);
        santriList.add(s);

        String skorTersimpan =
            item['nilai'] != null ? item['nilai'].toString() : '';

        nilaiControllers[s.id!] = TextEditingController(text: skorTersimpan);
      }

      listSantri.assignAll(santriList);
      filteredSantri.assignAll(santriList);
    } catch (e) {
      Get.snackbar('Error Memuat Data', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void _filterSantri(String query) {
    if (query.isEmpty) {
      filteredSantri.assignAll(listSantri);
    } else {
      filteredSantri.assignAll(listSantri
          .where((s) => s.nama!.toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }

  Future<void> submitSemuaNilai() async {
    List<NilaiSantriItem> payloadNilai = [];

    for (var santri in listSantri) {
      String val = nilaiControllers[santri.id!]?.text ?? '';

      if (val.isEmpty) {
        Get.snackbar('Peringatan', 'Nilai ${santri.nama} belum diisi!',
            backgroundColor: Colors.orange);
        return;
      }

      double? skor = double.tryParse(val);
      if (skor == null || skor < 0 || skor > 100) {
        Get.snackbar('Input Salah', 'Nilai harus angka 0 - 100',
            backgroundColor: Colors.red);
        return;
      }

      payloadNilai.add(NilaiSantriItem(santriId: santri.id!, nilai: skor));
    }

    try {
      isSaving(true);

      final bulkPayload = NilaiUjian(
        kelas_id: mapelData.kelas_id,
        mapel_id: mapelData.mapel_id,
        tahun_ajaran: mapelData.tahun_ajaran,
        semester: mapelData.semester,
        guru_id: 5,
        nilaiSantri: payloadNilai,
      );

      bool sukses = await _nilaiService.submitNilaiUjianBulk(bulkPayload);

      if (sukses) {
        Get.back();
        Get.snackbar('Berhasil', 'Seluruh nilai berhasil disimpan!',
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.find<NilaiUjianController>().fetchMapelGuru();
      }
    } catch (e) {
      Get.snackbar('Gagal', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving(false);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    nilaiControllers.forEach((_, controller) => controller.dispose());
    super.onClose();
  }
}
