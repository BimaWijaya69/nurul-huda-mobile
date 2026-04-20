import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/core/routes/app_routes.dart';
import 'package:nurul_huda_mobile/data/services/auth_service.dart';
import 'package:nurul_huda_mobile/views/auth/auth_controller.dart';

class TeacherModel {
  final String id;
  final String name;
  final String role;
  final String email;

  TeacherModel({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
  });
}

class ProfilController extends GetxController {
  final AuthService _authService = AuthService();
  var teacher = TeacherModel(
    id: 'GR-070326001',
    name: 'Ustadz Ahmad Fulan, Lc.',
    role: 'Ustadz',
    email: 'ahmad.fulan@asrama.com',
  ).obs;

  String get teacherInitials {
    return _generateInitials(teacher.value.name);
  }

  String _generateInitials(String name) {
    List<String> parts = name.replaceAll(RegExp(r'[,.]'), '').split(' ');
    String initials = '';
    if (parts.isNotEmpty) initials += parts[0][0];
    if (parts.length > 1) initials += parts[1][0];
    return initials.toUpperCase();
  }

  void downloadBarcode() async {
    Get.back(); // Tutup bottom sheet dulu
    Get.dialog(
        const Center(
            child: CircularProgressIndicator(color: Color(0xFF1B7A3E))),
        barrierDismissible: false);

    await Future.delayed(const Duration(seconds: 1));
    Get.back();

    Get.snackbar(
      'Berhasil',
      'Barcode ID berhasil disimpan ke Galeri HP',
      backgroundColor: const Color(0xFF1B7A3E),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
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
                AuthController.to.currentUser.value = null;
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
