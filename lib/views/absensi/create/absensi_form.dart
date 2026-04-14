import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nurul_huda_mobile/data/models/santri.dart';
import 'package:nurul_huda_mobile/views/absensi/create/absensi_form_controller.dart';
import 'package:nurul_huda_mobile/views/widgets/custom_text_field.dart';

class AbsensiForm extends StatefulWidget {
  const AbsensiForm({Key? key}) : super(key: key);

  @override
  State<AbsensiForm> createState() => _AbsensiFormState();
}

class _AbsensiFormState extends State<AbsensiForm> {
  static const Color _green = Color(0xFF1B7A3E);
  static const Color _bgLight = Color(0xFFF8FAFC);

  final AbsensiSantriFormController controller = Get.put(
    AbsensiSantriFormController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      body: Column(
        children: [
          _buildCustomAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMateriSection(),
                  _buildDaftarSantriSection(context),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  // --- 1. APP BAR ---
  Widget _buildCustomAppBar(BuildContext context) {
    String hariIni =
        DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());

    return Container(
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 12, 16, 20),
      decoration: const BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.nama_mapel_kelas,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(hariIni,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. INPUT MATERI PELAJARAN ---
  Widget _buildMateriSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(() => CustomTextField(
            controller: controller.materiController,
            title: 'Materi Hari Ini',
            icon: Icons.edit_note_rounded,
            hintText: 'Contoh: Membahas Bab Fi\'il Madhi...',
            maxLines: 3,
            isRequired: true,
            errorText: controller.materiError.value,
          )),
    );
  }

  // --- 3. DAFTAR SANTRI & FITUR SEARCH ---
  Widget _buildDaftarSantriSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Daftar Kehadiran',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              Obx(() => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: _green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text('${controller.listSantriUi.length} Santri',
                        style: const TextStyle(
                            color: _green,
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
                  )),
            ],
          ),
          const SizedBox(height: 4),
          Text('*Semua santri otomatis diset Hadir (H)',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic)),
          const SizedBox(height: 16),

          // Search Bar
          Obx(() => TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Cari nama santri...',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon:
                      const Icon(Icons.search_rounded, color: Colors.grey),
                  suffixIcon: controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded,
                              color: Colors.grey, size: 20),
                          onPressed: () {
                            controller.searchController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: _green, width: 1.5)),
                ),
              )),

          const SizedBox(height: 20),

          Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: _green)));
            }

            if (controller.filteredSantri.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      Icon(Icons.person_search_rounded,
                          size: 48, color: Colors.grey.shade300),
                      const SizedBox(height: 8),
                      Text('Nama santri tidak ditemukan',
                          style: TextStyle(color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children:
                  List.generate(controller.filteredSantri.length, (index) {
                return _buildSantriCard(controller.filteredSantri[index]);
              }),
            );
          }),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- WIDGET KARTU PER SANTRI ---
  Widget _buildSantriCard(SantriAbsenUi item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: _green.withOpacity(0.1),
                radius: 18,
                child: Text(item.santri.nama!.substring(0, 1),
                    style: const TextStyle(
                        color: _green, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.santri.nama ?? '-',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('NIS: ${item.santri.nis ?? '-'}',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusChip(item, 1, 'H', Colors.green),
              _buildStatusChip(item, 3, 'S', Colors.orange),
              _buildStatusChip(item, 2, 'I', Colors.blue),
              _buildStatusChip(item, 4, 'A', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
      SantriAbsenUi item, int kodeStatus, String label, Color color) {
    bool isSelected = item.status == kodeStatus;

    return GestureDetector(
      onTap: () {
        controller.ubahStatusSantri(item.santri.id!, kodeStatus);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : Colors.transparent),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : color.withOpacity(0.7)),
        ),
      ),
    );
  }

  // --- 4. TOMBOL SIMPAN BAWAH ---
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: Obx(() {
            bool isSaving = controller.isSaving.value;

            return ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () {
                      FocusScope.of(Get.context!).unfocus();
                      controller.submitSemuaAbsensi();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save_rounded, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('Simpan Absensi',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
            );
          }),
        ),
      ),
    );
  }
}
