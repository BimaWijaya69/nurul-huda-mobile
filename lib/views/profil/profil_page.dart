import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/views/profil/profil_controller.dart';

class ProfilPage extends GetView<ProfilController> {
  const ProfilPage({Key? key}) : super(key: key);

  static const Color _greenDark = Color(0xFF0D4A24);
  static const Color _greenMid = Color(0xFF1B7A3E);
  static const Color _greenLight = Color(0xFF25A355);
  static const Color _gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    Get.put(ProfilController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Obx(() {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300.0,
              pinned: true,
              stretch: true,
              backgroundColor: _greenDark,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner_rounded,
                      color: Colors.white, size: 26),
                  tooltip: 'Tampilkan Barcode ID',
                  onPressed: () => _showBarcodeBottomSheet(context),
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  var top = constraints.biggest.height;
                  var isCollapsed = top <=
                      kToolbarHeight + MediaQuery.of(context).padding.top + 20;

                  return FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: const EdgeInsets.only(bottom: 16),
                    title: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      crossFadeState: isCollapsed
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: const Text(
                        'Profil Anda',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      secondChild: Text(
                        controller.teacher.value.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [_greenDark, _greenMid, _greenLight],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: _gold, width: 3),
                            ),
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor: _greenDark,
                              child: Text(
                                controller.teacherInitials,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            controller.teacher.value.name,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: _gold.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: _gold.withOpacity(0.5), width: 1),
                            ),
                            child: Text(
                              controller.teacher.value.role,
                              style: const TextStyle(
                                  color: _gold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: _greenLight,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        kToolbarHeight -
                        MediaQuery.of(context).padding.top,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5))
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildInfoTile(Icons.badge_outlined,
                                  'Nomor Induk', controller.teacher.value.id),
                              const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Color(0xFFF0F0F0)),
                              const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Color(0xFFF0F0F0)),
                              _buildInfoTile(Icons.email_outlined, 'Email',
                                  controller.teacher.value.email),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(
                                  color: Colors.redAccent, width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: const Icon(Icons.logout_rounded,
                                color: Colors.redAccent),
                            label: const Text(
                              'Keluar Aplikasi',
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => controller.logout(),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showBarcodeBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Text(
              'Kartu Identitas Digital',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Tunjukkan barcode ini ke scanner asrama',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200, width: 2),
              ),
              child: Column(
                children: [
                  Icon(Icons.qr_code_2_rounded,
                      size: 150, color: Colors.grey.shade800),
                  const SizedBox(height: 16),
                  Text(
                    controller.teacher.value.id,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => controller.downloadBarcode(),
                icon: const Icon(Icons.download_rounded, color: Colors.white),
                label: const Text('Simpan ke Galeri',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _greenMid,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
      enterBottomSheetDuration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _greenLight.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: _greenMid, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
            fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w700),
      ),
    );
  }
}
