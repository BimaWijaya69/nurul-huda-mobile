enum TipeSoal { pg, essay, isian, benarSalah }

class SoalModel {
  final int id;
  TipeSoal tipe;
  String soalLatin;
  String soalPegon;
  List<String> pilihan; // untuk PG
  int kunciIndex; // PG: index 0-3, B/S: 1=benar 0=salah, -1=belum dipilih
  String kunciIsian; // untuk isian singkat
  String pedomanEssay; // untuk essay
  int bobot;

  SoalModel({
    required this.id,
    this.tipe = TipeSoal.pg,
    this.soalLatin = '',
    this.soalPegon = '',
    List<String>? pilihan,
    this.kunciIndex = -1,
    this.kunciIsian = '',
    this.pedomanEssay = '',
    this.bobot = 10,
  }) : pilihan = pilihan ?? ['', '', '', ''];

  SoalModel copyWith({
    int? id,
    TipeSoal? tipe,
    String? soalLatin,
    String? soalPegon,
    List<String>? pilihan,
    int? kunciIndex,
    String? kunciIsian,
    String? pedomanEssay,
    int? bobot,
  }) {
    return SoalModel(
      id: id ?? this.id,
      tipe: tipe ?? this.tipe,
      soalLatin: soalLatin ?? this.soalLatin,
      soalPegon: soalPegon ?? this.soalPegon,
      pilihan: pilihan ?? List.from(this.pilihan),
      kunciIndex: kunciIndex ?? this.kunciIndex,
      kunciIsian: kunciIsian ?? this.kunciIsian,
      pedomanEssay: pedomanEssay ?? this.pedomanEssay,
      bobot: bobot ?? this.bobot,
    );
  }

  String get tipeLabel {
    switch (tipe) {
      case TipeSoal.pg:
        return 'PG';
      case TipeSoal.essay:
        return 'Essay';
      case TipeSoal.isian:
        return 'Isian';
      case TipeSoal.benarSalah:
        return 'B/S';
    }
  }
}
