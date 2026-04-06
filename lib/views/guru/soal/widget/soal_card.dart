import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nurul_huda_mobile/views/guru/soal/soal_controller.dart';
import 'package:nurul_huda_mobile/data/models/soal.dart';

class SoalCard extends StatelessWidget {
  final SoalModel soal;
  final int nomor;
  final SoalController controller;

  const SoalCard({
    super.key,
    required this.soal,
    required this.nomor,
    required this.controller,
  });

  static const _green = Color(0xFF1B7A3E);
  static const _darkGreen = Color(0xFF0D4A24);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExpanded = controller.isExpanded(soal.id);
      final isLoadingTrans = controller.isLoadingTrans(soal.id);

      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isExpanded ? _green : const Color(0xFFE5E7EB),
            width: isExpanded ? 1.2 : 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Header (selalu tampil) ──
            _buildHeader(isExpanded),

            // ── Body (collapsible) ──
            if (isExpanded) _buildBody(isLoadingTrans),
          ],
        ),
      );
    });
  }

  // ─── HEADER ───────────────────────────────────────
  Widget _buildHeader(bool isExpanded) {
    return GestureDetector(
      onTap: () => controller.toggleExpand(soal.id),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Nomor soal
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isExpanded ? _green : const Color(0xFFE8F5EE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '$nomor',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isExpanded ? Colors.white : _green,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Preview teks soal
            Expanded(
              child: soal.soalLatin.isNotEmpty
                  ? Text(
                      soal.soalLatin,
                      style: const TextStyle(
                          fontSize: 15, color: Color(0xFF1A1A2E)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : Text(
                      'Soal belum diisi',
                      style:
                          TextStyle(fontSize: 15, color: Colors.grey.shade400),
                    ),
            ),
            const SizedBox(width: 8),

            // Chevron
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.keyboard_arrow_down_rounded,
                  size: 20, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }

  // ─── BODY ─────────────────────────────────────────
  Widget _buildBody(bool isLoadingTrans) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 0.5, thickness: 0.5),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input soal latin
              _buildSoalLatinInput(),
              const SizedBox(height: 8),

              // Tombol transliterasi
              _buildTransliterasiButton(isLoadingTrans),
              const SizedBox(height: 8),

              // Hasil pegon
              if (soal.soalPegon.isNotEmpty) _buildPegonResult(),
              if (soal.soalPegon.isNotEmpty) const SizedBox(height: 12),

              // Pedoman penilaian essay
              _buildEssayContent(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSoalLatinInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Pertanyaan (Latin)'),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: soal.soalLatin,
          onChanged: (v) => controller.updateSoalLatin(soal.id, v),
          maxLines: 3,
          minLines: 2,
          style: const TextStyle(fontSize: 15),
          decoration: _inputDecoration('Tulis soal dalam huruf latin...'),
        ),
      ],
    );
  }

  Widget _buildTransliterasiButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : () => controller.transliterasi(soal.id),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: _green, width: 0.8),
          foregroundColor: _green,
          padding: const EdgeInsets.symmetric(vertical: 9),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: _green),
              )
            : const Text('و', style: TextStyle(fontSize: 16)),
        label: Text(
          isLoading ? 'Memproses...' : 'Transliterasi ke Aksara Pegon',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildPegonResult() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5EE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1B7A3E).withOpacity(0.2)),
      ),
      child: Text(
        soal.soalPegon,
        style: const TextStyle(
          fontSize: 20,
          color: Color(0xFF0D4A24),
          height: 1.8,
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildEssayContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Pedoman penilaian (opsional, untuk guru)'),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: soal.pedomanEssay,
          onChanged: (v) => controller.updatePedomanEssay(soal.id, v),
          maxLines: 3,
          minLines: 2,
          style: const TextStyle(fontSize: 15),
          decoration: _inputDecoration('Tulis pedoman penilaian...'),
        ),
      ],
    );
  }

  // ─── Helpers ──────────────────────────────────────
  Widget _fieldLabel(String text) {
    return Text(text,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade500));
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
      filled: true,
      fillColor: const Color(0xFFF5F6FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: Color(0xFF1B7A3E), width: 1),
      ),
      isDense: true,
    );
  }
}
