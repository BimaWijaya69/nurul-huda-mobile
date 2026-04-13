class ArabicHelper {
  static String getKelasArab(int? kelasId) {
    if (kelasId == null) return '-';

    const Map<int, String> arabMap = {
      1: 'صفر',
      2: 'الأول',
      3: 'الثاني',
      4: 'الثالث',
      5: 'الرابع',
      6: 'الخامس',
      7: 'السادس',
    };

    return arabMap[kelasId] ?? kelasId.toString();
  }
}
