class NilaiUjian {
  final int kelas_id;
  final int mapel_id;
  final String tahun_ajaran;
  final String semester;
  final int? guru_id;
  final List<NilaiSantriItem> nilaiSantri;

  NilaiUjian({
    required this.kelas_id,
    required this.mapel_id,
    required this.tahun_ajaran,
    required this.semester,
    this.guru_id,
    required this.nilaiSantri,
  });

  Map<String, dynamic> toJson() {
    return {
      'kelas_id': kelas_id,
      'mapel_id': mapel_id,
      'tahun_ajaran': tahun_ajaran,
      'semester': semester,
      'guru_id': guru_id,
      'nilai_santri': nilaiSantri.map((e) => e.toJson()).toList(),
    };
  }
}

class NilaiSantriItem {
  final int santriId;
  final num nilai;

  NilaiSantriItem({
    required this.santriId,
    required this.nilai,
  });

  Map<String, dynamic> toJson() {
    return {
      'santri_id': santriId,
      'nilai': nilai,
    };
  }
}

class MapelUjianItem {
  final int mapel_kelas_id;
  final int mapel_id;
  final int kelas_id;
  final String nama_mapel;
  final bool sudahDinilai;
  final String tahun_ajaran;
  final String semester;

  MapelUjianItem({
    required this.mapel_kelas_id,
    required this.mapel_id,
    required this.kelas_id,
    required this.nama_mapel,
    required this.sudahDinilai,
    required this.tahun_ajaran,
    required this.semester,
  });

  factory MapelUjianItem.fromJson(Map<String, dynamic> json) {
    return MapelUjianItem(
      mapel_kelas_id: json['mapel_kelas_id'] != null
          ? int.parse(json['mapel_kelas_id'].toString())
          : 0,
      mapel_id:
          json['mapel_id'] != null ? int.parse(json['mapel_id'].toString()) : 0,
      kelas_id:
          json['kelas_id'] != null ? int.parse(json['kelas_id'].toString()) : 0,
      nama_mapel: json['nama_mapel'] ?? '-',
      tahun_ajaran: json['tahun_ajaran'] ?? '-',
      semester: json['semester'] ?? '-',
      sudahDinilai: json['sudah_dinilai'] == true ||
          json['sudah_dinilai'] == 1 ||
          json['sudah_dinilai'] == '1' ||
          json['sudah_dinilai'] == 'true',
    );
  }
}
