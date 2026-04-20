class AbsensiGuru {
  final int mapel_kelas_id;
  final int status;
  final String tanggal;
  final String? materi_pembelajaran;
  final String? ket_izin;

  AbsensiGuru({
    required this.mapel_kelas_id,
    required this.status,
    required this.tanggal,
    this.materi_pembelajaran,
    this.ket_izin,
  });

  Map<String, dynamic> toJson() {
    return {
      'mapel_kelas_id': mapel_kelas_id,
      'status': status,
      'tanggal': tanggal,
      'materi_pembelajaran': materi_pembelajaran,
      'ket_izin': ket_izin,
    };
  }
}

class RekapAbsensiModel {
  final String semester;
  final String tahunAjaran;
  final AbsensiSummary summary;
  final List<AbsensiDetail> detail;

  RekapAbsensiModel({
    this.semester = '-',
    this.tahunAjaran = '-',
    required this.summary,
    required this.detail,
  });

  factory RekapAbsensiModel.fromJson(Map<String, dynamic> json) {
    return RekapAbsensiModel(
      semester: json['semester'] ?? '-',
      tahunAjaran: json['tahun_ajaran'] ?? '-',
      summary: json['summary'] != null
          ? AbsensiSummary.fromJson(json['summary'])
          : AbsensiSummary(),
      detail: json['detail'] != null
          ? (json['detail'] as List)
              .map((i) => AbsensiDetail.fromJson(i))
              .toList()
          : [],
    );
  }
}

class AbsensiSummary {
  final int hadir;
  final int izin;
  final int alfa;
  final int sakit;

  AbsensiSummary({
    this.hadir = 0,
    this.izin = 0,
    this.alfa = 0,
    this.sakit = 0,
  });

  factory AbsensiSummary.fromJson(Map<String, dynamic> json) {
    return AbsensiSummary(
      hadir: json['hadir'] ?? 0,
      izin: json['izin'] ?? 0,
      alfa: json['alfa'] ?? 0,
      sakit: json['sakit'] ?? 0,
    );
  }
}

class AbsensiDetail {
  final DateTime? tanggal;
  final String status;
  final String namaMapel;
  final int kelasId;
  final String? keterangan;

  AbsensiDetail({
    this.tanggal,
    required this.status,
    required this.namaMapel,
    required this.kelasId,
    this.keterangan,
  });

  factory AbsensiDetail.fromJson(Map<String, dynamic> json) {
    return AbsensiDetail(
      tanggal:
          json['tanggal'] != null ? DateTime.tryParse(json['tanggal']) : null,
      status: json['status'] ?? 'none',
      namaMapel: json['nama_mapel'] ?? '-',
      kelasId:
          json['kelas_id'] != null ? int.parse(json['kelas_id'].toString()) : 0,
      keterangan: json['keterangan'],
    );
  }
}
