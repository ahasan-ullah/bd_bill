import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/bill_result.dart';
import '../models/bill_settings.dart';
import '../utils/formatters.dart';

class PdfInvoiceService {
  static const String _primaryHex = '#224E3F';
  static const String _primaryLightHex = '#7BA18E';

  static Future<void> generateAndDownloadStatement({
    required BillResult result,
    required BillingSettings settings,
  }) async {
    final doc = pw.Document();

    // Load local bundled Unicode-compatible font for Bengali Taka symbol (৳)
    pw.ThemeData theme;
    try {
      final fontRegularData =
          await rootBundle.load('assets/fonts/NotoSansBengali-Regular.ttf');
      final fontBoldData =
          await rootBundle.load('assets/fonts/NotoSansBengali-Bold.ttf');
      final fontRegular = pw.Font.ttf(fontRegularData);
      final fontBold = pw.Font.ttf(fontBoldData);
      theme = pw.ThemeData.withFont(
        base: fontRegular,
        bold: fontBold,
      );
    } catch (_) {
      try {
        final fontRegular = await PdfGoogleFonts.notoSansBengaliRegular();
        final fontBold = await PdfGoogleFonts.notoSansBengaliBold();
        theme = pw.ThemeData.withFont(
          base: fontRegular,
          bold: fontBold,
        );
      } catch (_) {
        theme = pw.ThemeData.base();
      }
    }

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        margin: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 1. Page Title
              pw.Text(
                'Electricity bill statement',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#0F172A'),
                ),
              ),
              pw.SizedBox(height: 14),
              pw.Divider(color: PdfColor.fromHex('#E2E8F0'), thickness: 0.8),
              pw.SizedBox(height: 12),

              // 2. Consumption & Load Row
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Consumption',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColor.fromHex('#64748B'),
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.RichText(
                          text: pw.TextSpan(
                            children: [
                              pw.TextSpan(
                                text: '${result.consumedUnits} ',
                                style: pw.TextStyle(
                                  fontSize: 18,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex('#0F172A'),
                                ),
                              ),
                              pw.TextSpan(
                                text: 'kWh',
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  color: PdfColor.fromHex('#334155'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Load',
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColor.fromHex('#64748B'),
                          ),
                        ),
                        pw.SizedBox(height: 3),
                        pw.RichText(
                          text: pw.TextSpan(
                            children: [
                              pw.TextSpan(
                                text: '${result.loadCount} ',
                                style: pw.TextStyle(
                                  fontSize: 18,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex('#0F172A'),
                                ),
                              ),
                              pw.TextSpan(
                                text: 'kW',
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  color: PdfColor.fromHex('#334155'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(color: PdfColor.fromHex('#E2E8F0'), thickness: 0.8),
              pw.SizedBox(height: 16),

              // 3. Energy by slab Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Energy by slab',
                    style: pw.TextStyle(
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#0F172A'),
                    ),
                  ),
                  pw.Text(
                    '${result.slabBreakdowns.length} slabs used',
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColor.fromHex('#64748B'),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),

              // Energy by slab Table Columns
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Text(
                        'Range',
                        style: pw.TextStyle(
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#64748B'),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        'Used (kWh)',
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#64748B'),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        'Rate / kWh',
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#64748B'),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        'Amount',
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#64748B'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Energy by slab Rows
              ...result.slabBreakdowns.map((slab) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 5),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 4,
                        child: pw.Text(
                          slab.slabTitle,
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColor.fromHex('#0F172A'),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          slab.units % 1 == 0
                              ? slab.units.toInt().toString()
                              : slab.units.toString(),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColor.fromHex('#0F172A'),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          '৳${slab.rate.toStringAsFixed(2)}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColor.fromHex('#0F172A'),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          CurrencyFormatter.format(slab.charge),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColor.fromHex('#0F172A'),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Total energy charge row
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 6),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Text(
                        'Total energy charge',
                        style: pw.TextStyle(
                          fontSize: 10.5,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#0F172A'),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        result.consumedUnits.toString(),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                          fontSize: 10.5,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#0F172A'),
                        ),
                      ),
                    ),
                    pw.Expanded(flex: 2, child: pw.Container()),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        CurrencyFormatter.format(result.energyCharge),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                          fontSize: 10.5,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#0F172A'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // 4. Charge Summary Header
              pw.Text(
                'Charge summary',
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#0F172A'),
                ),
              ),
              pw.SizedBox(height: 10),

              // Charge summary Table Columns
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 4),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Text(
                        'Charge',
                        style: pw.TextStyle(
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#64748B'),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 4,
                      child: pw.Text(
                        'Basis',
                        style: pw.TextStyle(
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#64748B'),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        'Amount',
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#64748B'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Summary Rows
              _buildChargeRow(
                charge: 'Energy charge',
                basis: 'From slabs above',
                amount: CurrencyFormatter.format(result.energyCharge),
              ),
              _buildChargeRow(
                charge: 'Demand charge',
                basis:
                    '${result.loadCount} kW × ৳${settings.demandCharge.toStringAsFixed(0)} / kW',
                amount: CurrencyFormatter.format(result.demandCharge),
              ),
              _buildChargeRow(
                charge: 'Meter rent',
                basis: '',
                amount: CurrencyFormatter.format(result.meterRent),
              ),
              pw.Divider(color: PdfColor.fromHex('#E2E8F0'), thickness: 0.8),
              _buildChargeRow(
                charge: 'Subtotal',
                basis: '',
                amount: CurrencyFormatter.format(result.subtotal),
                isBold: true,
              ),
              _buildChargeRow(
                charge: 'VAT',
                basis:
                    '${settings.vatPercentage.toStringAsFixed(0)}% of ৳${CurrencyFormatter.formatNumber(result.subtotal)}',
                amount: CurrencyFormatter.format(result.vatAmount),
              ),

              pw.SizedBox(height: 14),

              // Solid Forest Green Accent Line (New Theme)
              pw.Container(
                height: 1.5,
                color: PdfColor.fromHex(_primaryHex),
              ),
              pw.SizedBox(height: 10),

              // Total Payable Bill Row (New Theme Green)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'Total payable bill',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex(_primaryHex),
                    ),
                  ),
                  pw.Text(
                    CurrencyFormatter.format(result.totalPayable),
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex(_primaryHex),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Container(
                height: 0.8,
                color: PdfColor.fromHex(_primaryLightHex),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'BD_Bill_Statement_${result.consumedUnits}kWh.pdf',
    );
  }

  static pw.Widget _buildChargeRow({
    required String charge,
    required String basis,
    required String amount,
    bool isBold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 4,
            child: pw.Text(
              charge,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: PdfColor.fromHex('#0F172A'),
              ),
            ),
          ),
          pw.Expanded(
            flex: 4,
            child: pw.Text(
              basis,
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColor.fromHex('#64748B'),
              ),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Text(
              amount,
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: PdfColor.fromHex('#0F172A'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
