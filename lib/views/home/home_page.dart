import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurul_huda_mobile/views/home/widget/jadwal_mengajar_widget.dart';

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
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    super.dispose();
  }

  String get _dayAndTimeStr {
    return DateFormat('EEEE HH:mm', 'id_ID').format(_now);
  }

  String get _fullDateStr {
    return DateFormat('d MMMM y', 'id_ID').format(_now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Stack(
        children: [
          // ── Background Image ──
          Positioned.fill(
            child: Image.asset(
              'images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // ── Main Content ──
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 800));
              setState(() {
                _now = DateTime.now();
              });
            },
            // FIX 1: Bungkus CustomScrollView dengan MediaQuery.removePadding
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true, // Menghilangkan default padding dari status bar
              child: CustomScrollView(
                // FIX 2: Pastikan padding internal nol
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ── Header Banner ──
                  // FIX 3: Lempar 'context' ke dalam _buildHeader agar bisa baca tinggi status bar
                  SliverToBoxAdapter(child: _buildHeader(context)),

                  // ── Search Bar ──
                  SliverToBoxAdapter(child: _buildSearchBar()),

                  // ── Jadwal Mengajar ──
                  SliverToBoxAdapter(child: _buildJadwalSection()),

                  // ── Quick Access Cards ──
                  SliverToBoxAdapter(child: _buildQuickCards()),

                  // ── Mading Pesantren ──
                  SliverToBoxAdapter(child: _buildMadingSection()),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // FIX 4: Tambahkan BuildContext context sebagai parameter
  Widget _buildHeader(BuildContext context) {
    // FIX 5: Ambil tinggi status bar HP secara manual
    double statusBarHeight = MediaQuery.of(context).padding.top;

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
              // Decorative background image
              Positioned(
                right: 0,
                bottom: 0,
                child: Opacity(
                  opacity: 0.07,
                  child: Image.asset(
                    'images/header.png',
                    width: 500,
                    height: 500,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // FIX 6: Ganti SafeArea menjadi Padding biasa, lalu tambahkan statusBarHeight di padding atasnya
              Padding(
                // 12 adalah padding bawaan kamu, ditambah tinggi status bar
                padding: EdgeInsets.fromLTRB(20, 12 + statusBarHeight, 20, 24),
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
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Nurul Huda',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
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
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Day + Current Time (Large display)
                    Text(
                      _dayAndTimeStr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Full Date (Tanggal Bulan Tahun)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _fullDateStr,
                        style: const TextStyle(
                          color: _gold,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Bottom row: Ubah Lokasi + Reset + Arah Kiblat
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _headerChip(Icons.schedule_rounded, 'Jadwal Absensi'),
                        _headerChip(Icons.assignment_turned_in_rounded,
                            'Riwayat Absensi'),
                      ],
                    ),
                  ],
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
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

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
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 16),
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

  Widget _buildJadwalSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header — sama persis dengan section lain
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
                    'Jadwal Mengajar',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Widget tabel
          JadwalMengajarWidget(jadwalList: dummyJadwal),
        ],
      ),
    );
  }

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
                                fontSize: 10,
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
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.3,
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
                      fontSize: 18,
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
                        fontSize: 15,
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
                    fontSize: 14,
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
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item['date']!,
                      style: TextStyle(
                        fontSize: 12,
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
