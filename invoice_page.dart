// lib/screens/invoice_page.dart
import 'package:flutter/material.dart';
import '../models/room.dart';
import '../services/pdf_service.dart';

class InvoicePage extends StatelessWidget {
  final String name;
  final String address;
  final String phone;
  final String email;
  final Room room;
  final int nights;

  const InvoicePage({
    super.key,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.room,
    required this.nights,
  });

  String _formatCurrency(int value) {
    // simple formatting: add thousand separator (basic)
    final s = value.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }
    final reversed = buffer.toString().split('').reversed.join();
    return 'Rp $reversed';
  }

  @override
  Widget build(BuildContext context) {
    final int total = room.price * nights;

    return Scaffold(
      appBar: AppBar(title: const Text('Invoice')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Nama: $name'),
            Text('Alamat: $address'),
            Text('No HP: $phone'),
            Text('Email: $email'),
            const SizedBox(height: 12),
            Text('Kamar: ${room.name}'),
            Text('Harga / malam: ${_formatCurrency(room.price)}'),
            Text('Jumlah malam: $nights'),
            const SizedBox(height: 12),
            Text(
              'Total: ${_formatCurrency(total)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Simpan ke PDF'),
                  onPressed: () async {
                    final pdfBytes = await PdfService.generateInvoicePdf(
                      name: name,
                      address: address,
                      phone: phone,
                      email: email,
                      room: room,
                      nights: nights,
                    );
                    await PdfService.saveAndLaunchPdf(
                      pdfBytes,
                      'invoice_${DateTime.now().millisecondsSinceEpoch}.pdf',
                    );
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.print),
                  label: const Text('Print'),
                  onPressed: () async {
                    final pdfBytes = await PdfService.generateInvoicePdf(
                      name: name,
                      address: address,
                      phone: phone,
                      email: email,
                      room: room,
                      nights: nights,
                    );
                    await PdfService.printPdf(pdfBytes);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
