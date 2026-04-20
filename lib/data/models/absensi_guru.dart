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

  AbsensiSummary({
    this.hadir = 0,
    this.izin = 0,
    this.alfa = 0,
  });

  factory AbsensiSummary.fromJson(Map<String, dynamic> json) {
    return AbsensiSummary(
      hadir: json['hadir'] ?? 0,
      izin: json['izin'] ?? 0,
      alfa: json['alfa'] ?? 0,
    );
  }
}

// Model khusus untuk list detail di bawah kalender
class AbsensiDetail {
  final DateTime? tanggal;
  final String status;
  final String namaMapel;
  final int kelasId;
  final String? keterangan; // Nullable karena kalau hadir/alfa biasanya kosong

  AbsensiDetail({
    this.tanggal,
    required this.status,
    required this.namaMapel,
    required this.kelasId,
    this.keterangan,
  });

  factory AbsensiDetail.fromJson(Map<String, dynamic> json) {
    return AbsensiDetail(
      // Konversi YYYY-MM-DD jadi DateTime biar gampang diolah kalender
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
