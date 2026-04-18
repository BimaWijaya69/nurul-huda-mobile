import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/core/routes/app_routes.dart';
import 'package:nurul_huda_mobile/helpers/arabic_helper.dart';
import 'package:nurul_huda_mobile/views/soal/soal_controller.dart';
import 'package:nurul_huda_mobile/widget/error.dart';
import 'package:nurul_huda_mobile/widget/skeleton_card.dart';

class SoalPage extends StatelessWidget {
  SoalPage({Key? key}) : super(key: key);

  static const Color _green = Color(0xFF1B7A3E);
  final SoalController controller = Get.put(SoalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Obx(
        () {
          return Column(
            children: [
              _buildCustomAppBar(context),
              Expanded(
                child: _buildContent(),
              ),
            ],
          );
        },
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
            onRetry: () => controller.fetchMapelKelas(),
          );
        case 'timeout':
          return ErrorStateWidget.timeout(
            onRetry: () => controller.fetchMapelKelas(),
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
            onRetry: () => controller.fetchMapelKelas(),
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
        final data = controller.listMapel[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildMapelCard(
            mapel: data.mapel?.nama_mapel ?? 'Mapel Tidak Diketahui',
            mapel_kelas_id: data.id!,
            tahun_ajaran: controller.periodeAktif.value.tahun_ajaran ?? '-',
            semester: controller.periodeAktif.value.semester ?? '-',
            namaMapelKelas:
                '${data.mapel?.nama_mapel} - الصف ${ArabicHelper.getKelasArab(data.kelas?.id)}',
            kelas: ArabicHelper.getKelasArab(data.kelas?.id),
            isCreated: data.is_created ?? false,
          ),
        );
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
                    const Text('Bank Soal',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                      'Semester ${controller.periodeAktif.value.semester ?? "-"} - ${controller.periodeAktif.value.tahun_ajaran ?? "-"}',
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

  Widget _buildMapelCard(
      {required String mapel,
      required int mapel_kelas_id,
      required String tahun_ajaran,
      required String semester,
      required String namaMapelKelas,
      required String kelas,
      required bool isCreated}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: _green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.menu_book_rounded, color: _green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mapel,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text('الصف $kelas',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              _buildStatusBadge(isCreated),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1, color: Color(0xFFE2E8F0)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!isCreated) ...[
                ElevatedButton.icon(
                  onPressed: () async {
                    var result =
                        await Get.toNamed(Routes.CREATE_SOAL, arguments: {
                      'mapel_kelas_id': mapel_kelas_id,
                      'tahun_ajaran': tahun_ajaran,
                      'semester': semester,
                      'nama_mapel_kelas': namaMapelKelas,
                    });

                    if (result == true) {
                      controller.fetchMapelKelas();
                    }
                  },
                  label: const Text('Buat Soal'),
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
                  onPressed: () {
                    Get.toNamed(Routes.PREVIEW_SOAL, arguments: {
                      'mapel_kelas_id': mapel_kelas_id,
                      'tahun_ajaran': tahun_ajaran,
                      'semester': semester,
                      'nama_mapel_kelas': namaMapelKelas,
                    });
                  },
                  label: const Text('Lihat Soal'),
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

  Widget _buildStatusBadge(bool isCreated) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: isCreated ? _green.withOpacity(0.1) : const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        isCreated ? 'Sudah Dibuat' : 'Belum Dibuat',
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color:
                isCreated ? const Color(0xFF059669) : const Color(0xFFDC2626)),
      ),
    );
  }
}
