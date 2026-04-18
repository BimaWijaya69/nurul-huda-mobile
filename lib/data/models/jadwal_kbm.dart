class JadwalKbm {
  final String hari;
  final String tanggal;
  final List<JadwalKbmItem> jadwal;

  JadwalKbm({
    required this.hari,
    required this.tanggal,
    required this.jadwal,
  });

  factory JadwalKbm.fromJson(Map<String, dynamic> json) {
    return JadwalKbm(
      hari: json['hari'] ?? '',
      tanggal: json['tanggal'] ?? '',
      jadwal: json['jadwal'] != null
          ? List<JadwalKbmItem>.from(
              json['jadwal'].map((x) => JadwalKbmItem.fromJson(x)))
          : [],
    );
  }
}

class JadwalKbmItem {
  final int jadwal_id;
  final int mapel_kelas_id;
  final String nama_mapel;
  final int kelas_id;
  final String jam_mulai;
  final String jam_selesai;
  final bool sudah_absen;
  final String? status_absen;
  final String? ket_izin;

  JadwalKbmItem({
    required this.jadwal_id,
    required this.mapel_kelas_id,
    required this.nama_mapel,
    required this.kelas_id,
    required this.jam_mulai,
    required this.jam_selesai,
    required this.sudah_absen,
    this.status_absen,
    this.ket_izin,
  });

  factory JadwalKbmItem.fromJson(Map<String, dynamic> json) {
    return JadwalKbmItem(
      jadwal_id: json['jadwal_id'] ?? 0,
      mapel_kelas_id: json['mapel_kelas_id'] ?? 0,
      nama_mapel: json['nama_mapel'] ?? '-',
      kelas_id: json['kelas_id'] ?? 0,
      jam_mulai: json['jam_mulai'] ?? '-',
      jam_selesai: json['jam_selesai'] ?? '-',
      sudah_absen: json['sudah_absen'] ?? false,
      status_absen: json['status_absen'],
      ket_izin: json['ket_izin'],
    );
  }
}

class AgendaMengajarItem {
  final String hari;
  final int kelasId;
  final String jamMulai;
  final String jamSelesai;
  final String namaMapel;

  AgendaMengajarItem({
    required this.hari,
    required this.kelasId,
    required this.jamMulai,
    required this.jamSelesai,
    required this.namaMapel,
  });

  factory AgendaMengajarItem.fromJson(Map<String, dynamic> json) {
    return AgendaMengajarItem(
      hari: json['hari'] ?? '-',
      kelasId:
          json['kelas_id'] != null ? int.parse(json['kelas_id'].toString()) : 0,
      jamMulai: json['jam_mulai'] ?? '00:00',
      jamSelesai: json['jam_selesai'] ?? '00:00',
      namaMapel: json['nama_mapel'] ?? '-',
    );
  }

  static List<AgendaMengajarItem> fromList(List<dynamic> jsonList) {
    return jsonList.map((e) => AgendaMengajarItem.fromJson(e)).toList();
  }

  int get hariIndex {
    switch (hari.toLowerCase()) {
      case 'senin':
        return 1;
      case 'selasa':
        return 2;
      case 'rabu':
        return 3;
      case 'kamis':
        return 4;
      case 'jumat':
        return 5;
      case 'sabtu':
        return 6;
      case 'minggu':
      case 'ahad':
        return 7;
      default:
        return 0;
    }
  }
}
