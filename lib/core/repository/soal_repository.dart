import 'package:nurul_huda_mobile/data/models/soal.dart';

// ─────────────────────────────────────────────────────────
// TOGGLE INI UNTUK SWITCH MOCK ↔ API ASLI
// Ubah ke false ketika backend sudah siap
// ─────────────────────────────────────────────────────────
const bool useMock = true;

// ─────────────────────────────────────────────────────────
// ABSTRACT INTERFACE
// Controller hanya tahu interface ini, tidak peduli mock/real
// ─────────────────────────────────────────────────────────
abstract class SoalRepository {
  Future<String> transliterasi(String teksLatin);
  Future<bool> simpanSoal({
    required String judul,
    required String mapel,
    required String kelas,
    required String tanggal,
    required int durasi,
    required List<SoalModel> soalList,
  });

  // Factory: otomatis return mock atau real tergantung flag
  factory SoalRepository() {
    if (useMock) return _MockSoalRepository();
    return _RealSoalRepository();
  }
}

// ─────────────────────────────────────────────────────────
// MOCK IMPLEMENTATION
// Simulasi delay seperti API sungguhan
// ─────────────────────────────────────────────────────────
class _MockSoalRepository implements SoalRepository {
  @override
  Future<String> transliterasi(String teksLatin) async {
    // Simulasi delay network
    await Future.delayed(const Duration(milliseconds: 800));

    // Dummy mapping sederhana — nanti diganti respons API asli
    final mockResults = {
      'apa': 'اَڤَ',
      'yang': 'يڠ',
      'dimaksud': 'دِمقسود',
      'dengan': 'دڠن',
    };

    // Coba cocokkan kata pertama, kalau tidak ada pakai fallback
    final kata = teksLatin.toLowerCase().split(' ').first;
    final hasil = mockResults[kata];
    if (hasil != null) return '$hasil ...';

    // Fallback: kembalikan teks dengan format Pegon palsu
    return 'Mock Pegon: $teksLatin';
  }

  @override
  Future<bool> simpanSoal({
    required String judul,
    required String mapel,
    required String kelas,
    required String tanggal,
    required int durasi,
    required List<SoalModel> soalList,
  }) async {
    // Simulasi delay network
    await Future.delayed(const Duration(seconds: 1));
    // Selalu sukses di mock
    return true;
  }
}

// ─────────────────────────────────────────────────────────
// REAL IMPLEMENTATION
// Diisi nanti ketika API backend sudah siap
// ─────────────────────────────────────────────────────────
class _RealSoalRepository implements SoalRepository {
  @override
  Future<String> transliterasi(String teksLatin) async {
    throw UnimplementedError('API belum siap');
  }

  @override
  Future<bool> simpanSoal({
    required String judul,
    required String mapel,
    required String kelas,
    required String tanggal,
    required int durasi,
    required List<SoalModel> soalList,
  }) async {
    throw UnimplementedError('API belum siap');
  }
}
