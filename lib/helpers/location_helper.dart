import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static const double pondokLat = -8.171286;
  static const double pondokLng = 113.276245;
  static const double radiusMaksimal = 30.0;

  // LOK PONDOK -8.193764, 113.283610
  // LOK BESKEM -8.171286, 113.276245
  // LOK KAMPUS -8.139614173133053, 113.24271588160954

  static Future<bool> isWithinRadius() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('GPS belum aktif. Mohon nyalakan GPS Anda.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak. Tidak bisa melakukan absensi.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Izin lokasi diblokir permanen. Buka pengaturan HP untuk mengizinkan.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (position.isMocked) {
      throw Exception('Terdeteksi menggunakan Fake GPS! Absensi ditolak.');
    }

    double distanceInMeters = Geolocator.distanceBetween(
      pondokLat,
      pondokLng,
      position.latitude,
      position.longitude,
    );

    return distanceInMeters <= radiusMaksimal;
  }
}
