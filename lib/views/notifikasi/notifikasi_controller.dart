import 'package:get/get.dart';

//dummy
class NotifUIModel {
  final int id;
  final String judul;
  final String pesan;
  final String waktu;
  final String tipe;
  var isRead = false.obs;

  NotifUIModel({
    required this.id,
    required this.judul,
    required this.pesan,
    required this.waktu,
    required this.tipe,
    bool read = false,
  }) {
    isRead.value = read;
  }
}

class NotifikasiController extends GetxController {
  var selectedFilter = 'Semua'.obs;

  var listNotif = <NotifUIModel>[
    NotifUIModel(
      id: 1,
      judul: 'Jadwal Mengajar Hari Ini',
      pesan:
          'Anda memiliki jadwal mengajar di Kelas Sifir pada pukul 15:30. Jangan lupa melakukan absensi.',
      waktu: '10 menit yang lalu',
      tipe: 'Absensi',
      read: false,
    ),
    NotifUIModel(
      id: 2,
      judul: 'Batas Waktu Input Hasil Ujian',
      pesan:
          'Batas akhir pengisian hasil ujian kelas Wustha adalah besok tanggal 17 April 2026.',
      waktu: '2 jam yang lalu',
      tipe: 'Nilai',
      read: false,
    ),
    NotifUIModel(
      id: 3,
      judul: 'Rapat Evaluasi Bulanan',
      pesan:
          'Diharapkan kehadiran seluruh asatidz di ruang rapat utama ba\'da Isya.',
      waktu: 'Kemarin',
      tipe: 'Pengumuman',
      read: true, // Ini sudah dibaca
    ),
  ].obs;

  List<NotifUIModel> get filteredNotif {
    if (selectedFilter.value == 'Semua') {
      return listNotif;
    }
    return listNotif
        .where((notif) => notif.tipe == selectedFilter.value)
        .toList();
  }

  void ubahFilter(String kategori) {
    selectedFilter.value = kategori;
  }

  void tandaiSudahDibaca(NotifUIModel notif) {
    if (!notif.isRead.value) {
      notif.isRead.value = true;
      // TODO: Disini nanti tambahkan logic tembak API untuk update status read di database
    }
  }

  void tandaiSemuaDibaca() {
    for (var notif in listNotif) {
      notif.isRead.value = true;
    }
  }
}
