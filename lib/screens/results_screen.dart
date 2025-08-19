import 'package:flutter/material.dart';

import '../models/path_results.dart';

class ResultsScreen extends StatelessWidget {
  final Map<String, PathResult> results;

  const ResultsScreen({required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Results Summary")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: results.entries.map((entry) {
          final r = entry.value;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text(entry.key),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("✅ Path Found: ${r.pathFound}"),
                  Text("📏 Path Length: ${r.pathLength}"),
                  Text("🔍 Nodes Explored: ${r.nodesExplored}"),
                  Text("⏱️ Time Taken: ${r.timeTaken.inMilliseconds} ms"),
                  Text("📈 Efficiency: ${r.efficiency.toStringAsFixed(2)}"),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
