import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nurul_huda_mobile/helpers/arabic_helper.dart';
import 'package:nurul_huda_mobile/views/absensi/rekap/rekap_controller.dart';

class RekapAbsensiPage extends GetView<RekapAbsensiController> {
  const RekapAbsensiPage({super.key});

  static const Color _green = Color(0xFF1B7A3E);
  static const Color _bgLight = Color(0xFFF5F6FA);

  @override
  Widget build(BuildContext context) {
    Get.put(RekapAbsensiController());
    return Scaffold(
      backgroundColor: _bgLight,
      body: Column(
        children: [
          _buildCustomAppBar(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: _green),
                );
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildCalendarCard(),
                    const SizedBox(height: 20),
                    _buildSummaryRow(),
                    const SizedBox(height: 24),
                    _buildDetailList(),
                  ],
                ),
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
        color: _green,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rekap Absensi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Obx(() => Text(
                          'Semester ${controller.rekapData.value?.semester ?? "-"} - TA ${controller.rekapData.value?.tahunAjaran ?? "-"}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
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

  // ==========================================
  // KALENDER DINAMIS
  // ==========================================
  Widget _buildCalendarCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Navigasi Bulan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: controller.prevMonth,
                  icon: Icon(Icons.chevron_left_rounded,
                      color: Colors.grey.shade600)),
              Obx(() => Text(
                    DateFormat('MMMM yyyy', 'id_ID')
                        .format(controller.selectedDate.value),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                  )),
              IconButton(
                  onPressed: controller.nextMonth,
                  icon: Icon(Icons.chevron_right_rounded,
                      color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 16),

          // Header Hari
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'].map((hari) {
              return SizedBox(
                width: 40,
                child: Text(
                  hari,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Grid Tanggal
          Obx(() {
            final now = controller.selectedDate.value;
            final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
            final firstDayOfMonth =
                DateTime(now.year, now.month, 1).weekday % 7; // 0 = Minggu

            // Menyiapkan array tanggal
            List<Widget> dayWidgets = [];

            // Tanggal kosong di awal bulan (offset)
            for (int i = 0; i < firstDayOfMonth; i++) {
              dayWidgets.add(const SizedBox.shrink());
            }

            // Loop tanggal 1 sampai akhir bulan
            for (int i = 1; i <= daysInMonth; i++) {
              String status = controller.getStatusForDate(i);
              dayWidgets.add(_buildDayCell(i, status));
            }

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: dayWidgets,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDayCell(int date, String status) {
    Color bgColor = Colors.transparent;
    Color textColor = const Color(0xFF1A1A2E);
    FontWeight fontWeight = FontWeight.w500;

    if (status == 'hadir') {
      bgColor = _green;
      textColor = Colors.white;
      fontWeight = FontWeight.bold;
    } else if (status == 'izin') {
      bgColor = const Color(0xFFF5C842);
      textColor = Colors.white;
      fontWeight = FontWeight.bold;
    } else if (status == 'alfa') {
      bgColor = const Color(0xFFE53935);
      textColor = Colors.white;
      fontWeight = FontWeight.bold;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        date.toString(),
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  // ==========================================
  // AKUMULASI (SUMMARY) CARD INTERAKTIF
  // ==========================================
  Widget _buildSummaryRow() {
    final s = controller.rekapData.value?.summary;
    return Row(
      children: [
        _summaryItem('Hadir', '${s?.hadir ?? 0}', _green, 'hadir'),
        const SizedBox(width: 10),
        _summaryItem(
            'Izin', '${s?.izin ?? 0}', const Color(0xFFF5C842), 'izin'),
        const SizedBox(width: 10),
        _summaryItem(
            'Alfa', '${s?.alfa ?? 0}', const Color(0xFFE53935), 'alfa'),
      ],
    );
  }

  Widget _summaryItem(String label, String value, Color color, String status) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setFilter(status),
        child: Obx(() {
          bool isSelected = controller.filterStatus.value == status;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              // 👇 Background transparan tipis jika terpilih 👇
              color: isSelected ? color.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              // 👇 Border menyala jika terpilih 👇
              border: Border.all(
                  color: isSelected ? color : Colors.grey.shade200,
                  width: isSelected ? 1.5 : 1),
            ),
            child: Column(
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        // Teks angka tetap pakai warna solid agar kontras
                        color: color)),
                Text(label,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? color.withOpacity(0.8)
                            : Colors.grey.shade500)),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ==========================================
  // DETAIL LIST BAWAH
  // ==========================================
  Widget _buildDetailList() {
    final list = controller.filteredDetails;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 👇 HEADER DENGAN GARIS VERTIKAL ALA HOME 👇
            Row(
              children: [
                Obx(() {
                  // Warna garis dinamis mengikuti filter
                  Color barColor =
                      const Color(0xFFF5C842); // Default Kuning/Emas
                  if (controller.filterStatus.value != null) {
                    barColor = _getStatusColor(controller.filterStatus.value!);
                  }
                  return Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
                const SizedBox(width: 8),
                Obx(() => Text(
                      controller.filterStatus.value == null
                          ? 'Semua Riwayat'
                          : 'Riwayat ${controller.filterStatus.value!.capitalizeFirst}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                          color: Color(0xFF1A1A2E)),
                    )),
              ],
            ),
            Obx(() {
              if (controller.filterStatus.value != null) {
                return GestureDetector(
                  onTap: () => controller.setFilter(null),
                  child: const Text('Lihat Semua',
                      style: TextStyle(
                          color: _green,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
        const SizedBox(height: 16), // Jarak agak dijauhkan sedikit

        if (list.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Tidak ada riwayat absensi.',
                  style: TextStyle(color: Colors.grey.shade500)),
            ),
          ),

        ...list.map((item) {
          final isIzin = item.status == 'izin';
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      color: _getStatusColor(item.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text('${item.tanggal?.day ?? ""}',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: _getStatusColor(item.status))),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.namaMapel,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF1A1A2E),
                              fontFamily: 'Amiri')),
                      const SizedBox(height: 2),
                      Text('الصف ${ArabicHelper.getKelasArab(item.kelasId)}',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600)),
                      if (isIzin && item.keterangan != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline_rounded,
                                  size: 14, color: Colors.orange),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item.keterangan!,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange,
                                      height: 1.3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'hadir') return _green;
    if (status == 'izin') return const Color(0xFFF5C842);
    if (status == 'alfa') return const Color(0xFFE53935);
    return Colors.grey;
  }
}
