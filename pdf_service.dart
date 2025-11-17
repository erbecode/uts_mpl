// lib/services/pdf_service.dart
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/room.dart';

class PdfService {
  static Future<Uint8List> generateInvoicePdf({
    required String name,
    required String address,
    required String phone,
    required String email,
    required Room room,
    required int nights,
  }) async {
    final pdf = pw.Document();

    final total = room.price * nights;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice Reservasi Hotel',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.Text('Nama: $name'),
              pw.Text('Alamat: $address'),
              pw.Text('No HP: $phone'),
              pw.Text('Email: $email'),
              pw.SizedBox(height: 12),
              pw.Text('Kamar: ${room.name}'),
              pw.Text('Harga / malam: Rp ${room.price}'),
              pw.Text('Jumlah malam: $nights'),
              pw.SizedBox(height: 12),
              pw.Text(
                'Total: Rp $total',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<void> saveAndLaunchPdf(Uint8List bytes, String filename) async {
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }

  static Future<void> printPdf(Uint8List bytes) async {
    await Printing.layoutPdf(onLayout: (format) => bytes);
  }
}
