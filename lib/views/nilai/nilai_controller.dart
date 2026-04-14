import 'package:get/get.dart';
import 'package:nurul_huda_mobile/views/nilai/create/nilai_form.dart';

class JadwalUjianUIModel {
  final int id;
  final String tanggalUjian;
  final String namaMapel;
  final String namaKelas;
  final bool isDinilai;

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
      namaKelas: 'صفر',
      isDinilai: false,
    ),
    JadwalUjianUIModel(
      id: 2,
      tanggalUjian: '14 Apr 2026',
      namaMapel: 'تيسير الخلاق', // Taisirul Kholaq
      namaKelas: '',
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
    Get.to(() => const InputNilaiPage(), arguments: idJadwal);
  }
}
