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
        return _buildMapelCard(mapel);
      },
    );
  }

  // --- KARTU MAPEL DAFTAR NILAI ---
  Widget _buildMapelCard(MapelUjianItem mapel) {
    bool isDinilai = mapel.sudahDinilai;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // Border hijau muncul jika sudah dinilai
        border: Border.all(
          color: isDinilai ? _green.withOpacity(0.5) : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          // --- LOGIKA KLIK PINDAH KE SINI ---
          onTap: () {
            Get.toNamed(Routes.CREATE_NILAI,
                arguments: {'mapel': mapel, 'isEdit': isDinilai});
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // IKON SEBELAH KIRI (Berubah sesuai status)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDinilai
                        ? Colors.green.shade50
                        : _green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isDinilai
                        ? Icons.check_circle_rounded
                        : Icons.menu_book_rounded,
                    color: _green,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // DETAIL TEKS DI TENGAH
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mapel.nama_mapel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Tag Kelas oranye (Agar konsisten dengan halaman lain)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'الصف ${ArabicHelper.getKelasArab(mapel.kelas_id)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // INDIKATOR SEBELAH KANAN
                if (isDinilai)
                  const Text(
                    'Sudah Dinilai',
                    style: TextStyle(
                      color: _green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Belum Dinilai',
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right_rounded,
                          color: Colors.grey),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
