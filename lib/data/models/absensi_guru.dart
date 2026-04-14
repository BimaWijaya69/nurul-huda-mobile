class AbsensiGuru {
  final int mapel_kelas_id;
  final int status;
  final String tanggal;
  final String? materi_pembelajaran;
  final String? ketIzin;

  AbsensiGuru({
    required this.mapel_kelas_id,
    required this.status,
    required this.tanggal,
    this.materi_pembelajaran,
    this.ketIzin,
  });

  Map<String, dynamic> toJson() {
    return {
      'mapel_kelas_id': mapel_kelas_id,
      'status': status,
      'tanggal': tanggal,
      'materi_pembelajaran': materi_pembelajaran,
      'ket_izin': ketIzin,
    };
  }
}
