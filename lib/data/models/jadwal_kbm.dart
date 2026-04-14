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

  JadwalKbmItem({
    required this.jadwal_id,
    required this.mapel_kelas_id,
    required this.nama_mapel,
    required this.kelas_id,
    required this.jam_mulai,
    required this.jam_selesai,
    required this.sudah_absen,
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
    );
  }
}
