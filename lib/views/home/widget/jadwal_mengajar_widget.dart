import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  MODEL
// ─────────────────────────────────────────────
class JadwalItem {
  final int hari; // 1=Senin … 6=Sabtu
  final String jam; // e.g. '07:00'
  final String mapel;
  final String kelas;
  final Color color;
  final Color bgColor;
  final Color textColor;
  final Color subColor;

  const JadwalItem({
    required this.hari,
    required this.jam,
    required this.mapel,
    required this.kelas,
    required this.color,
    required this.bgColor,
    required this.textColor,
    required this.subColor,
  });
}

// ─────────────────────────────────────────────
//  DUMMY DATA  (ganti dengan data dari API)
// ─────────────────────────────────────────────
final List<JadwalItem> dummyJadwal = [
  JadwalItem(
      hari: 1,
      jam: '07:00',
      mapel: 'Nahwu',
      kelas: 'Ula A',
      color: const Color(0xFF1B7A3E),
      bgColor: const Color(0xFFEDFAF3),
      textColor: const Color(0xFF0D5C2E),
      subColor: const Color(0xFF1B7A3E)),
  JadwalItem(
      hari: 1,
      jam: '09:00',
      mapel: 'Shorof',
      kelas: 'Ula B',
      color: const Color(0xFF7C3AED),
      bgColor: const Color(0xFFF3F0FF),
      textColor: const Color(0xFF4A1D96),
      subColor: const Color(0xFF7C3AED)),
  JadwalItem(
      hari: 2,
      jam: '07:00',
      mapel: 'Fiqih',
      kelas: 'Wustha A',
      color: const Color(0xFF2563EB),
      bgColor: const Color(0xFFEFF5FF),
      textColor: const Color(0xFF1044A8),
      subColor: const Color(0xFF2563EB)),
  JadwalItem(
      hari: 2,
      jam: '10:00',
      mapel: 'Tafsir',
      kelas: 'Ulya',
      color: const Color(0xFFD97706),
      bgColor: const Color(0xFFFFFBEB),
      textColor: const Color(0xFF78350F),
      subColor: const Color(0xFFD97706)),
  JadwalItem(
      hari: 3,
      jam: '08:00',
      mapel: 'Hadits',
      kelas: 'Wustha B',
      color: const Color(0xFFD97706),
      bgColor: const Color(0xFFFFFBEB),
      textColor: const Color(0xFF78350F),
      subColor: const Color(0xFFD97706)),
  JadwalItem(
      hari: 3,
      jam: '13:00',
      mapel: 'Shorof',
      kelas: 'Ula A',
      color: const Color(0xFF7C3AED),
      bgColor: const Color(0xFFF3F0FF),
      textColor: const Color(0xFF4A1D96),
      subColor: const Color(0xFF7C3AED)),
  JadwalItem(
      hari: 4,
      jam: '07:00',
      mapel: 'Aqidah',
      kelas: 'Ula A',
      color: const Color(0xFF1B7A3E),
      bgColor: const Color(0xFFEDFAF3),
      textColor: const Color(0xFF0D5C2E),
      subColor: const Color(0xFF1B7A3E)),
  JadwalItem(
      hari: 4,
      jam: '13:00',
      mapel: 'Nahwu',
      kelas: 'Wustha A',
      color: const Color(0xFF1B7A3E),
      bgColor: const Color(0xFFEDFAF3),
      textColor: const Color(0xFF0D5C2E),
      subColor: const Color(0xFF1B7A3E)),
  JadwalItem(
      hari: 5,
      jam: '08:00',
      mapel: 'Muhadatsah',
      kelas: 'Ulya',
      color: const Color(0xFF0F766E),
      bgColor: const Color(0xFFEFFAF8),
      textColor: const Color(0xFF064E3B),
      subColor: const Color(0xFF0F766E)),
  JadwalItem(
      hari: 6,
      jam: '07:00',
      mapel: 'Imla',
      kelas: 'Ula B',
      color: const Color(0xFF0F766E),
      bgColor: const Color(0xFFEFFAF8),
      textColor: const Color(0xFF064E3B),
      subColor: const Color(0xFF0F766E)),
  JadwalItem(
      hari: 6,
      jam: '09:00',
      mapel: 'Fiqih',
      kelas: 'Ulya',
      color: const Color(0xFF2563EB),
      bgColor: const Color(0xFFEFF5FF),
      textColor: const Color(0xFF1044A8),
      subColor: const Color(0xFF2563EB)),
];

