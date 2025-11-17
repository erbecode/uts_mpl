class Room {
  final String id;
  final String name;
  final String image;
  final int price; // harga per malam
  final bool available;

  Room({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.available,
  });
}

final List<Room> demoRooms = [
  Room(id: 'std', name: 'Standard', image: 'assets/images/standard.png', price: 300000, available: true),
  Room(id: 'sup', name: 'Superior', image: 'assets/images/superior.png', price: 450000, available: true),
  Room(id: 'dlx', name: 'Deluxe', image: 'assets/images/deluxe.png', price: 650000, available: false),
  Room(id: 'jr', name: 'Junior Suite', image: 'assets/images/junior_suite.png', price: 900000, available: true),
  Room(id: 'st', name: 'Suite', image: 'assets/images/suite.png', price: 1500000, available: true),
  Room(id: 'ps', name: 'Presidential Suite', image: 'assets/images/presidential.png', price: 3500000, available: false),
];
