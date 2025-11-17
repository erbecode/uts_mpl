import 'package:flutter/material.dart';
import '../models/room.dart';
import 'booking_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Room? selectedRoom;

  @override
  void initState() {
    super.initState();
    selectedRoom = demoRooms.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hotel Nusantara')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Kategori Kamar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            /// Dropdown – menggunakan initialValue (bukan value)
            DropdownButtonFormField<Room>(
              initialValue: selectedRoom,
              decoration: const InputDecoration(
                labelText: "Kategori Kamar",
                border: OutlineInputBorder(),
              ),
              items: demoRooms
                  .map(
                    (room) => DropdownMenuItem(
                      value: room,
                      child: Text(room.name),
                    ),
                  )
                  .toList(),
              onChanged: (room) {
                setState(() {
                  selectedRoom = room;
                });
              },
            ),

            const SizedBox(height: 20),

            if (selectedRoom != null)
              Card(
                elevation: 4,
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        selectedRoom!.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ListTile(
                      title: Text(selectedRoom!.name),
                      subtitle: Text(
                        'Harga: Rp ${selectedRoom!.price}',
                      ),
                      trailing: Text(
                        selectedRoom!.available ? 'Tersedia' : 'Full',
                        style: TextStyle(
                          color: selectedRoom!.available
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.book_online),
                        label: const Text('Pemesanan'),
                        onPressed: selectedRoom!.available
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        BookingPage(room: selectedRoom!),
                                  ),
                                );
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
