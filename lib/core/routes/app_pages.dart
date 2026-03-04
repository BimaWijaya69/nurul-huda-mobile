import 'package:get/get.dart';
import 'package:nurul_huda_mobile/views/started/get_started.dart';

class AppPages {
  static final Pages = [
    GetPage(
        name: '/started',
        page: () => const GetStartedScreen(),
        transition: Transition.leftToRight),
  ];
}
