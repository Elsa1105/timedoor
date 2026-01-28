import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales History')),
      body: FutureBuilder(
        future: StorageService.getHistory(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data as List;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder:
                (_, i) => ListTile(
                  title: Text(
                    'Bus: ${data[i]['bus']} | Seats: ${data[i]['seats']}',
                  ),
                  subtitle: Text('Total: Rp ${data[i]['total']}'),
                ),
          );
        },
      ),
    );
  }
}
