import 'package:get/get.dart';

class LayoutController extends GetxController {
  final RxInt tabIndex = 0.obs; // default ke Beranda (index 2)

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}
