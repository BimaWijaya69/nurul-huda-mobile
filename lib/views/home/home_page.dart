import 'dart:async';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static const _green = Color(0xFF1B7A3E);
  static const _darkGreen = Color(0xFF0D4A24);
  static const _gold = Color(0xFFF5C842);
  static const _lightGreen = Color(0xFF25A355);

  late AnimationController _headerAnim;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  // Prayer times data
  final List<Map<String, String>> _prayerTimes = const [
    {'name': 'Subuh', 'time': '04:35', 'icon': '🌙'},
    {'name': 'Dzuhur', 'time': '11:52', 'icon': '☀️'},
    {'name': 'Ashar', 'time': '15:09', 'icon': '🌤'},
    {'name': 'Maghrib', 'time': '17:43', 'icon': '🌅'},
    {'name': 'Isya', 'time': '19:00', 'icon': '🌃'},
  ];

  // Menu items
  final List<Map<String, dynamic>> _menuItems = const [
    {
      'icon': Icons.article_rounded,
      'label': 'Artikel',
      'color': Color(0xFF4A90D9)
    },
    {
      'icon': Icons.school_rounded,
      'label': 'Mondok\nOnline',
      'color': Color(0xFF7B68EE)
    },
    {
      'icon': Icons.quiz_rounded,
      'label': 'Tanya\nJawab',
      'color': Color(0xFFFF6B6B)
    },
    {
      'icon': Icons.menu_book_rounded,
      'label': 'Al-Quran',
      'color': Color(0xFF1B7A3E)
    },
    {
      'icon': Icons.auto_stories_rounded,
      'label': 'Hadits',
      'color': Color(0xFF1B7A3E)
    },
    {
      'icon': Icons.library_books_rounded,
      'label': 'Pustaka',
      'color': Color(0xFFE67E22)
    },
    {
      'icon': Icons.self_improvement_rounded,
      'label': 'Dzikir &\nIbadah',
      'color': Color(0xFF16A085)
    },
    {
      'icon': Icons.cast_for_education_rounded,
      'label': 'Kajian',
      'color': Color(0xFF8E44AD)
    },
    {
      'icon': Icons.access_time_rounded,
      'label': 'Jadwal\nSholat',
      'color': Color(0xFF1B7A3E)
    },
    {
      'icon': Icons.grid_view_rounded,
      'label': 'Lainnya',
      'color': Color(0xFF95A5A6)
    },
  ];

  // Countdown timer
  Duration _countdown = const Duration(hours: 4, minutes: 31, seconds: 26);
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();

    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerAnim, curve: Curves.easeIn),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut));

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
          if (_countdown.inSeconds > 0) {
            _countdown -= const Duration(seconds: 1);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String _padTwo(int n) => n.toString().padLeft(2, '0');

  String get _countdownStr =>
      '-${_padTwo(_countdown.inHours)}:${_padTwo(_countdown.inMinutes % 60)}:${_padTwo(_countdown.inSeconds % 60)}';

  String get _timeStr => '${_padTwo(_now.hour)}:${_padTwo(_now.minute)}';

  String get _dateStr {
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    const days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    return '${days[_now.weekday % 7]}, ${_now.day} ${months[_now.month]} ${_now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header Banner ──
          SliverToBoxAdapter(child: _buildHeader()),

          // ── Search Bar ──
          SliverToBoxAdapter(child: _buildSearchBar()),

          // ── Menu Grid ──
          SliverToBoxAdapter(child: _buildMenuSection()),

          // ── Quick Access Cards ──
          SliverToBoxAdapter(child: _buildQuickCards()),

          // ── Jadwal Sholat ──
          SliverToBoxAdapter(child: _buildPrayerSchedule()),

          // ── Mading Pesantren ──
          SliverToBoxAdapter(child: _buildMadingSection()),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  // ─── HEADER ───────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return FadeTransition(
      opacity: _headerFade,
      child: SlideTransition(
        position: _headerSlide,
        child: Container(
          margin: const EdgeInsets.only(bottom: 0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D4A24), Color(0xFF1B7A3E), Color(0xFF25A355)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          ),
          child: Stack(
            children: [
              // Decorative mosque silhouette
              Positioned(
                right: 0,
                bottom: 0,
                child: Opacity(
                  opacity: 0.07,
                  child: Icon(Icons.mosque_rounded,
                      size: 180, color: Colors.white),
                ),
              ),
              // Star pattern
              Positioned(
                left: -20,
                top: 40,
                child: Opacity(
                  opacity: 0.06,
                  child: Icon(Icons.star, size: 120, color: Colors.white),
                ),
              ),

              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top row: greeting + notification
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assalamu\'alaikum 👋',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Santri Nurul Huda',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.notifications_rounded,
                                    color: Colors.white, size: 22),
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: _gold,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Location
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on_rounded,
                              color: _gold, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'MANGUNSARI, TEKUNG, LUMAJANG',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Next prayer name + time
                      const Text(
                        'Imsak 04:35',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Countdown
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _countdownStr,
                          style: const TextStyle(
                            color: _gold,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Bottom row: Ubah Lokasi + current time + Arah Kiblat
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _headerChip(
                              Icons.edit_location_alt_rounded, 'Ubah Lokasi'),
                          // Live clock
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time_rounded,
                                    color: Colors.white, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  _timeStr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    fontFeatures: [
                                      FontFeature.tabularFigures()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _headerChip(Icons.explore_rounded, 'Arah Kiblat'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ─── SEARCH BAR ───────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Icon(Icons.search_rounded,
                  color: Color(0xFF1B7A3E), size: 22),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari kajian, jadwal, info santri...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1B7A3E),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  const Icon(Icons.tune_rounded, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Menu Utama',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                      color: Color(0xFF1B7A3E),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 4,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: _menuItems.length,
            itemBuilder: (ctx, i) => _buildMenuItem(_menuItems[i]),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    final color = item['color'] as Color;
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
            ),
            child: Icon(item['icon'] as IconData, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            item['label'] as String,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF3D3D3D),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  // ─── QUICK ACCESS CARDS ───────────────────────────────────────────────────
  Widget _buildQuickCards() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickCard(
              icon: Icons.trending_up_rounded,
              label: 'Trending\nArtikel',
              color: const Color(0xFF1B7A3E),
              bgColor: const Color(0xFFE8F5EE),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickCard(
              icon: Icons.forum_rounded,
              label: 'Info\nPesantren',
              color: const Color(0xFFE8A020),
              bgColor: const Color(0xFFFFF8E6),
              badge: '3',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCard({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    String? badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                if (badge != null)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Center(
                        child: Text(badge,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // ─── PRAYER SCHEDULE ──────────────────────────────────────────────────────
  Widget _buildPrayerSchedule() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jadwal Sholat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Text(
                _dateStr,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: List.generate(_prayerTimes.length, (i) {
                final p = _prayerTimes[i];
                final isNext = i == 0; // Subuh as "next"
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isNext
                        ? const Color(0xFF1B7A3E).withOpacity(0.06)
                        : Colors.transparent,
                    borderRadius: i == 0
                        ? const BorderRadius.vertical(top: Radius.circular(20))
                        : i == 4
                            ? const BorderRadius.vertical(
                                bottom: Radius.circular(20))
                            : null,
                    border: i < 4
                        ? Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade100,
                              width: 1,
                            ),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Text(p['icon']!, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          p['name']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isNext ? FontWeight.w700 : FontWeight.w500,
                            color: isNext
                                ? const Color(0xFF1B7A3E)
                                : const Color(0xFF3D3D3D),
                          ),
                        ),
                      ),
                      if (isNext)
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5C842).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Berikutnya',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFFB8860B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      Text(
                        p['time']!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isNext
                              ? const Color(0xFF1B7A3E)
                              : const Color(0xFF1A1A2E),
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ─── MADING SECTION ───────────────────────────────────────────────────────
  Widget _buildMadingSection() {
    final List<Map<String, String>> madingItems = [
      {
        'title': 'Pengumuman Libur Akhir Semester',
        'date': '5 Mar 2026',
        'category': 'Pengumuman',
      },
      {
        'title': 'Jadwal Ujian Kitab Kuning Kelas Wustha',
        'date': '4 Mar 2026',
        'category': 'Akademik',
      },
      {
        'title': 'Penerimaan Santri Baru Tahun Ajaran 2026',
        'date': '1 Mar 2026',
        'category': 'Pendaftaran',
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5C842),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Mading Pesantren',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Semua',
                    style: TextStyle(
                        color: Color(0xFF1B7A3E),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...madingItems.map((item) => _buildMadingCard(item)),
        ],
      ),
    );
  }

  Widget _buildMadingCard(Map<String, String> item) {
    final catColors = {
      'Pengumuman': const Color(0xFFFF6B6B),
      'Akademik': const Color(0xFF1B7A3E),
      'Pendaftaran': const Color(0xFF4A90D9),
    };
    final color = catColors[item['category']] ?? const Color(0xFF1B7A3E);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.campaign_rounded, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['category']!,
                        style: TextStyle(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item['date']!,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 18),
        ],
      ),
    );
  }
}
