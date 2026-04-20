import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/core/routes/app_routes.dart';
import 'package:nurul_huda_mobile/data/models/nilai_ujian.dart';
import 'package:nurul_huda_mobile/helpers/arabic_helper.dart';
import 'package:nurul_huda_mobile/views/nilai_ujian/nilai_controller.dart';
import 'package:nurul_huda_mobile/widget/error.dart';
import 'package:nurul_huda_mobile/widget/skeleton_card.dart';

class DaftarNilaiPage extends GetView<NilaiUjianController> {
  const DaftarNilaiPage({Key? key}) : super(key: key);

  static const Color _green = Color(0xFF1B7A3E);

  @override
  Widget build(BuildContext context) {
    Get.put(NilaiUjianController());

    return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Obx(
          () => Column(
            children: [
              _buildCustomAppBar(context),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ));
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: _green,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ]),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tombol Back

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Penilaian Ujian',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Semester ${controller.semester.value} - ${controller.tahun_ajaran.value}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
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

  Widget _buildContent() {
    if (controller.isLoading.value) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
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
            onRetry: () => controller.fetchMapelGuru(),
          );
        case 'timeout':
          return ErrorStateWidget.timeout(
            onRetry: () => controller.fetchMapelGuru(),
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
            onRetry: () => controller.fetchMapelGuru(),
          );
      }
    }

    if (controller.listMapel.isEmpty) {
      return const Center(
          child: Text("Belum ada jadwal mengajar di semester ini."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.listMapel.length,
      itemBuilder: (context, index) {
        final mapel = controller.listMapel[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildMapelCard(mapel),
        );
      },
    );
  }

  Widget _buildMapelCard(MapelUjianItem mapel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon Kiri
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.menu_book_rounded, color: _green),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mapel.nama_mapel,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الصف ${ArabicHelper.getKelasArab(mapel.kelas_id)}',
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              _buildStatusBadge(mapel.sudahDinilai == true),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1, color: Color(0xFFE2E8F0)),
          ),

          // Tombol Aksi di Kanan Bawah
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!mapel.sudahDinilai) ...[
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed(Routes.CREATE_NILAI, arguments: {
                    'mapel': mapel,
                    'isEdit': mapel.sudahDinilai
                  }),
                  icon: const Icon(Icons.edit_document,
                      size: 18, color: Colors.white),
                  label: const Text('Input Nilai'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ] else ...[
                OutlinedButton.icon(
                  onPressed: () => Get.toNamed(Routes.CREATE_NILAI, arguments: {
                    'mapel': mapel,
                    'isEdit': mapel.sudahDinilai
                  }),
                  icon: const Icon(Icons.visibility_outlined,
                      size: 18, color: _green),
                  label: const Text('Lihat Nilai'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _green,
                    side: const BorderSide(color: _green),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isDinilai) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDinilai ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isDinilai ? 'Selesai' : 'Belum',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDinilai ? const Color(0xFF059669) : const Color(0xFFDC2626),
        ),
      ),
    );
  }
}
