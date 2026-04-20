import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nurul_huda_mobile/data/models/user.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  final box = GetStorage();

  Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  void _loadUserFromStorage() {
    var data = box.read('user_data');
    if (data != null) {
      currentUser.value = User.fromJson(data);
    }
  }

  void saveUser(User user) {
    currentUser.value = user;
    box.write('user_data', user.toJson());
  }

  void clearAuth() {
    currentUser.value = null;
    box.erase();
  }
}
