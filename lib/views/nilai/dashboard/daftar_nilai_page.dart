import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/views/nilai/dashboard/daftar_nilai_controller.dart';

class DaftarNilaiPage extends GetView<DaftarNilaiController> {
  const DaftarNilaiPage({Key? key}) : super(key: key);

  static const Color _green = Color(0xFF1B7A3E);
  static const Color _greenDark = Color(0xFF0D4A24);
  static const Color _greenMid = Color(0xFF1B7A3E);
  static const Color _greenLight = Color(0xFF25A355);

  @override
  Widget build(BuildContext context) {
    Get.put(DaftarNilaiController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildCustomAppBar(context),
          Expanded(
            child: Obx(() {
              if (controller.listJadwal.isEmpty) {
                return const Center(child: Text("Belum ada jadwal ujian"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.listJadwal.length,
                itemBuilder: (context, index) {
                  final jadwal = controller.listJadwal[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildJadwalCard(jadwal),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_greenDark, _greenMid, _greenLight],
          ),
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
                      'Input Nilai Santri',
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

  Widget _buildJadwalCard(JadwalUjianUIModel jadwal) {
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
                      jadwal.namaMapel,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kelas ${jadwal.namaKelas} • ${jadwal.tanggalUjian}',
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              _buildStatusBadge(jadwal.isDinilai == true),
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
              if (!jadwal.isDinilai != false) ...[
                ElevatedButton.icon(
                  onPressed: () => controller.bukaInputNilai(jadwal.id),
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
                  onPressed: () => controller.bukaInputNilai(jadwal.id),
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
