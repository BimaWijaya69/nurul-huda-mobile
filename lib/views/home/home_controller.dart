import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nurul_huda_mobile/data/models/jadwal_kbm.dart';
import 'package:nurul_huda_mobile/data/services/jadwal_kbm_service.dart';
import 'package:nurul_huda_mobile/views/auth/auth_controller.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final JadwalKbmService _jadwalService = JadwalKbmService();

  late AnimationController headerAnim;
  late Animation<double> headerFade;
  late Animation<Offset> headerSlide;

  var jamSekarang = ''.obs;
  var tanggalSekarang = ''.obs;
  var namaGuru = ''.obs;
  Timer? _timer;

  final List<Map<String, String>> notifItems = [
    {
      'title': 'Pengumuman Libur Akhir Semester',
      'date': '5 Mar 2026',
      'category': 'Pengumuman',
    },
    {
      'title': 'Jadwal Ujian Kitab Kuning Kelas Wustha',
      'date': '4 Mar 2026',
      'category': 'Akademik',
    },
    {
      'title': 'Penerimaan Santri Baru Tahun Ajaran 2026',
      'date': '1 Mar 2026',
      'category': 'Pendaftaran',
    },
  ];

  var isLoadingJadwal = true.obs;
  var listJadwal = <AgendaMengajarItem>[].obs;
  var currentAddress = 'MENDETEKSI LOKASI...'.obs;
  @override
  void onInit() {
    super.onInit();
    headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: headerAnim, curve: Curves.easeIn),
    );
    headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: headerAnim, curve: Curves.easeOut));

    _updateJam();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateJam();
    });

    fetchJadwalGuru();
    _fetchCurrentAddress();
    namaGuru.value = AuthController.to.currentUser.value?.name ?? '';
  }

  void _updateJam() {
    final now = DateTime.now();
    jamSekarang.value = DateFormat('EEEE HH:mm:ss', 'id_ID').format(now);
    tanggalSekarang.value = DateFormat('d MMMM y', 'id_ID').format(now);
  }

  void replayAnimation() {
    headerAnim.forward(from: 0.0);
  }

  Future<void> refreshData() async {
    _updateJam();
    await fetchJadwalGuru();
    await _fetchCurrentAddress();
  }

  Future<void> fetchJadwalGuru() async {
    try {
      isLoadingJadwal(true);

      int? guruId = AuthController.to.currentUser.value?.id;

      var data = await _jadwalService.getJadwalGuru(guruId!);

      listJadwal.assignAll(data);
    } catch (e) {
      print('Error Fetch Jadwal: $e');
    } finally {
      isLoadingJadwal(false);
    }
  }

  Future<void> _fetchCurrentAddress() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        String desa = place.subLocality ?? '';
        String kecamatan = place.locality ?? '';
        String kabupaten = place.subAdministrativeArea ?? '';

        String formattedAddress = '$desa, $kecamatan, $kabupaten';

        formattedAddress = formattedAddress
            .replaceAll('Kabupaten ', '')
            .replaceAll('Kecamatan ', '')
            .replaceAll('Kec. ', '')
            .replaceAll('Kab. ', '');

        currentAddress.value = formattedAddress.toUpperCase();
      }
    } catch (e) {
      print('Error fetching location: $e');
      currentAddress.value = 'LOKASI TIDAK DITEMUKAN';
    }
  }

  @override
  void onClose() {
    headerAnim.dispose();
    _timer?.cancel();
    super.onClose();
  }
}
