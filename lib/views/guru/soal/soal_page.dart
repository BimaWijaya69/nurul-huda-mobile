import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/views/guru/soal/soal_controller.dart';
import 'package:nurul_huda_mobile/data/services/pdf_services.dart';
import 'package:nurul_huda_mobile/views/guru/soal/widget/soal_card.dart';

class SoalPage extends GetView<SoalController> {
  const SoalPage({super.key});

  static const _green = Color(0xFF1B7A3E);
  static const _gold = Color(0xFFF5C842);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          _buildAppBar(controller),

          // ── Content ──
          Expanded(
            child: Obx(() => ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  children: [
                    // Form header ujian
                    _buildFormHeader(controller),
                    const SizedBox(height: 12),

                    // Info bar
                    _buildInfoBar(controller),
                    const SizedBox(height: 12),

                    // Label
                    const Text(
                      'Daftar soal',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // List soal cards
                    ...controller.soalList.asMap().entries.map((entry) {
                      return SoalCard(
                        soal: entry.value,
                        nomor: entry.key + 1,
                        controller: controller,
                      );
                    }),
                  ],
                )),
          ),
        ],
      ),

      // ── FAB Preview Print ──
      floatingActionButton: _buildFab(controller),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ─── APP BAR ────────────────────────────────────────
  Widget _buildAppBar(SoalController controller) {
    return Container(
      decoration: const BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Buat Soal Ujian',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              // Tombol simpan draft
              GestureDetector(
                onTap: () => _onSimpan(controller),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.3), width: 0.5),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── FORM HEADER UJIAN ──────────────────────────────
  Widget _buildFormHeader(SoalController controller) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Judul
          _buildTextField(
            label: 'Judul ujian',
            hint: 'cth: Ujian Nahwu Semester 1',
            onChanged: (v) => controller.judul.value = v,
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              // Mata pelajaran
              Expanded(
                child: _buildTextField(
                  label: 'Mata pelajaran',
                  hint: 'cth: Nahwu',
                  onChanged: (v) => controller.mapel.value = v,
                ),
              ),
              const SizedBox(width: 10),
              // Kelas
              Expanded(
                child: _buildDropdown(
                  label: 'Kelas',
                  value: controller.kelas.value,
                  items: ['Ula', 'Wustha', 'Ulya'],
                  onChanged: (v) => controller.kelas.value = v!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              // Tanggal
              Expanded(
                child: _buildTextField(
                  label: 'Tanggal ujian',
                  hint: 'DD/MM/YYYY',
                  onChanged: (v) => controller.tanggal.value = v,
                  keyboardType: TextInputType.datetime,
                ),
              ),
              const SizedBox(width: 10),
              // Durasi
              Expanded(
                child: _buildTextField(
                  label: 'Durasi (menit)',
                  hint: '90',
                  initialValue: '90',
                  onChanged: (v) =>
                      controller.durasi.value = int.tryParse(v) ?? 90,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── INFO BAR ───────────────────────────────────────
  Widget _buildInfoBar(SoalController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _infoItem(controller.jumlahSoal.toString(), 'Soal'),
          _divider(),
          _infoItem(controller.totalBobot.toString(), 'Total nilai'),
          _divider(),
          Obx(() => _infoItem('${controller.durasi.value}', 'Menit')),
        ],
      ),
    );
  }

  Widget _infoItem(String val, String label) {
    return Column(
      children: [
        Text(val,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: _green)),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
      ],
    );
  }

  Widget _divider() {
    return Container(width: 0.5, height: 32, color: const Color(0xFFE5E7EB));
  }

  // ─── FAB PREVIEW PRINT ──────────────────────────────
  Widget _buildFab(SoalController controller) {
    return GestureDetector(
      onTap: () => _onPreviewPrint(controller),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0D4A24), _green],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _green.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Preview & Print',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ACTIONS ────────────────────────────────────────
  void _onSimpan(SoalController controller) {
    final pesan = controller.validasiPesan;
    if (pesan != null) {
      Get.snackbar(
        'Belum lengkap',
        pesan,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade50,
        colorText: Colors.orange.shade800,
        icon: const Icon(Icons.warning_amber_rounded,
            color: Colors.orange, size: 20),
      );
      return;
    }
    // TODO: simpan ke database/API
    Get.snackbar(
      'Berhasil',
      'Soal ujian berhasil disimpan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFE8F5EE),
      colorText: const Color(0xFF1B7A3E),
      icon: const Icon(Icons.check_circle_rounded,
          color: Color(0xFF1B7A3E), size: 20),
    );
  }

  Future<void> _onPreviewPrint(SoalController controller) async {
    final pesan = controller.validasiPesan;
    if (pesan != null) {
      Get.snackbar(
        'Belum bisa diprint',
        pesan,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade50,
        colorText: Colors.orange.shade800,
      );
      return;
    }

    try {
      await SoalPdfService.previewPdf(
        judul: controller.judul.value,
        mapel: controller.mapel.value,
        kelas: controller.kelas.value,
        tanggal: controller.tanggal.value,
        durasi: controller.durasi.value,
        soalList: controller.soalList.toList(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuat PDF: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ─── HELPER WIDGETS ─────────────────────────────────
  Widget _buildTextField({
    required String label,
    required String hint,
    required ValueChanged<String> onChanged,
    String? initialValue,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
        const SizedBox(height: 3),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            filled: true,
            fillColor: const Color(0xFFF5F6FA),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide:
                  const BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide:
                  const BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Color(0xFF1B7A3E), width: 1),
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
        const SizedBox(height: 3),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A2E)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F6FA),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide:
                  const BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide:
                  const BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Color(0xFF1B7A3E), width: 1),
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
