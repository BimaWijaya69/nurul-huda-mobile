class Kelas {
  final int? id;
  final String? nama_kelas;

  Kelas({
    this.id,
    this.nama_kelas,
  });

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      id: json['id'],
      nama_kelas: json['nama_kelas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kelas': nama_kelas,
    };
  }
}
