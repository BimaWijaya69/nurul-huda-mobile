import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nurul_huda_mobile/data/models/jadwal_kbm.dart';
import 'package:nurul_huda_mobile/data/services/jadwal_kbm_service.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final JadwalKbmService _jadwalService = JadwalKbmService();

  late AnimationController headerAnim;
  late Animation<double> headerFade;
  late Animation<Offset> headerSlide;

  var jamSekarang = ''.obs;
  var tanggalSekarang = ''.obs;
  Timer? _timer;

  var isLoadingJadwal = true.obs;
  var listJadwal = <AgendaMengajarItem>[].obs;

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
  }

  Future<void> fetchJadwalGuru() async {
    try {
      isLoadingJadwal(true);

      int guruId = 15;

      var data = await _jadwalService.getJadwalGuru(guruId);

      listJadwal.assignAll(data);
    } catch (e) {
      print('Error Fetch Jadwal: $e');
    } finally {
      isLoadingJadwal(false);
    }
  }

  @override
  void onClose() {
    headerAnim.dispose();
    _timer?.cancel();
    super.onClose();
  }
}
