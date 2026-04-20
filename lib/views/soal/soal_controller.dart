import 'package:get/get.dart';
import 'package:nurul_huda_mobile/data/models/mapel_kelas.dart';
import 'package:nurul_huda_mobile/data/models/periode.dart';
import 'package:nurul_huda_mobile/data/services/soal_service.dart';
import 'package:nurul_huda_mobile/views/auth/auth_controller.dart';

class SoalController extends GetxController {
  final SoalService _service = SoalService();

  var isLoading = true.obs;

  var isError = false.obs;
  var errorType = 'server'.obs;
  var errorMessage = ''.obs;

  var listMapel = <MapelKelas>[].obs;
  var periodeAktif = Periode().obs;

  @override
  void onInit() {
    super.onInit();
    fetchMapelKelas();
  }

  Future<void> fetchMapelKelas() async {
    try {
      isLoading(true);
      isError(false);
      errorMessage('');

      int? guruId = AuthController.to.currentUser.value?.id;
      var response = await _service.getMapelKelas(guruId!);
      periodeAktif.value = Periode.fromJson(response);
      List<dynamic> rawData = (response['data'] as List<dynamic>?) ?? [];

      listMapel.assignAll(rawData
          .map((item) => MapelKelas.fromJson(item as Map<String, dynamic>))
          .toList());
    } catch (e) {
      isError(true);
      String errorMsg = e.toString().toLowerCase();

      if (errorMsg.contains('timeout') || errorMsg.contains('waktu habis')) {
        errorType.value = 'timeout';
      } else if (errorMsg.contains('internet') ||
          errorMsg.contains('network') ||
          errorMsg.contains('socket')) {
        errorType.value = 'network';
      } else if (errorMsg.contains('401') ||
          errorMsg.contains('unauthorized')) {
        errorType.value = 'unauthorized';
      } else {
        errorType.value = 'server';
        errorMessage(
            e.toString()); // Simpan pesan asli jika error tidak dikenali
      }

      // Get.snackbar('Error', e.toString(),
      //     backgroundColor: Colors.red, colorText: Colors.white); // Tambahkan ini biar kalau ada error, gampang dilacak di console
    } finally {
      isLoading(false);
    }
  }
}
