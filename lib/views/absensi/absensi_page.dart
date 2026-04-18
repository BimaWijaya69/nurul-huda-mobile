import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/core/routes/app_routes.dart';
import 'package:nurul_huda_mobile/data/models/jadwal_kbm.dart';
import 'package:nurul_huda_mobile/helpers/arabic_helper.dart';
import 'package:nurul_huda_mobile/views/absensi/absensi_controller.dart';
import 'package:nurul_huda_mobile/views/widgets/custom_text_field.dart';
import 'package:nurul_huda_mobile/widget/error.dart';
import 'package:nurul_huda_mobile/widget/skeleton_card.dart';

class AbsensiPage extends StatelessWidget {
  AbsensiPage({Key? key}) : super(key: key);

  static const Color _green = Color(0xFF1B7A3E);
  static const Color _bgLight = Color(0xFFF8FAFC);

  final AbsensiController controller = Get.put(AbsensiController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _bgLight,
        body: Obx(() {
          return Column(
            children: [
              _buildCustomAppBar(context),
              Expanded(
                child: _buildContent(),
              ),
            ],
          );
        }));
  }

  Widget _buildContent() {
    if (controller.isLoading.value) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, index) {
          return const SkeletonCard();
        },
      );
    }
    if (controller.isError.value) {
      String type = controller.errorType.value;

      switch (type) {
        case 'network':
          return ErrorStateWidget.network(
            onRetry: () => controller.fetchJadwalHariIni(),
          );
        case 'timeout':
          return ErrorStateWidget.timeout(
            onRetry: () => controller.fetchJadwalHariIni(),
          );
        case 'unauthorized':
          return ErrorStateWidget.unauthorized(
            onRetry: () {
              // Get.offAllNamed(Routes.LOGIN);
            },
          );
        case 'server':
        default:
          return ErrorStateWidget.server(
            onRetry: () => controller.fetchJadwalHariIni(),
          );
      }
    }

    if (controller.listJadwal.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: controller.listJadwal.length,
      itemBuilder: (context, index) {
        return _buildJadwalCard(context, controller.listJadwal[index]);
      },
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Absensi Mengajar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                      'Hari ini ${controller.hariIni.value}, ${controller.tanggalLengkap.value}',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available_rounded,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('Tidak ada jadwal mengajar hari ini.',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
        ],
      ),
    );
  }

  // --- KARTU JADWAL MENGAJAR DINAMIS  ---
  Widget _buildJadwalCard(BuildContext context, JadwalKbmItem jadwal) {
    bool sudahAbsen = jadwal.sudah_absen;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: sudahAbsen ? _green.withOpacity(0.5) : Colors.transparent),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: sudahAbsen
              ? () => Get.snackbar('Info', 'Kelas ini sudah diabsen hari ini.',
                  backgroundColor: Colors.blue, colorText: Colors.white)
              : () => _showAbsensiBottomSheet(context, jadwal),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: sudahAbsen
                          ? Colors.green.shade50
                          : _green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(
                      sudahAbsen
                          ? Icons.check_circle_rounded
                          : Icons.menu_book_rounded,
                      color: _green,
                      size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(jadwal.nama_mapel,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(
                                ArabicHelper.getKelasArab(jadwal.kelas_id),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.access_time_rounded,
                              size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text('${jadwal.jam_mulai} - ${jadwal.jam_selesai}',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                    ],
                  ),
                ),
                sudahAbsen
                    ? const Text('Selesai',
                        style: TextStyle(
                            color: _green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12))
                    : const Icon(Icons.chevron_right_rounded,
                        color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- POP-UP BOTTOM SHEET  ---
  void _showAbsensiBottomSheet(BuildContext context, JadwalKbmItem jadwal) {
    String selectedStatus = 'Hadir';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          bool isHadir = selectedStatus == 'Hadir';
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 24,
                left: 24,
                right: 24),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 20),
                Text('Absensi Guru: ${jadwal.nama_mapel}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                    '${ArabicHelper.getKelasArab(jadwal.kelas_id)} • ${jadwal.jam_mulai} - ${jadwal.jam_selesai}',
                    style: TextStyle(color: Colors.grey.shade600)),
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider()),
                const Text('Status Kehadiran Anda:',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatusOption(
                        'Hadir',
                        Icons.check_circle_rounded,
                        Colors.green,
                        selectedStatus,
                        (val) => setState(() => selectedStatus = val)),
                    const SizedBox(width: 12),
                    _buildStatusOption(
                        'Sakit',
                        Icons.sick_rounded,
                        Colors.orange,
                        selectedStatus,
                        (val) => setState(() => selectedStatus = val)),
                    const SizedBox(width: 12),
                    _buildStatusOption(
                        'Izin',
                        Icons.assignment_late_rounded,
                        Colors.blue,
                        selectedStatus,
                        (val) => setState(() => selectedStatus = val)),
                  ],
                ),
                const SizedBox(height: 24),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: isHadir
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.toNamed(Routes.CREATE_ABSENSI,
                            arguments: {'jadwal': jadwal});
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text('Lanjut Absen Santri',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => CustomTextField(
                            controller: controller.alasanController,
                            title: 'Keterangan / Alasan',
                            icon: Icons.edit_note_rounded,
                            hintText: 'Tulis keterangan tidak hadir di sini...',
                            maxLines: 3,
                            isRequired: true,
                            errorText: controller.alasanError.value,
                          )),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(() {
                          bool isLoading = controller.isSubmitting.value;

                          return ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    controller.submitIzinGuru(
                                      mapel_kelas_id: jadwal.mapel_kelas_id,
                                      label_status: selectedStatus,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: _green,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2))
                                : Text('Kirim Izin',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  // --- WIDGET PILIHAN STATUS ---
  Widget _buildStatusOption(String title, IconData icon, Color color,
      String selectedValue, Function(String) onTap) {
    bool isSelected = selectedValue == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : Colors.white,
            border: Border.all(
                color: isSelected ? color : Colors.grey.shade300, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: isSelected ? color : Colors.grey.shade400, size: 28),
              const SizedBox(height: 4),
              Text(title,
                  style: TextStyle(
                      color: isSelected ? color : Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
