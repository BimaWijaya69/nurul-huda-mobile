import 'package:nurul_huda_mobile/data/models/kelas.dart';

class Santri {
  final int? id;
  final String? nama;
  final String? nis;
  final int? kelas_id;
  final Kelas? kelas;

  Santri({this.id, this.nama, this.nis, this.kelas_id, this.kelas});

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      id: json['id'],
      nama: json['nama'],
      nis: json['nis'],
      kelas_id: json['kelas_id'],
      kelas: json['kelas'] != null ? Kelas.fromJson(json['kelas']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'nis': nis,
      'kelas_id': kelas_id,
      'kelas': kelas != null ? kelas!.toJson() : null,
    };
  }
}

class SantriAbsenUi {
  final Santri santri;
  int status; 

  SantriAbsenUi({
    required this.santri,
    this.status = 1, 
  });
}
