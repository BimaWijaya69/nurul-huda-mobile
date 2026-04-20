import 'package:get/get.dart';
import 'package:nurul_huda_mobile/views/absensi/create/absensi_form.dart';
import 'package:nurul_huda_mobile/views/notifikasi/notifikasi_page.dart';
import 'package:nurul_huda_mobile/views/absensi/rekap/rekap_page.dart';
import 'package:nurul_huda_mobile/views/nilai_ujian/create/nilai_form.dart';
import 'package:nurul_huda_mobile/views/scan_qr/scan_qr_page.dart';
import 'package:nurul_huda_mobile/views/soal/create/soal_form.dart';
import 'package:nurul_huda_mobile/views/soal/preview/soal_preview.dart';
import 'package:nurul_huda_mobile/views/started/get_started.dart';
import 'package:nurul_huda_mobile/views/layout.dart';

class AppPages {
  static final Pages = [
    GetPage(
      name: '/started',
      page: () => const GetStartedScreen(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: '/layout',
      page: () => const Layout(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: '/create-soal',
      page: () => const SoalForm(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: '/preview-soal',
      page: () => SoalPreview(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: '/create-absensi',
      page: () => const AbsensiForm(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: '/notifikasi',
      page: () => const NotifikasiPage(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: '/edit-absensi',
      page: () => const AbsensiForm(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: '/rekap-absensi',
      page: () => const RekapAbsensiPage(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: '/create-nilai',
      page: () => const NilaiFormPage(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: '/scan-qr',
      page: () => const ScanQrPage(),
      transition: Transition.leftToRight,
    ),
  ];
}
