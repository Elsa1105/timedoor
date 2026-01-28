import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static Future<List<int>> getBooked(String bus) async {
    final prefs = await SharedPreferences.getInstance();
    return List<int>.from(jsonDecode(prefs.getString(bus) ?? '[]'));
  }

  static Future<void> confirmBooking(String bus, List<int> seats) async {
    final prefs = await SharedPreferences.getInstance();
    final booked = await getBooked(bus)
      ..addAll(seats);
    final max = bus == 'regular' ? 20 : 12;

    if (booked.length == max) {
      await prefs.remove(bus);
    } else {
      await prefs.setString(bus, jsonEncode(booked));
    }

    final history = jsonDecode(prefs.getString('history') ?? '[]');

    history.add({
      'bus': bus,
      'seats': seats,
      'total': seats.length * (bus == 'regular' ? 85000 : 150000),
    });

    await prefs.setString('history', jsonEncode(history));
  }

  static Future<List> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString('history') ?? '[]');
  }
}
