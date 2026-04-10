class SoalModel {
  final int id;
  String soalLatin;
  String soalPegon;
  String pedomanEssay; // untuk essay

  SoalModel({
    required this.id,
    this.soalLatin = '',
    this.soalPegon = '',
    this.pedomanEssay = '',
  });

  SoalModel copyWith({
    int? id,
    String? soalLatin,
    String? soalPegon,
    String? pedomanEssay,
  }) {
    return SoalModel(
      id: id ?? this.id,
      soalLatin: soalLatin ?? this.soalLatin,
      soalPegon: soalPegon ?? this.soalPegon,
      pedomanEssay: pedomanEssay ?? this.pedomanEssay,
    );
  }
}
