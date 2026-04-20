import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/core/routes/app_routes.dart';
import 'package:nurul_huda_mobile/data/services/auth_service.dart';
import 'package:nurul_huda_mobile/views/auth/auth_controller.dart';
import 'package:nurul_huda_mobile/data/models/user.dart'; // Pastikan import model User

class ProfilController extends GetxController {
  final AuthService _authService = AuthService();

  User? get currentUser => AuthController.to.currentUser.value;

  String get teacherInitials {
    return _generateInitials(currentUser?.name ?? 'Guru');
  }

  String _generateInitials(String name) {
    if (name.isEmpty) return 'G';
    List<String> parts = name.replaceAll(RegExp(r'[,.]'), '').split(' ');
    String initials = '';
    if (parts.isNotEmpty) initials += parts[0][0];
    if (parts.length > 1) initials += parts[1][0];
    return initials.toUpperCase();
  }

  void downloadBarcode() async {
    // ... Biarkan fungsi download tetap dummy untuk sementara ...
    Get.back();
    Get.dialog(
        const Center(
            child: CircularProgressIndicator(color: Color(0xFF1B7A3E))),
        barrierDismissible: false);

    await Future.delayed(const Duration(seconds: 1));
    Get.back();

    Get.snackbar(
      'Informasi', // Ubah judul sementara
      'Fitur download QR Code segera hadir.',
      backgroundColor: Colors.blue.shade700,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
      margin: const EdgeInsets.all(16),
    );
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () async {
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              bool isSuccess = await _authService.logout();

              if (isSuccess) {
                // Jangan lupa gunakan method clearAuth bawaanmu
                AuthController.to.clearAuth();
                Get.offAllNamed(Routes.STARTED);
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
