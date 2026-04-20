import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nurul_huda_mobile/data/models/absensi_guru.dart';
import 'package:nurul_huda_mobile/data/services/absensi_service.dart';

class RekapAbsensiController extends GetxController {
  final AbsensiService _service = AbsensiService();
  var selectedDate = DateTime.now().obs;
  var isLoading = true.obs;
  var rekapData = Rxn<RekapAbsensiModel>();

  var filterStatus = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchRekap();
  }

  Future<void> fetchRekap() async {
    try {
      isLoading(true);
      var data = await _service.getRekapBulanan(
          guruId: 15,
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
    if (filterStatus.value == null) return rekapData.value!.detail;

    return rekapData.value!.detail
        .where((d) => d.status == filterStatus.value)
        .toList();
  }
}
