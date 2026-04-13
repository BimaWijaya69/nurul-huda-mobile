class Soal {
  final int mapel_kelas_id;
  final List<String> soal;
  final String tahun_ajaran;
  final String semester;

  Soal({
    required this.mapel_kelas_id,
    required this.soal,
    required this.tahun_ajaran,
    required this.semester,
  });

  Map<String, dynamic> toJson() {
    return {
      'mapel_kelas_id': mapel_kelas_id,
      'soal': soal,
      'tahun_ajaran': tahun_ajaran,
      'semester': semester,
    };
  }

  factory Soal.fromJson(Map<String, dynamic> json) {
    return Soal(
      mapel_kelas_id: json['mapel_kelas_id'],
      soal: List<String>.from(json['soal'] ?? []),
      tahun_ajaran: json['tahun_ajaran'],
      semester: json['semester'],
    );
  }
}
