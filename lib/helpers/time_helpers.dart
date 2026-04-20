class TimeHelper {
  static bool isTimeExpired(String jamSelesai) {
    try {
      final now = DateTime.now();
      final parts = jamSelesai.split(':');
      final expirationTime = DateTime(now.year, now.month, now.day,
          int.parse(parts[0]), int.parse(parts[1]));

      return now.isAfter(expirationTime);
    } catch (e) {
      return false;
    }
  }

  static bool isBeforeStartTime(String jamMulai) {
    try {
      final now = DateTime.now();
      final parts = jamMulai.split(':');
      final startTime = DateTime(now.year, now.month, now.day,
          int.parse(parts[0]), int.parse(parts[1]));

      return now.isBefore(startTime);
    } catch (e) {
      return false;
    }
  }

  static bool isTimeInRange(String jamMulai, String jamSelesai) {
    return !isBeforeStartTime(jamMulai) && !isTimeExpired(jamSelesai);
  }
}
