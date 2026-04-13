import 'package:get/get.dart';

class JadwalUjianUIModel {
  final int id;
  final String tanggalUjian;
  final String namaMapel;
  final String namaKelas;
  final bool isDinilai; // Tambahan untuk memicu desain badge dari Mas Ifan

  JadwalUjianUIModel({
    required this.id,
    required this.tanggalUjian,
    required this.namaMapel,
    required this.namaKelas,
    required this.isDinilai,
  });
}

class DaftarNilaiController extends GetxController {
  var listJadwal = <JadwalUjianUIModel>[
    JadwalUjianUIModel(
      id: 1,
      tanggalUjian: '12 Apr 2026',
      namaMapel: 'عقيدة العوام', // Aqidatul Awam
      namaKelas: 'Sifir',
      isDinilai: false,
    ),
    JadwalUjianUIModel(
      id: 2,
      tanggalUjian: '14 Apr 2026',
      namaMapel: 'تيسير الخلاق', // Taisirul Kholaq
      namaKelas: 'I',
      isDinilai: true,
    ),
    JadwalUjianUIModel(
      id: 3,
      tanggalUjian: '18 Apr 2026',
      namaMapel: 'جواهر الكلامية', // Jawahirul Kalamiyyah
      namaKelas: 'II',
      isDinilai: false,
    ),
    JadwalUjianUIModel(
      id: 4,
      tanggalUjian: '19 Apr 2026',
      namaMapel: 'فتح القريب ١', // Fathul Qorib 1
      namaKelas: 'III',
      isDinilai: false,
    ),
  ].obs;

  void bukaInputNilai(int idJadwal) {
    print("Membuka form nilai untuk ID Jadwal: $idJadwal");
    // Nanti lempar ID jadwal ini ke halaman Input Nilai
    // Get.toNamed('/input-nilai', arguments: idJadwal);
  }
}
