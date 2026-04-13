import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/views/soal/preview/soal_preview_controller.dart';

class SoalPreview extends StatelessWidget {
  SoalPreview({Key? key}) : super(key: key);

  final SoalPreviewController controller = Get.put(SoalPreviewController());

  static const Color _green = Color(0xFF1B7A3E);
  static const Color _bgLight = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      body: Obx(() {
        // if (controller.isLoading.value) {
        //   return const Center(child: CircularProgressIndicator(color: _green));
        // }
        return Column(
          children: [
            _buildCustomAppBar(context),

            _buildProgressIndicator(),

            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (i) {
                  FocusScope.of(context).unfocus();
                  controller.onPageChanged(i);
                },
                itemCount: controller.totalSoal,
                itemBuilder: (context, index) => _buildInputCard(index),
              ),
            ),

            // 4. NAVIGASI BAWAH
            _buildBottomNavigation(context),
          ],
        );
      }),
    );
  }

  // --- BAGIAN APP BAR ---
  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 12, 16, 20),
      decoration: const BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Tombol Back
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 16),

          // 2. Judul (Pakai Expanded biar ngedorong tombol simpan ke ujung kanan)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Edit Soal',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  controller.namaMapelKelas ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow
                      .ellipsis, // Biar teks kepanjangan nggak pecah
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // 3. RAHASIA UX ENAK: TOMBOL SIMPAN DI POJOK KANAN ATAS
          Obx(() => GestureDetector(
                // Kalau lagi loading nyimpen, tombolnya dimatikan (null) biar ga ke-klik dobel
                onTap: controller.isSaving.value
                    ? null
                    : () {
                        FocusScope.of(context).unfocus(); // Tutup keyboard
                        controller.updateSoal(); // Panggil fungsi simpan
                      },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2))
                      ]),
                  child: controller.isSaving.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Row(
                          children: [
                            Icon(Icons.save_rounded,
                                color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text('Simpan',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                          ],
                        ),
                ),
              )),
        ],
      ),
    );
  }

  // --- BAGIAN INDIKATOR PROGRESS ---
  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Soal ${controller.currentIndex.value + 1} dari ${controller.totalSoal}',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          Row(
            children: List.generate(controller.totalSoal, (index) {
              bool isActive = index == controller.currentIndex.value;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(left: 4),
                height: 8,
                width: isActive ? 24 : 8,
                decoration: BoxDecoration(
                  color: isActive ? _green : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // --- BAGIAN KARTU INPUT LATIN & PEGON ---
  Widget _buildInputCard(int index) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 5))
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge Nomor Soal (Estetik)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: _green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Text('Pertanyaan No. ${index + 1}',
                  style: const TextStyle(
                      color: Color(0xFF059669),
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ),
            const SizedBox(height: 20),

            // KOTAK LATIN
            _buildTextField(
              label: 'TEKS LATIN',
              controller: controller.latinControllers[index],
              hint: 'Ketik soal latin di sini...',
            ),

            const SizedBox(height: 16),

            // TOMBOL GENERATE DI TENGAH
            Center(
              child: SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton.icon(
                      onPressed: controller.isGenerating[index]
                          ? null
                          : () => controller.hitGeneratePegon(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFE2E8F0), // Abu-abu terang elegan
                        foregroundColor:
                            const Color(0xFF475569), // Text abu-abu gelap
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: controller.isGenerating[index]
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(
                              Icons.g_translate_rounded,
                              size: 20,
                              color: _green,
                            ),
                      label: const Text('Generate Pegon',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    )),
              ),
            ),

            const SizedBox(height: 16),

            // KOTAK PEGON (RTL - Rata Kanan)
            _buildTextField(
              label: 'TEKS ARAB PEGON',
              controller: controller.pegonControllers[index],
              hint: 'Teks pegon akan muncul di sini...',
              isRTL: true,
              textColor: _green,
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET TEXTFIELD CUSTOM ---
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isRTL = false,
    Color textColor = Colors.black87,
  }) {
    return Column(
      crossAxisAlignment:
          isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isRTL ? _green : Colors.grey.shade500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 4, // Pas buat 2 kotak biar nggak terlalu panjang
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
          style: TextStyle(
              color: textColor,
              fontSize: isRTL ? 24 : 15,
              fontWeight: isRTL ? FontWeight.w500 : FontWeight.w400,
              height: 1.5),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.normal),
            filled: true,
            fillColor: _bgLight, // Background field senada sama scaffold
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _green, width: 1.5)),
          ),
        ),
      ],
    );
  }

  // --- BAGIAN TOMBOL NAVIGASI BAWAH ---
  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: controller.currentIndex.value == 0
                    ? null
                    : controller.prevPage,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(
                      color: controller.currentIndex.value == 0
                          ? Colors.grey.shade300
                          : _green),
                  foregroundColor: _green,
                ),
                child: const Text('Sebelumnya',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed:
                    controller.currentIndex.value == controller.totalSoal - 1
                        ? () {
                            FocusScope.of(context).unfocus();
                            controller.updateSoal();
                          }
                        : controller.nextPage,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: _green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: controller.isSaving.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text(
                        controller.currentIndex.value ==
                                controller.totalSoal - 1
                            ? 'Simpan Perubahan'
                            : 'Selanjutnya',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
