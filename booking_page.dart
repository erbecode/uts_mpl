// lib/screens/booking_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/room.dart';
import 'invoice_page.dart';

class BookingPage extends StatefulWidget {
  final Room room;
  const BookingPage({super.key, required this.room});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  final checkInCtrl = TextEditingController();
  final checkOutCtrl = TextEditingController();

  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  final RegExp _phoneRegExp = RegExp(r'^[0-9]+$');
  final RegExp _emailRegExp = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
      r"@"
      r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
      r"(?:\.[a-zA-Z]{2,})+$");

  final DateFormat _displayFormat = DateFormat('yyyy-MM-dd');

  @override
  void dispose() {
    nameCtrl.dispose();
    addressCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    checkInCtrl.dispose();
    checkOutCtrl.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Masukkan nama pelanggan';
    }
    return null;
  }

  String? _validateAddress(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Masukkan alamat';
    }
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Masukkan nomor HP';
    }
    if (!_phoneRegExp.hasMatch(v.trim())) {
      return 'Nomor HP hanya boleh berisi angka';
    }
    if (v.trim().length < 6) {
      return 'Nomor HP terlalu pendek';
    }
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Masukkan email';
    }
    if (!_emailRegExp.hasMatch(v.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _validateDates() {
    if (_checkInDate == null) {
      return 'Pilih tanggal check-in';
    }
    if (_checkOutDate == null) {
      return 'Pilih tanggal check-out';
    }
    if (!_checkOutDate!.isAfter(_checkInDate!)) {
      return 'Tanggal check-out harus setelah check-in';
    }
    final nights = _checkOutDate!.difference(_checkInDate!).inDays;
    if (nights < 1) {
      return 'Lama inap minimal 1 malam';
    }
    return null;
  }

  int get nights {
    if (_checkInDate == null || _checkOutDate == null) {
      return 0;
    }
    return _checkOutDate!.difference(_checkInDate!).inDays;
  }

  Future<void> _pickCheckIn() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? today,
      firstDate: today,
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() {
        _checkInDate = picked;
        checkInCtrl.text = _displayFormat.format(picked);

        if (_checkOutDate == null || !_checkOutDate!.isAfter(picked)) {
          final nextDay = picked.add(const Duration(days: 1));
          _checkOutDate = nextDay;
          checkOutCtrl.text = _displayFormat.format(nextDay);
        }
      });
    } else {
      // picked == null -> user cancelled picker; do nothing but keep code explicit
      setState(() {
        // intentionally empty to signal no change, but keeps analyzer happy
      });
    }
  }

  Future<void> _pickCheckOut() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final minDate = _checkInDate != null
        ? _checkInDate!.add(const Duration(days: 1))
        : today.add(const Duration(days: 1));

    final picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate ?? minDate,
      firstDate: minDate,
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
        checkOutCtrl.text = _displayFormat.format(picked);
      });
    } else {
      // user cancelled -> keep explicit setState (no change)
      setState(() {
        // intentionally empty
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.room.price * nights;

    return Scaffold(
      appBar: AppBar(title: const Text('Pemesanan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(),
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: addressCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
                validator: _validateAddress,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'No HP',
                  border: OutlineInputBorder(),
                ),
                validator: _validatePhone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: checkInCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Check-in',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickCheckIn,
                  ),
                ),
                onTap: _pickCheckIn,
                validator: (_) => _validateDates(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: checkOutCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Check-out',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickCheckOut,
                  ),
                ),
                onTap: _pickCheckOut,
                validator: (_) => _validateDates(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Lama inap: $nights malam'),
                  Text(
                    'Total: Rp $total',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final dateError = _validateDates();

                  if (_formKey.currentState!.validate() &&
                      dateError == null &&
                      nights > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InvoicePage(
                          name: nameCtrl.text.trim(),
                          address: addressCtrl.text.trim(),
                          phone: phoneCtrl.text.trim(),
                          email: emailCtrl.text.trim(),
                          room: widget.room,
                          nights: nights,
                        ),
                      ),
                    );
                  } else {
                    if (dateError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(dateError)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Periksa kembali data yang Anda input')),
                      );
                    }
                  }
                },
                child: const Text('Buat Invoice'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
