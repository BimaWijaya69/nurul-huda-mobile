import 'package:nurul_huda_mobile/data/models/guru.dart';
import 'package:nurul_huda_mobile/data/models/kelas.dart';
import 'package:nurul_huda_mobile/data/models/mapel.dart';

class MapelKelas {
  final int? id;
  final int? kelas_id;
  final int? mapel_id;
  final int? guru_id;
  final Mapel? mapel;
  final Guru? guru;
  final Kelas? kelas;
  final bool? is_created;

  MapelKelas({
    this.id,
    this.kelas_id,
    this.mapel_id,
    this.guru_id,
    this.mapel,
    this.guru,
    this.kelas,
    this.is_created,
  });

  factory MapelKelas.fromJson(Map<String, dynamic> json) {
    return MapelKelas(
      id: json['id'],
      kelas_id: json['kelas_id'],
      mapel_id: json['mapel_id'],
      guru_id: json['guru_id'],
      mapel: json['mapel'] != null ? Mapel.fromJson(json['mapel']) : null,
      guru: json['guru'] != null ? Guru.fromJson(json['guru']) : null,
      kelas: json['kelas'] != null ? Kelas.fromJson(json['kelas']) : null,
      is_created: json['is_created'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kelas_id': kelas_id,
      'mapel_id': mapel_id,
      'guru_id': guru_id,
      'mapel': mapel?.toJson(),
      'guru': guru?.toJson(),
      'kelas': kelas?.toJson(),
      'is_created': is_created,
    };
  }
}
