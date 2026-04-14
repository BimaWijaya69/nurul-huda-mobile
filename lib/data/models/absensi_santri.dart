class AbsensiSantri {
  final int kelas_id;
  final String tanggal;
  final List<AbsensiItem> absensi;

  AbsensiSantri({
    required this.kelas_id,
    required this.tanggal,
    required this.absensi,
  });

  Map<String, dynamic> toJson() {
    return {
      'kelas_id': kelas_id,
      'tanggal': tanggal,
      'absensi': absensi.map((e) => e.toJson()).toList(), 
    };
  }
}

class AbsensiItem {
  final int santri_id;
  final int status;

  AbsensiItem({
    required this.santri_id,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'santri_id': santri_id,
      'status': status,
    };
  }
}