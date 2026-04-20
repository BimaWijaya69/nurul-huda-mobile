import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nurul_huda_mobile/core/routes/app_routes.dart';
import 'package:nurul_huda_mobile/data/services/auth_service.dart';

class ScanQrController extends GetxController {
  final AuthService _authService = AuthService();
  final MobileScannerController cameraController = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
  );
  var isProcessing = false.obs;
  var isFlashOn = false.obs;
  String lastScannedCode = "";
  int confirmationCount = 0;
  final int requiredConfirmations = 5;

  void toggleFlash() {
    cameraController.toggleTorch();
    isFlashOn.toggle();
  }

  void switchCamera() {
    cameraController.switchCamera();
  }

  void onDetect(BarcodeCapture capture) async {
    if (isProcessing.value) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      String qrResult = barcodes.first.rawValue!;

      if (qrResult == lastScannedCode) {
        confirmationCount++;
      } else {
        lastScannedCode = qrResult;
        confirmationCount = 0;
      }

      if (confirmationCount >= requiredConfirmations) {
        confirmationCount = 0;
        lastScannedCode = "";
        _prosesQrCode(qrResult);
      }
    }
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null) {
      // 👇 Kunci pintu biar kamera live (yang lagi nyala di belakang) gak ikut-ikutan nge-scan
      isProcessing.value = true;

      // ❌ cameraController.stop(); <-- HAPUS/KOMEN BARIS INI! Biarkan mesin tetap hidup.

      try {
        debugPrint('📷 PATH GAMBAR GALERI: ${image.path}');

        // Mesin sekarang dalam keadaan melek dan siap menganalisis file
        final BarcodeCapture? capture =
            await cameraController.analyzeImage(image.path);

        debugPrint('📷 HASIL RAW ANALYZE: $capture');
        debugPrint('📷 JUMLAH BARCODE DITEMUKAN: ${capture?.barcodes.length}');

        if (capture != null && capture.barcodes.isNotEmpty) {
          String? qrResult = capture.barcodes.first.rawValue;

          if (qrResult != null && qrResult.isNotEmpty) {
            debugPrint('📷 ISI QR DARI GALERI: $qrResult');
            _prosesQrCode(qrResult.trim());
            return; // Sukses, langsung keluar dari fungsi
          }
        }

        // Kalau gagal (bukan null, tapi memang gak ada QR di gambarnya)
        Get.snackbar(
          'Gagal',
          'Tidak ditemukan QR Code pada gambar tersebut.',
          backgroundColor: Colors.orange.shade800,
          colorText: Colors.white,
        );
      } catch (e, stacktrace) {
        debugPrint('🚨 [GALLERY SCAN ERROR] $e');

        Get.snackbar(
          'Error',
          'Gagal memproses gambar.',
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
        );
      } finally {
        // 👇 Buka lagi pintunya biar kamera live bisa dipakai scan biasa
        isProcessing.value = false;

        // ❌ cameraController.start(); <-- HAPUS/KOMEN BARIS INI JUGA!
      }
    }
  }

  Future<void> _prosesQrCode(String qrToken) async {
    isProcessing.value = true;
    cameraController.stop();
    debugPrint('📷 HASIL SCAN KAMERA ASLI: "$qrToken"');
    try {
      final res = await _authService.loginWithQr(qrToken.trim());

      if (res.status == 'success') {
        Get.offAllNamed(Routes.LAYOUT);
        Get.snackbar('Berhasil', res.message,
            backgroundColor: const Color(0xFF1B7A3E), colorText: Colors.white);
      } else {
        debugPrint('🚨 [CONTROLLER] LOGIN ERROR: ${res.message}');
        throw Exception(res.message);
      }
    } catch (e, stacktrace) {
      isProcessing.value = false;
      debugPrint('🔥 [CONTROLLER] ERROR SCAN: $e');
      debugPrint('🔥 [CONTROLLER] STACKTRACE: $stacktrace');
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: const Color.fromARGB(255, 171, 74, 74),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );

      await Future.delayed(const Duration(seconds: 3));
      if (isClosed) return;
      isProcessing.value = false;
      cameraController.start();
    }
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
