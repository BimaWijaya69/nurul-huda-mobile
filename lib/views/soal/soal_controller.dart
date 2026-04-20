import 'package:get/get.dart';
import 'package:nurul_huda_mobile/data/models/mapel_kelas.dart';
import 'package:nurul_huda_mobile/data/models/periode.dart';
import 'package:nurul_huda_mobile/data/services/soal_service.dart';
import 'package:nurul_huda_mobile/views/auth/auth_controller.dart';

class SoalController extends GetxController {
  final SoalService _service = SoalService();

  var isLoading = true.obs;
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
      int? guruId = AuthController.to.currentUser.value?.id;
      var response = await _service.getMapelKelas(guruId!);
      periodeAktif.value = Periode.fromJson(response);
      List<dynamic> rawData = (response['data'] as List<dynamic>?) ?? [];

      listMapel.assignAll(rawData
          .map((item) => MapelKelas.fromJson(item as Map<String, dynamic>))
          .toList());
    } catch (e) {
      Get.snackbar('Kesalahan', 'Gagal mengambil data: $e');
      print('Error detail: $e');
    } finally {
      isLoading(false);
    }
  }
}
