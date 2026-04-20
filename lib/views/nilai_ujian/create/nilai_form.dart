import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/data/models/santri.dart';
import 'package:nurul_huda_mobile/helpers/arabic_helper.dart';
import 'package:nurul_huda_mobile/views/nilai_ujian/create/nilai_form_controller.dart';
import 'package:nurul_huda_mobile/widget/skeleton_nilai.dart';

class NilaiFormPage extends GetView<NilaiUjianFormController> {
  const NilaiFormPage({Key? key}) : super(key: key);

  static const Color _green = Color(0xFF1B7A3E);

  @override
  Widget build(BuildContext context) {
    Get.put(NilaiUjianFormController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(context),
          _buildSearchBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6, // Munculkan 6 baris dummy skeleton
                  itemBuilder: (context, index) {
                    return const SkeletonSantriRow();
                  },
                );
              }

              if (controller.filteredSantri.isEmpty) {
                return Center(
                  child: Text(
                    "Santri tidak ditemukan",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredSantri.length,
                itemBuilder: (context, index) {
                  final santri = controller.filteredSantri[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildSantriRow(santri),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Obx(() => ElevatedButton(
                onPressed: controller.isSaving.value
                    ? null
                    : () {
                        FocusManager.instance.primaryFocus
                            ?.unfocus(); // Tutup keyboard
                        controller.submitSemuaNilai();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 4,
                  shadowColor: _green.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: controller.isSaving.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text(
                        'Simpan Semua Nilai',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              )),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: _green,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
          ]),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 22),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.mapelData.nama_mapel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Input Nilai • ${ArabicHelper.getKelasArab(controller.mapelData.kelas_id)}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.search_rounded, color: Colors.grey, size: 22),
            ),
            Expanded(
              child: TextField(
                controller: controller.searchController,
                // 👇 Perbaikan pemanggilan fungsi filter 👇
                // (Tidak perlu onChanged karena di controller sudah pakai Listener)
                decoration: InputDecoration(
                  hintText: 'Cari nama santri...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 15),
              ),
            ),
            Obx(() => controller.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: Colors.grey, size: 20),
                    onPressed: () {
                      controller.searchController.clear();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _buildSantriRow(Santri santri) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _green.withOpacity(0.1),
            radius: 20,
            child: Text(
              santri.nama![0].toUpperCase(),
              style:
                  const TextStyle(color: _green, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  santri.nama!,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'NIS: ${santri.nis}',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 70,
            child: TextField(
              controller: controller.nilaiControllers[santri.id!],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 3,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              decoration: InputDecoration(
                counterText: "",
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                filled: true,
                fillColor: Colors.grey.shade100,
                hintText: '-',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _green, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
