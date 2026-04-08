import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  MODEL
// ─────────────────────────────────────────────
class JadwalItem {
  final int hari; // 1=Senin … 6=Sabtu
  final int sesi; // 1-6
  final String mapelArab; // nama pelajaran dalam Arab
  final String mapelLatin; // nama pelajaran dalam Latin
  final String ustadz; // nama ustadz

  const JadwalItem({
    required this.hari,
    required this.sesi,
    required this.mapelArab,
    required this.mapelLatin,
    required this.ustadz,
  });
}

// ─────────────────────────────────────────────
//  DUMMY DATA  (ganti dengan data dari API)
// ─────────────────────────────────────────────
final List<JadwalItem> dummyJadwal = [
  // SENIN
  JadwalItem(
      hari: 1,
      sesi: 2,
      mapelArab: 'تعليم القرآن',
      mapelLatin: 'Tahfidz Qur\'an',
      ustadz: 'Ust. Huda'),

  // SELASA
  JadwalItem(
      hari: 2,
      sesi: 1,
      mapelArab: 'النحو الأساسي',
      mapelLatin: 'Nahwu Asasi',
      ustadz: 'Ust. Ahmad'),

  JadwalItem(
      hari: 2,
      sesi: 3,
      mapelArab: 'تفسير جزء عم',
      mapelLatin: 'Tafsir Juz Amma',
      ustadz: 'Ust. Raden'),

  // RABU
  JadwalItem(
      hari: 3,
      sesi: 2,
      mapelArab: 'شرح الأربعين',
      mapelLatin: 'Syarah Al-Arba\'in',
      ustadz: 'Ust. Fatih'),

  JadwalItem(
      hari: 3,
      sesi: 4,
      mapelArab: 'الصرف',
      mapelLatin: 'Shorof',
      ustadz: 'Ust. Luqman'),

  // KAMIS
  JadwalItem(
      hari: 4,
      sesi: 1,
      mapelArab: 'العقيدة الإسلامية',
      mapelLatin: 'Aqidah Islamiyah',
      ustadz: 'Ust. Salim'),

  JadwalItem(
      hari: 4,
      sesi: 4,
      mapelArab: 'النحو المتقدم',
      mapelLatin: 'Nahwu Mutaqaddim',
      ustadz: 'Ust. Hadi'),

  // JUMAT
  JadwalItem(
      hari: 5,
      sesi: 2,
      mapelArab: 'المحادثة',
      mapelLatin: 'Muhadatsah',
      ustadz: 'Ust. Yusuf'),

  // SABTU
  JadwalItem(
      hari: 6,
      sesi: 1,
      mapelArab: 'الإملاء',
      mapelLatin: 'Imla\'',
      ustadz: 'Ust. Karim'),

  JadwalItem(
      hari: 6,
      sesi: 3,
      mapelArab: 'فقه المعاملات',
      mapelLatin: 'Fiqh Mu\'amalah',
      ustadz: 'Ust. Amin'),
];

// ─────────────────────────────────────────────
//  WIDGET
// ─────────────────────────────────────────────
class JadwalMengajarWidget extends StatefulWidget {
  final List<JadwalItem> jadwalList;
  const JadwalMengajarWidget({super.key, required this.jadwalList});

  @override
  State<JadwalMengajarWidget> createState() => _JadwalMengajarWidgetState();
}

class _JadwalMengajarWidgetState extends State<JadwalMengajarWidget> {
  static const _green = Color(0xFF1B7A3E);

  static const _daysFull = [
    '',
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const _daysArab = [
    '',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  // Urutan hari: Sabtu, Ahad, Senin, Selasa, Rabu, Kamis (Jumat libur)
  static const _dayOrder = [
    6,
    7,
    1,
    2,
    3,
    4
  ]; // index ke _daysFull dan _daysArab

  static const _sesiLabels = ['', 'I', 'II', 'III', 'IV', 'V', 'VI'];

  bool _hariHasKelas(int hari) {
    return widget.jadwalList.any((j) => j.hari == hari);
  }

  JadwalItem? _getEntry(int hari, int sesi) {
    try {
      return widget.jadwalList
          .firstWhere((j) => j.hari == hari && j.sesi == sesi);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTable();
  }

  // ─── Table ────────────────────────────────
  Widget _buildTable() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF5F5F5), width: 0.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          _buildTableHeader(),
          ...List.generate(6, (sesiIdx) {
            final sesi = sesiIdx + 1;
            return Column(
              children: [
                if (sesiIdx > 0)
                  const Divider(height: 1, color: Color(0xFFF5F5F5)),
                _buildTableRow(sesi),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              border: Border(
                  right: BorderSide(color: Color(0xFFF5F5F5), width: 0.5)),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              '0',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color(0xFF999999)),
            ),
          ),
          ...List.generate(6, (i) {
            final hariIndex = _dayOrder[i];
            final hariValue = hariIndex == 7 ? 0 : hariIndex; // Ahad = 0
            final hasKelas = _hariHasKelas(hariValue);
            return Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    left: BorderSide(color: Color(0xFFF5F5F5), width: 0.5),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _daysArab[hariIndex],
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: hasKelas ? _green : const Color(0xFF999999)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _daysFull[hariIndex],
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: hasKelas ? _green : const Color(0xFF666666)),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableRow(int sesi) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              border: Border(
                  right: BorderSide(color: Color(0xFFF5F5F5), width: 0.5)),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              _sesiLabels[sesi],
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color(0xFF999999)),
            ),
          ),
          ...List.generate(6, (i) {
            final hariIndex = _dayOrder[i];
            final hariValue = hariIndex == 7 ? 0 : hariIndex; // Ahad = 0
            final entry = _getEntry(hariValue, sesi);
            return Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 56),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      left: BorderSide(color: Color(0xFFF5F5F5), width: 0.5)),
                ),
                padding: const EdgeInsets.all(4),
                alignment: Alignment.center,
                child:
                    entry != null ? _buildPill(entry) : const SizedBox.shrink(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPill(JadwalItem item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9F5),
        borderRadius: BorderRadius.circular(6),
        border: const Border(left: BorderSide(color: _green, width: 3)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nama pelajaran Arab (besar, tebal, hijau)
              Text(
                item.mapelArab,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: _green,
                    height: 1.1),
              ),
              const SizedBox(height: 1),
              // Nama ustadz (lebih kecil, hijau)
              Text(
                item.ustadz,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 6.5,
                    fontWeight: FontWeight.w500,
                    color: _green,
                    height: 1.05),
              ),
            ],
          ),
          // Dot indicator di sudut kiri
          Positioned(
            top: 2,
            left: 2,
            child: Container(
                width: 3,
                height: 3,
                decoration:
                    const BoxDecoration(color: _green, shape: BoxShape.circle)),
          ),
        ],
      ),
    );
  }
}
