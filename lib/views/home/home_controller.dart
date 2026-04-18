import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController headerAnim;
  late Animation<double> headerFade;
  late Animation<Offset> headerSlide;

  var currentTime = DateTime.now().obs;
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

  String get dayAndTimeStr {
    return DateFormat('EEEE HH:mm', 'id_ID').format(currentTime.value);
  }

  String get fullDateStr {
    return DateFormat('d MMMM y', 'id_ID').format(currentTime.value);
  }

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

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateTime.now();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    headerAnim.dispose();
    super.onClose();
  }

  Future<void> refreshHome() async {
    await Future.delayed(const Duration(milliseconds: 800));
    currentTime.value = DateTime.now();
  }
}
