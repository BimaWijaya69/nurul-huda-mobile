import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SantriNilaiUIModel {
  final int santriId;
  final String nama;
  final String nis;

  final TextEditingController nilaiController;

  SantriNilaiUIModel({
    required this.santriId,
    required this.nama,
    required this.nis,
    String nilaiAwal = '',
  }) : nilaiController = TextEditingController(text: nilaiAwal);
}

class InputNilaiController extends GetxController {
  var jadwalId = 0.obs;
  var namaMapel = 'Taisirul Kholaq'.obs;
  var namaKelas = 'Kelas I'.obs;

  var listSantri = <SantriNilaiUIModel>[
    SantriNilaiUIModel(santriId: 101, nama: 'Ahmad Dahlan', nis: '2026001'),
    SantriNilaiUIModel(
        santriId: 102, nama: 'Bima Al-Fatih', nis: '2026002', nilaiAwal: '85'),
    SantriNilaiUIModel(santriId: 103, nama: 'Chairil Anwar', nis: '2026003'),
    SantriNilaiUIModel(santriId: 104, nama: 'Dimas Anggara', nis: '2026004'),
    SantriNilaiUIModel(santriId: 105, nama: 'Eko Putra', nis: '2026005'),
  ].obs;

  var filteredListSantri = <SantriNilaiUIModel>[].obs;

  final TextEditingController searchController = TextEditingController();
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      jadwalId.value = Get.arguments as int;
      // TODO: Hit API Backend untuk mengambil daftar santri berdasarkan jadwalId
    }
    filteredListSantri.assignAll(listSantri);
  }

  void searchSantri(String keyword) {
    searchQuery.value = keyword;
    if (keyword.isEmpty) {
      filteredListSantri.assignAll(listSantri);
    } else {
      filteredListSantri.assignAll(listSantri
          .where((santri) =>
              santri.nama.toLowerCase().contains(keyword.toLowerCase()))
          .toList());
    }
  }

  void simpanNilai() {
    List<Map<String, dynamic>> payloadNilai = [];

    for (var santri in listSantri) {
      // Hanya kirim santri yang nilainya diketik (tidak kosong)
      if (santri.nilaiController.text.isNotEmpty) {
        payloadNilai.add({
          'santri_id': santri.santriId,
          'mapel_id': jadwalId.value, // Sesuai dengan jadwal yang sedang dibuka
          'nilai': int.tryParse(santri.nilaiController.text) ?? 0,
        });
      }
    }

    // 2. Tampilkan di console untuk memastikan data sudah klop dengan Laravel
    print("🚀 MENGIRIM PAYLOAD KE BACKEND LARAVEL:");
    print(payloadNilai);

    // 3. Tampilkan pesan sukses
    Get.snackbar(
      'Alhamdulillah',
      'Nilai berhasil disimpan!',
      backgroundColor: const Color(0xFF1B7A3E),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    for (var santri in listSantri) {
      santri.nilaiController.dispose();
    }
    super.onClose();
  }
}