// ─────────────────────────────────────────────
//  MAIN WIDGET
// ─────────────────────────────────────────────
class JadwalMengajarWidget extends StatefulWidget {
  final List<JadwalItem> jadwalList;
  const JadwalMengajarWidget({super.key, required this.jadwalList});

  @override
  State<JadwalMengajarWidget> createState() => _JadwalMengajarWidgetState();
}

class _JadwalMengajarWidgetState extends State<JadwalMengajarWidget> {
  static const _green = Color(0xFF1B7A3E);
  static const _gold = Color(0xFFF5C842);
  static const _greenLight = Color(0xFFE8F5EE);
  static const _greenDark = Color(0xFF0D5C2E);

  static const _days = ['', 'SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB'];
  static const _daysFull = [
    '',
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];
  static const _bulan = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des'
  ];

  static const _times = [
    ('07:00', 'Pagi'),
    ('08:00', 'Pagi'),
    ('09:00', 'Pagi'),
    ('10:00', 'Pagi'),
    ('11:00', 'Siang'),
    ('13:00', 'Siang'),
    ('14:00', 'Siang'),
  ];

  int _weekOffset = 0;

  List<DateTime> _getWeekDates() {
    final now = DateTime.now();
    final monday =
        now.subtract(Duration(days: now.weekday - 1 - _weekOffset * 7));
    return List.generate(6, (i) => monday.add(Duration(days: i)));
  }

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  String _getHijri(DateTime date) {
    // Simplified Hijri approximation
    final jd = (date.millisecondsSinceEpoch / 86400000 + 2440587.5).floor();
    final l = jd - 1948440 + 10632;
    final n = ((l - 1) / 10631).floor();
    final l2 = l - 10631 * n + 354;
    final j = ((10985 - l2) / 5316).floor() * ((50 * l2) / 17719).floor() +
        (l2 / 5670).floor() * ((43 * l2) / 15238).floor();
    final l3 = l2 -
        ((30 - j) / 15).floor() * ((17719 * j) / 50).floor() -
        (j / 16).floor() * ((15238 * j) / 43).floor() +
        29;
    final month = ((24 * l3) / 709).floor();
    final day = l3 - ((709 * month) / 24).floor();
    const hijriMonths = [
      '',
      'Muh',
      'Saf',
      'R.Awl',
      'R.Akh',
      'J.Awl',
      'J.Akh',
      'Raj',
      'Sya',
      'Ram',
      'Syaw',
      'Zul-Q',
      'Zul-H'
    ];
    return '$day ${hijriMonths[month]}';
  }

  JadwalItem? _getEntry(int hari, String jam) {
    try {
      return widget.jadwalList
          .firstWhere((j) => j.hari == hari && j.jam == jam);
    } catch (_) {
      return null;
    }
  }

  int get _todaySesiCount {
    final now = DateTime.now();
    return widget.jadwalList.where((j) => j.hari == now.weekday).length;
  }

  @override
  Widget build(BuildContext context) {
    final week = _getWeekDates();
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          _buildHeader(),
          const SizedBox(height: 10),

          // ── Today Banner ──
          _buildTodayBanner(now),
          const SizedBox(height: 8),

          // ── Week Navigation ──
          _buildWeekNav(week),
          const SizedBox(height: 8),

          // ── Table ──
          _buildTable(week),
          const SizedBox(height: 10),

          // ── Footer: Legend + Total ──
          _buildFooter(),
        ],
      ),
    );
  }

  // ─── Header ───────────────────────────────
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
                color: _gold, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        const Text('Jadwal Mengajar',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E))),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
              color: _greenLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFC3E6D0))),
          child: Text('${widget.jadwalList.length} sesi',
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _greenDark)),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
            decoration: BoxDecoration(
                border: Border.all(color: _green),
                borderRadius: BorderRadius.circular(20)),
            child: const Text('Semua',
                style: TextStyle(
                    fontSize: 12, color: _green, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  // ─── Today Banner ─────────────────────────
  Widget _buildTodayBanner(DateTime now) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: _greenLight,
        borderRadius: BorderRadius.circular(10),
        border: const Border(left: BorderSide(color: _green, width: 3)),
      ),
      child: Row(
        children: [
          Container(
              width: 7,
              height: 7,
              decoration:
                  const BoxDecoration(color: _green, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(
            'Hari ini: ${_daysFull[now.weekday]}, ${now.day} ${_bulan[now.month]} ${now.year}',
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: _greenDark),
          ),
          const Spacer(),
          Text('$_todaySesiCount sesi mengajar',
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: _green)),
        ],
      ),
    );
  }

  // ─── Week Navigation ──────────────────────
  Widget _buildWeekNav(List<DateTime> week) {
    final start = week.first;
    final end = week.last;
    final label =
        '${start.day}/${start.month} – ${end.day}/${end.month} ${end.year}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: const Color(0xFFF5F5F3),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          _navBtn(
              Icons.chevron_left_rounded, () => setState(() => _weekOffset--)),
          Expanded(
              child: Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF888888)))),
          _navBtn(
              Icons.chevron_right_rounded, () => setState(() => _weekOffset++)),
        ],
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E5E5))),
        child: Icon(icon, size: 18, color: _green),
      ),
    );
  }

  // ─── Table ────────────────────────────────
  Widget _buildTable(List<DateTime> week) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          _buildTableHeader(week),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          ..._times.map((t) => _buildTableRow(t.$1, t.$2, week)),
        ],
      ),
    );
  }

  Widget _buildTableHeader(List<DateTime> week) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // time column placeholder
          Container(width: 36, color: const Color(0xFFFAFAFA)),
          ...List.generate(6, (i) {
            final d = week[i];
            final today = _isToday(d);
            return Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: today ? const Color(0xFFFFFEF5) : Colors.transparent,
                  border: Border(
                    left:
                        const BorderSide(color: Color(0xFFEEEEEE), width: 0.5),
                    bottom: BorderSide(
                        color: today ? _gold : Colors.transparent, width: 2.5),
                  ),
                ),
                child: Column(
                  children: [
                    Text(_days[i + 1],
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: .4,
                            color: today
                                ? const Color(0xFFB89A00)
                                : const Color(0xFFBBBBBB))),
                    const SizedBox(height: 1),
                    Text('${d.day}',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: today ? _green : const Color(0xFF1A1A2E))),
                    const SizedBox(height: 1),
                    Text(_getHijri(d),
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                            color: today
                                ? const Color(0xFFC8B84A)
                                : const Color(0xFFDDDDDD))),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableRow(String jam, String sesiLabel, List<DateTime> week) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFF5F5F5)))),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // time cell
            Container(
              width: 36,
              color: const Color(0xFFFAFAFA),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(jam,
                      style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1B7A3E))),
                  Text(sesiLabel,
                      style: const TextStyle(
                          fontSize: 8, color: Color(0xFFCCCCCC))),
                ],
              ),
            ),
            // day cells
            ...List.generate(6, (i) {
              final today = _isToday(week[i]);
              final entry = _getEntry(i + 1, jam);
              return Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 50),
                  decoration: BoxDecoration(
                    color: today ? const Color(0xFFFEFFF7) : Colors.transparent,
                    border: const Border(
                        left: BorderSide(color: Color(0xFFF5F5F5), width: 0.5)),
                  ),
                  padding: const EdgeInsets.all(3),
                  alignment: Alignment.center,
                  child: entry != null ? _buildPill(entry) : _buildEmptyDot(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(JadwalItem item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(6, 5, 5, 4),
      decoration: BoxDecoration(
        color: item.bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: item.color, width: 3)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.mapel,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: item.textColor,
                      height: 1.2)),
              const SizedBox(height: 2),
              Text(item.kelas,
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: item.subColor.withOpacity(.7))),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
                width: 5,
                height: 5,
                decoration:
                    BoxDecoration(color: item.color, shape: BoxShape.circle)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDot() {
    return Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(
            color: Color(0xFFF0F0F0), shape: BoxShape.circle));
  }

  // ─── Footer ───────────────────────────────
  Widget _buildFooter() {
    const legends = [
      (Color(0xFF1B7A3E), 'Nahwu/Aqidah'),
      (Color(0xFF2563EB), 'Fiqih'),
      (Color(0xFF7C3AED), 'Shorof'),
      (Color(0xFFD97706), 'Tafsir/Hadits'),
      (Color(0xFF0F766E), 'Imla/Muhadatsah'),
    ];

    return Column(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 6,
          children: legends
              .map((l) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: 12,
                          height: 3,
                          decoration: BoxDecoration(
                              color: l.$1,
                              borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 4),
                      Text(l.$2,
                          style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF888888),
                              fontWeight: FontWeight.w500)),
                    ],
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
              color: const Color(0xFFF0FAF4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFD4EDDC))),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 14, color: _green),
              const SizedBox(width: 6),
              const Text('Total mengajar minggu ini',
                  style: TextStyle(
                      fontSize: 12,
                      color: _green,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${widget.jadwalList.length} sesi',
                  style: const TextStyle(
                      fontSize: 15,
                      color: _green,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ],
    );
  }
}
