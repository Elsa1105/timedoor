import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SeatPage extends StatefulWidget {
  const SeatPage({super.key});

  @override
  State<SeatPage> createState() => _SeatPageState();
}

class _SeatPageState extends State<SeatPage> {
  String bus = 'regular';
  List<int> selected = [];
  List<int> booked = [];

  int get seatCount => bus == 'regular' ? 20 : 12;
  int get price => bus == 'regular' ? 85000 : 150000;

  @override
  void initState() {
    super.initState();
    loadSeats();
  }

  Future<void> loadSeats() async {
    booked = await StorageService.getBooked(bus);
    selected.clear();
    setState(() {});
  }

  void changeBus(String value) {
    setState(() {
      bus = value;
    });
    loadSeats();
  }

  String seatLabel(int i) {
    const rows = ['A', 'B', 'C', 'D', 'E'];
    final row = rows[i ~/ 4];
    final col = (i % 4) + 1;
    return '$row$col';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      appBar: AppBar(
        title: const Text('Bus Seat Booking'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= BUS TYPE =================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: 'regular',
                    groupValue: bus,
                    onChanged: (v) => changeBus(v!),
                  ),
                  const Text('Regular'),
                  const SizedBox(width: 24),
                  Radio(
                    value: 'express',
                    groupValue: bus,
                    onChanged: (v) => changeBus(v!),
                  ),
                  const Text('Express'),
                ],
              ),

              const SizedBox(height: 16),

              /// ================= SEAT GRID =================
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: seatCount,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.2, // 👉 bikin kotak lebih kecil
                ),
                itemBuilder: (_, i) {
                  final isBooked = booked.contains(i);
                  final isSelected = selected.contains(i);

                  Color bgColor;
                  if (isBooked) {
                    bgColor = Colors.grey.shade400;
                  } else if (isSelected) {
                    bgColor = const Color(0xff132B52);
                  } else {
                    bgColor = Colors.grey.shade200;
                  }

                  return GestureDetector(
                    onTap:
                        isBooked
                            ? null
                            : () {
                              setState(() {
                                if (isSelected) {
                                  selected.remove(i);
                                } else {
                                  if (selected.length == 5) return;
                                  selected.add(i);
                                }
                              });
                            },
                    child: Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          seatLabel(i),
                          style: TextStyle(
                            fontSize: 13, // 👉 font lebih kecil
                            fontWeight: FontWeight.w600,
                            color:
                                isBooked || isSelected
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              /// ================= TOTAL =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Price', style: TextStyle(fontSize: 16)),
                  Text(
                    'Rp ${(selected.length * price)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// ================= BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff132B52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed:
                      selected.isEmpty
                          ? null
                          : () async {
                            await StorageService.confirmBooking(bus, selected);
                            Navigator.pushReplacementNamed(context, '/history');
                          },
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
