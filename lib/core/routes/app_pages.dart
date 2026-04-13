import 'package:get/get.dart';
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
  ];
}
