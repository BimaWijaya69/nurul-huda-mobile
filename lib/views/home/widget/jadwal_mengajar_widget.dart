import 'package:flutter/material.dart';
import 'package:nurul_huda_mobile/data/models/jadwal_kbm.dart';
import 'package:nurul_huda_mobile/helpers/arabic_helper.dart';

class JadwalMengajarWidget extends StatelessWidget {
  final List<AgendaMengajarItem> jadwalList;

  const JadwalMengajarWidget({super.key, required this.jadwalList});

  static const Color _green = Color(0xFF1B7A3E);
  static const Color _bgLight = Color(0xFFF8FAFC);

  static const Map<int, Map<String, String>> _namaHari = {
    1: {'id': 'Senin', 'ar': 'الاثنين'},
    2: {'id': 'Selasa', 'ar': 'الثلاثاء'},
    3: {'id': 'Rabu', 'ar': 'الأربعاء'},
    4: {'id': 'Kamis', 'ar': 'الخميس'},
    5: {'id': 'Jumat', 'ar': 'الجمعة'},
    6: {'id': 'Sabtu', 'ar': 'السبت'},
    7: {'id': 'Ahad', 'ar': 'الأحد'},
  };

  Map<int, List<AgendaMengajarItem>> _groupJadwalByHari() {
    Map<int, List<AgendaMengajarItem>> grouped = {};
    for (var jadwal in jadwalList) {
      int indexHari = jadwal.hariIndex;

      if (!grouped.containsKey(indexHari)) {
        grouped[indexHari] = [];
      }
      grouped[indexHari]!.add(jadwal);
    }

    grouped.forEach((hari, list) {
      list.sort((a, b) => a.jamMulai.compareTo(b.jamMulai));
    });

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedJadwal = _groupJadwalByHari();

    final List<int> urutanHari = [6, 7, 1, 2, 3, 4, 5];
    int hariIni = DateTime.now().weekday;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
            ),
            child: Row(
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
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          if (jadwalList.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.event_busy_rounded,
                        size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text('Belum ada jadwal KBM.',
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ...urutanHari.map((hari) {
            if (!groupedJadwal.containsKey(hari))
              return const SizedBox.shrink();
            bool isToday = (hari == hariIni);
            return _buildHariSection(hari, groupedJadwal[hari]!, isToday);
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildHariSection(
      int hari, List<AgendaMengajarItem> jadwalPerHari, bool isToday) {
    return Container(
      color: isToday ? _green.withOpacity(0.09) : Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _namaHari[hari]!['id']!,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                Text(
                  _namaHari[hari]!['ar']!,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _green,
                      fontFamily: 'Amiri'),
                ),
              ],
            ),
          ),
          ...jadwalPerHari.map((jadwal) => _buildItemJadwal(jadwal)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child:
                Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildItemJadwal(AgendaMengajarItem jadwal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: _bgLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              ArabicHelper.getKelasArab(jadwal.kelasId),
              textAlign: TextAlign.center, // Biar rapi di tengah
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _green.withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // DETAIL MAPEL & JAM PELAJARAN
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jadwal.namaMapel,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _green,
                    height: 1.2,
                    fontFamily: 'Amiri', // Font Arab
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 6),
                    Text(
                      '${jadwal.jamMulai} - ${jadwal.jamSelesai}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
