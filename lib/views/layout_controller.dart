import 'package:get/get.dart';
import 'package:nurul_huda_mobile/views/home/home_controller.dart';

class LayoutController extends GetxController {
  final RxInt tabIndex = 2.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
    if (index == 2) {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().replayAnimation();
      }
    }
  }
}
