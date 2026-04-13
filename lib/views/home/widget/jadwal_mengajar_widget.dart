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

  static const _sesiLabels = ['Sifir', 'I', 'II', 'III', 'IV', 'V', 'VI'];

  late int _todayDayOfWeek; // 0=Ahad, 1=Senin, ..., 6=Sabtu
  late int _todayColumn; // index di _dayOrder yang sesuai dengan hari ini

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Convert Flutter weekday (1=Monday, 7=Sunday) to our format (0=Sunday, 1=Monday, ..., 6=Saturday)
    _todayDayOfWeek = now.weekday == 7 ? 0 : now.weekday;
    // Find column index in _dayOrder
    _todayColumn =
        _dayOrder.indexOf(_todayDayOfWeek == 0 ? 7 : _todayDayOfWeek);
  }

  bool _hariHasKelas(int hari) {
    return widget.jadwalList.any((j) => j.hari == hari);
  }

  bool _hasJadwalToday() {
    return widget.jadwalList.any((j) => j.hari == _todayDayOfWeek);
  }

  bool _isToday(int columnIndex, List<int> dayIndices) {
    return columnIndex == _todayColumn && dayIndices.contains(columnIndex);
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
    return Column(
      children: [
        // ─── Tabel 1: Sabtu - Senin ─────────────────
        _buildTable([0, 1, 2]),
        const SizedBox(height: 12),
        // ─── Tabel 2: Selasa - Kamis ────────────────
        _buildTable([3, 4, 5]),
      ],
    );
  }

  // ─── Table ────────────────────────────────
  Widget _buildTable(List<int> dayIndices) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF5F5F5), width: 0.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          _buildTableHeader(dayIndices),
          ...List.generate(7, (sesiIdx) {
            final sesi = sesiIdx; // 0-6
            return Column(
              children: [
                if (sesiIdx > 0)
                  const Divider(height: 1, color: Color(0xFFF5F5F5)),
                _buildTableRow(sesi, dayIndices),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableHeader(List<int> dayIndices) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              border: Border(
                  right: BorderSide(color: Color(0xFFF5F5F5), width: 0.5)),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              'فَصْل',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color(0xFF1B7A3E)),
            ),
          ),
          ...dayIndices.map((i) {
            final hariIndex = _dayOrder[i];
            final hariValue = hariIndex == 7 ? 0 : hariIndex; // Ahad = 0
            final hasKelas = _hariHasKelas(hariValue);
            final isToday = _isToday(i, dayIndices);
            final isTodayWithJadwal = isToday && _hasJadwalToday();
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
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: isTodayWithJadwal || hasKelas
                              ? _green
                              : const Color(0xFF999999)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _daysFull[hariIndex],
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: isTodayWithJadwal || hasKelas
                              ? _green
                              : const Color(0xFF666666)),
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

  Widget _buildTableRow(int sesiIdx, List<int> dayIndices) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              border: Border(
                  right: BorderSide(color: Color(0xFFF5F5F5), width: 0.5)),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              _sesiLabels[sesiIdx],
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color(0xFF999999)),
            ),
          ),
          ...dayIndices.map((i) {
            final hariIndex = _dayOrder[i];
            final hariValue = hariIndex == 7 ? 0 : hariIndex; // Ahad = 0
            final entry = _getEntry(hariValue, sesiIdx);

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
                child: entry != null
                    ? _buildJadwalContent(entry)
                    : _buildEmptyCell(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildJadwalContent(JadwalItem entry) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          entry.mapelArab,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _green,
            height: 1.3,
          ),
        ),
        Text(
          entry.ustadz,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: _green.withValues(alpha: 0.75),
            height: 1.3,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 40,
          height: 2,
          decoration: const BoxDecoration(
            color: Color(0xFFFFC107),
            borderRadius: BorderRadius.all(Radius.circular(1)),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCell() {
    return const SizedBox.shrink();
  }
}
