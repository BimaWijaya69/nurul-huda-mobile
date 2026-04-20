import 'package:get/get.dart';
import 'package:nurul_huda_mobile/data/models/absensi_guru.dart';
import 'package:nurul_huda_mobile/data/services/absensi_service.dart';
import 'package:nurul_huda_mobile/views/auth/auth_controller.dart';

class RekapAbsensiController extends GetxController {
  final AbsensiService _service = AbsensiService();
  var selectedDate = DateTime.now().obs;
  var isLoading = true.obs;
  var rekapData = Rxn<RekapAbsensiModel>();

  var filterStatus = RxnString();
  var filterDate = RxnInt();

  @override
  void onInit() {
    super.onInit();
    fetchRekap();
  }

  Future<void> fetchRekap() async {
    int? guruId = AuthController.to.currentUser.value?.id;
    try {
      isLoading(true);
      var data = await _service.getRekapBulanan(
          guruId: guruId!,
          bulan: selectedDate.value.month,
          tahun: selectedDate.value.year);
      rekapData.value = data;
    } finally {
      isLoading(false);
    }
  }

  void nextMonth() {
    selectedDate.value =
        DateTime(selectedDate.value.year, selectedDate.value.month + 1);
    fetchRekap();
  }

  void prevMonth() {
    selectedDate.value =
        DateTime(selectedDate.value.year, selectedDate.value.month - 1);
    fetchRekap();
  }

  void setFilter(String? status) {
    if (filterStatus.value == status) {
      filterStatus.value = null;
    } else {
      filterStatus.value = status;
      filterDate.value = null;
    }
  }

  void setFilterDate(int? day) {
    if (day == null) {
      filterDate.value = null;
      return;
    }

    if (filterDate.value == day) {
      filterDate.value = null;
    } else {
      filterDate.value = day;
      filterStatus.value = null;
    }
  }

  String getStatusForDate(int day) {
    if (rekapData.value == null) return 'none';

    final match = rekapData.value!.detail.firstWhereOrNull((d) =>
        d.tanggal?.day == day &&
        d.tanggal?.month == selectedDate.value.month &&
        d.tanggal?.year == selectedDate.value.year);

    return match?.status ?? 'none';
  }

  List<AbsensiDetail> get filteredDetails {
    if (rekapData.value == null) return [];

    var list = rekapData.value!.detail;

    if (filterStatus.value != null) {
      list = list.where((d) => d.status == filterStatus.value).toList();
    }

    if (filterDate.value != null) {
      list = list.where((d) => d.tanggal?.day == filterDate.value).toList();
    }

    return list;
  }
}
