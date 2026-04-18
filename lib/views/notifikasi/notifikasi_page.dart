import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notifikasi_controller.dart';

class NotifikasiPage extends GetView<NotifikasiController> {
  const NotifikasiPage({Key? key}) : super(key: key);

  static const Color _green = Color(0xFF1B7A3E);

  @override
  Widget build(BuildContext context) {
    Get.put(NotifikasiController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notifikasi',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: () => controller.tandaiSemuaDibaca(),
            child: const Text('Tandai Dibaca',
                style: TextStyle(color: _green, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. FILTER CHIPS
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() => Row(
                    children: [
                      _buildFilterChip('Semua'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Absensi'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Nilai'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Pengumuman'),
                    ],
                  )),
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

          Expanded(
            child: Obx(() {
              final list = controller.filteredNotif;

              if (list.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return _buildNotifCard(list[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = controller.selectedFilter.value == label;
    return GestureDetector(
      onTap: () => controller.ubahFilter(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _green : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? _green : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildNotifCard(NotifUIModel notif) {
    // Tentukan Ikon dan Warna berdasarkan Tipe
    IconData icon;
    Color iconColor;

    switch (notif.tipe) {
      case 'Absensi':
        icon = Icons.event_available_rounded;
        iconColor = const Color(0xFF4A90D9);
        break;
      case 'Nilai':
        icon = Icons.grading_rounded;
        iconColor = const Color(0xFFF5C842);
        break;
      default:
        icon = Icons.campaign_rounded;
        iconColor = _green;
    }

    return Obx(() {
      bool isRead = notif.isRead.value;

      return InkWell(
        onTap: () {
          controller.tandaiSudahDibaca(notif);
          // TODO: Bisa di-routing ke halaman terkait jika perlu
        },
        child: Container(
          decoration: BoxDecoration(
            color: isRead ? Colors.white : _green.withOpacity(0.05),
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notif.judul,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  isRead ? FontWeight.w600 : FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            margin: const EdgeInsets.only(left: 8, top: 4),
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notif.pesan,
                      style: TextStyle(
                        fontSize: 13,
                        color: isRead ? Colors.grey.shade600 : Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      notif.waktu,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Tidak ada notifikasi',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            'Saat ini tidak ada pemberitahuan baru\nuntuk kategori ini.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
