class Periode {
  final String? tahun_ajaran;
  final String? semester;

  Periode({
    this.tahun_ajaran,
    this.semester,
  });

  factory Periode.fromJson(Map<String, dynamic> json) {
    return Periode(
      tahun_ajaran: json['tahun_ajaran'],
      semester: json['semester'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tahun_ajaran': tahun_ajaran,
      'semester': semester,
    };
  }
}
