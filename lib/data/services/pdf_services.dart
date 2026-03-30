import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:nurul_huda_mobile/data/models/soal.dart';

class SoalPdfService {
  /// Generate dan tampilkan preview PDF siap print
  static Future<void> previewPdf({
    required String judul,
    required String mapel,
    required String kelas,
    required String tanggal,
    required int durasi,
    required List<SoalModel> soalList,
  }) async {
    final pdf = await _buildPdf(
      judul: judul,
      mapel: mapel,
      kelas: kelas,
      tanggal: tanggal,
      durasi: durasi,
      soalList: soalList,
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
      name: '$judul.pdf',
    );
  }

  /// Generate dan simpan PDF ke file
  static Future<Uint8List> generatePdfBytes({
    required String judul,
    required String mapel,
    required String kelas,
    required String tanggal,
    required int durasi,
    required List<SoalModel> soalList,
  }) async {
    final pdf = await _buildPdf(
      judul: judul,
      mapel: mapel,
      kelas: kelas,
      tanggal: tanggal,
      durasi: durasi,
      soalList: soalList,
    );
    return pdf.save();
  }

  static Future<pw.Document> _buildPdf({
    required String judul,
    required String mapel,
    required String kelas,
    required String tanggal,
    required int durasi,
    required List<SoalModel> soalList,
  }) async {
    final pdf = pw.Document();

    // Load font Arab (Amiri) dari assets
    // Pastikan sudah menambahkan font di pubspec.yaml:
    // flutter:
    //   assets:
    //     - assets/fonts/Amiri-Regular.ttf
    //     - assets/fonts/Amiri-Bold.ttf
    final fontData = await rootBundle.load('assets/fonts/Amiri-Regular.ttf');
    final fontBoldData = await rootBundle.load('assets/fonts/Amiri-Bold.ttf');
    final arabFont = pw.Font.ttf(fontData);
    final arabFontBold = pw.Font.ttf(fontBoldData);

    final green = PdfColor.fromHex('1B7A3E');
    final gold = PdfColor.fromHex('F5C842');
    final darkGreen = PdfColor.fromHex('0D4A24');
    final lightGreen = PdfColor.fromHex('E8F5EE');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 36),
        textDirection: pw.TextDirection.rtl,
        build: (context) => [
          // ── KOP ──────────────────────────────────────
          pw.Column(
            children: [
              pw.Text(
                'لمبر سوءل اوجيان',
                style: pw.TextStyle(
                  font: arabFontBold,
                  fontSize: 20,
                  color: green,
                ),
                textDirection: pw.TextDirection.rtl,
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                judul,
                style: pw.TextStyle(font: arabFont, fontSize: 14),
                textDirection: pw.TextDirection.rtl,
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 8),
              // Garis dekoratif
              pw.Stack(
                children: [
                  pw.Container(height: 2, color: green),
                  pw.Container(height: 2, color: gold),
                ],
              ),
            ],
          ),

          pw.SizedBox(height: 16),

          // ── META INFO ──────────────────────────────────
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: lightGreen,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    _metaRow('ماتا ڤلاجاران', mapel, arabFont),
                    pw.SizedBox(height: 4),
                    _metaRow('كلس', kelas, arabFont),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    _metaRow('تاريخ', tanggal, arabFont),
                    pw.SizedBox(height: 4),
                    _metaRow('واكتو', '$durasi مينيت', arabFont),
                  ],
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 8),

          // Kolom nama & nilai
          pw.Row(
            children: [
              _namaValueBox('نام', 160, arabFont),
              pw.SizedBox(width: 16),
              _namaValueBox('نيلاي', 80, arabFont),
            ],
          ),

          pw.SizedBox(height: 16),
          pw.Divider(color: green, thickness: 0.5),
          pw.SizedBox(height: 12),

          // ── DAFTAR SOAL ───────────────────────────────
          ...soalList.asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                // Nomor + soal pegon
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        s.soalPegon.isNotEmpty
                            ? s.soalPegon
                            : '[Soal belum ditransliterasi]',
                        style: pw.TextStyle(font: arabFont, fontSize: 14),
                        textDirection: pw.TextDirection.rtl,
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Container(
                      width: 24,
                      height: 24,
                      decoration: pw.BoxDecoration(
                        color: green,
                        borderRadius: pw.BorderRadius.circular(6),
                      ),
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        '${i + 1}',
                        style: pw.TextStyle(
                          font: arabFontBold,
                          fontSize: 12,
                          color: PdfColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 8),

                // Konten berdasarkan tipe
                _buildSoalContent(s, arabFont, arabFontBold, green),

                pw.SizedBox(height: 10),
                if (i < soalList.length - 1)
                  pw.Divider(color: PdfColor.fromHex('E5E7EB'), thickness: 0.5),
                pw.SizedBox(height: 10),
              ],
            );
          }),
        ],
      ),
    );

    return pdf;
  }

  static pw.Widget _buildSoalContent(
    SoalModel s,
    pw.Font font,
    pw.Font fontBold,
    PdfColor green,
  ) {
    switch (s.tipe) {
      case TipeSoal.pg:
        final keys = ['أ', 'ب', 'ج', 'د']; // Abjad Arab untuk A B C D
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: List.generate(4, (j) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Text(
                '${keys[j]}. ${s.pilihan[j].isNotEmpty ? s.pilihan[j] : '___'}',
                style: pw.TextStyle(font: font, fontSize: 13),
                textDirection: pw.TextDirection.rtl,
                textAlign: pw.TextAlign.right,
              ),
            );
          }),
        );

      case TipeSoal.benarSalah:
        return pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Container(
              width: 20,
              height: 20,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
                borderRadius: pw.BorderRadius.circular(4),
              ),
            ),
            pw.SizedBox(width: 6),
            pw.Text('بنر',
                style: pw.TextStyle(font: font, fontSize: 13),
                textDirection: pw.TextDirection.rtl),
            pw.SizedBox(width: 16),
            pw.Container(
              width: 20,
              height: 20,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey),
                borderRadius: pw.BorderRadius.circular(4),
              ),
            ),
            pw.SizedBox(width: 6),
            pw.Text('سلاه',
                style: pw.TextStyle(font: font, fontSize: 13),
                textDirection: pw.TextDirection.rtl),
          ],
        );

      case TipeSoal.isian:
        return pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text('جواب: ',
                style: pw.TextStyle(font: font, fontSize: 13),
                textDirection: pw.TextDirection.rtl),
            pw.Container(
              width: 120,
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey, width: 0.5)),
              ),
              height: 18,
            ),
          ],
        );

      case TipeSoal.essay:
        return pw.Column(
          children: List.generate(
            3,
            (_) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 10),
              child: pw.Container(
                height: 0.5,
                color: PdfColor.fromHex('D1D5DB'),
              ),
            ),
          ),
        );
    }
  }

  static pw.Widget _metaRow(String label, String value, pw.Font font) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(value,
            style: pw.TextStyle(font: font, fontSize: 12),
            textDirection: pw.TextDirection.rtl),
        pw.SizedBox(width: 4),
        pw.Text(': $label',
            style: pw.TextStyle(
                font: font, fontSize: 12, color: PdfColors.grey700),
            textDirection: pw.TextDirection.rtl),
      ],
    );
  }

  static pw.Widget _namaValueBox(String label, double width, pw.Font font) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Container(
          width: width,
          height: 0.5,
          color: PdfColors.grey700,
        ),
        pw.SizedBox(width: 6),
        pw.Text(': $label',
            style: pw.TextStyle(font: font, fontSize: 12),
            textDirection: pw.TextDirection.rtl),
      ],
    );
  }
}
