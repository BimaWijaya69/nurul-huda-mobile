import 'package:flutter/material.dart';
import 'package:get/get.dart';

// sementara
class TeacherModel {
  final String id;
  final String name;
  final String role;
  final String phone;
  final String email;

  TeacherModel({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.email,
  });
}

class ProfilController extends GetxController {
  var teacher = TeacherModel(
    id: 'GR-070326001',
    name: 'Ustadz Ahmad Fulan, Lc.',
    role: 'Ustadz',
    phone: '+62 812-3456-7890',
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

  void logout() {
    // Get.offAllNamed('/login');
  }
}
