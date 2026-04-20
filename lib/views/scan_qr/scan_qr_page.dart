import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nurul_huda_mobile/views/scan_qr/scan_qr_controller.dart';

class ScanQrPage extends GetView<ScanQrController> {
  const ScanQrPage({Key? key}) : super(key: key);

  final Color _green = const Color(0xFF1B7A3E);

  @override
  Widget build(BuildContext context) {
    Get.put(ScanQrController());
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller.cameraController,
            scanWindow: Rect.fromCenter(
              center: MediaQuery.of(context).size.center(const Offset(0, -50)),
              width: 200,
              height: 200,
            ),
            onDetect: controller.onDetect,
          ),

          CustomPaint(
            painter: ScannerOverlayPainter(borderColor: _green),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      const Text(
                        'Pindai Kode Guru',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          // Tombol Flash
                          Obx(() => IconButton(
                                icon: Icon(
                                    controller.isFlashOn.value
                                        ? Icons.flash_on
                                        : Icons.flash_off,
                                    color: Colors.white),
                                onPressed: controller.toggleFlash,
                              )),
                          // Tombol Balik Kamera
                          IconButton(
                            icon: const Icon(Icons.cameraswitch_outlined,
                                color: Colors.white),
                            onPressed: controller.switchCamera,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // --- TEKS INSTRUKSI DI ATAS KOTAK SCAN ---
                const Text(
                  'Arahkan Kode QR Guru ke Bingkai',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),

                // Jarak seukuran Kotak Scan (250px) biar elemen lain gak nabrak
                const SizedBox(height: 270),

                // --- TOMBOL UPLOAD DARI GALERI ---
                GestureDetector(
                  onTap: controller.pickImageFromGallery,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.photo_library_outlined,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        const Text('Unggah dari Galeri',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // --- PANEL BAWAH (Fitur Lainnya) ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Fitur Guru Lainnya',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E)),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildPanelItem(Icons.how_to_reg, 'Absensi'),
                          _buildPanelItem(Icons.calendar_month, 'Jadwal'),
                          _buildPanelItem(Icons.local_activity, 'Aktivitas'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4. LOADING SCREEN (Kalau lagi verifikasi QR)
          Obx(() {
            if (controller.isProcessing.value) {
              return Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: _green),
                      const SizedBox(height: 16),
                      const Text('Memproses QR Code...',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  // Widget Bantuan untuk Tombol di Panel Bawah
  Widget _buildPanelItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _green.withOpacity(0.1), // Hijau tipis
            shape: BoxShape.circle,
            border: Border.all(color: _green.withOpacity(0.3)),
          ),
          child: Icon(icon, color: _green, size: 28), // Ikon Hijau
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ],
    );
  }
}

// --- PAINTER UNTUK BIKIN OVERLAY BOLONG & BINGKAI HIJAU KEKINIAN ---
class ScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  ScannerOverlayPainter({required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.7);

    // Ukuran Kotak Scan
    const double scanArea = 250.0;
    // Posisikan agak ke atas sedikit, bukan persis di tengah
    final double left = (size.width - scanArea) / 2;
    final double top = (size.height - scanArea) / 2.5;
    final Rect scanRect = Rect.fromLTWH(left, top, scanArea, scanArea);

    // Bikin layar gelap bolong
    final Path backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final Path cutoutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(scanRect, const Radius.circular(20)));
    final Path finalPath =
        Path.combine(PathOperation.difference, backgroundPath, cutoutPath);
    canvas.drawPath(finalPath, paint);

    // --- GAMBAR SIKU-SIKU (FRAME BINGKAI) HIJAU DI 4 SUDUT KOTAK BOLONG ---
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0 // Ketebalan siku
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 30.0; // Panjang garis siku

    // Kiri Atas
    canvas.drawLine(
        Offset(left, top + cornerLength), Offset(left, top), borderPaint);
    canvas.drawLine(
        Offset(left, top), Offset(left + cornerLength, top), borderPaint);
    // Kanan Atas
    canvas.drawLine(Offset(left + scanArea - cornerLength, top),
        Offset(left + scanArea, top), borderPaint);
    canvas.drawLine(Offset(left + scanArea, top),
        Offset(left + scanArea, top + cornerLength), borderPaint);
    // Kiri Bawah
    canvas.drawLine(Offset(left, top + scanArea - cornerLength),
        Offset(left, top + scanArea), borderPaint);
    canvas.drawLine(Offset(left, top + scanArea),
        Offset(left + cornerLength, top + scanArea), borderPaint);
    // Kanan Bawah
    canvas.drawLine(Offset(left + scanArea - cornerLength, top + scanArea),
        Offset(left + scanArea, top + scanArea), borderPaint);
    canvas.drawLine(Offset(left + scanArea, top + scanArea),
        Offset(left + scanArea, top + scanArea - cornerLength), borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
