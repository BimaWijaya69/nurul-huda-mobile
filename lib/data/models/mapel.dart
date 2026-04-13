class Mapel {
  final int? id;
  final String? nama_mapel;

  Mapel({
    this.id,
    this.nama_mapel,
  });

  factory Mapel.fromJson(Map<String, dynamic> json) {
    return Mapel(
      id: json['id'],
      nama_mapel: json['nama_mapel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_mapel': nama_mapel,
    };
  }
}
