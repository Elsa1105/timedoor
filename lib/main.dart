import 'package:flutter/material.dart';
import 'pages/home_page.dart' show HomePage;
import 'pages/seat_page.dart';
import 'pages/history_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
        '/seats': (_) => const SeatPage(),
        '/history': (_) => const HistoryPage(),
      },
    );
  }
}
