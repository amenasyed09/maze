// screens/results_screen.dart
import 'package:flutter/material.dart';
import '../models/path_results.dart';
import 'algorithm_chat_screen.dart';

class ResultsScreen extends StatelessWidget {
  final Map<String, PathResult> results;

  const ResultsScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final sortedResults = results.entries.toList()
      ..sort((a, b) {
        final resultA = a.value;
        final resultB = b.value;

        if (!resultA.pathFound) return 1;
        if (!resultB.pathFound) return -1;

        int pathComparison = resultA.pathLength.compareTo(resultB.pathLength);
        if (pathComparison != 0) return pathComparison;

        int nodesComparison = resultA.nodesExplored.compareTo(resultB.nodesExplored);
        if (nodesComparison != 0) return nodesComparison;

        return resultA.computeTime.compareTo(resultB.computeTime);
      });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Algorithm Results",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                "assets/background.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Results
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 16),
            itemCount: sortedResults.length,
            itemBuilder: (context, index) {
              final entry = sortedResults[index];
              final result = entry.value;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                color: Colors.white.withOpacity(0.9),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Algorithm Name
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Stats
                      _buildStatRow(
                        "Path Found",
                        result.pathFound ? "Yes" : "No",
                        result.pathFound ? Colors.green : Colors.red,
                      ),
                      if (result.pathFound) ...[
                        _buildStatRow("Path Length", "${result.pathLength} steps",
                            Colors.blueAccent),
                        _buildStatRow("Nodes Explored", "${result.nodesExplored}",
                            Colors.orange),
                        _buildStatRow(
                            "Compute Time",
                            "${result.computeTime.inMilliseconds} ms",
                            Colors.teal),
                        _buildStatRow(
                            "Visualization Time",
                            "${result.visualizationTime?.inMilliseconds} ms",
                            Colors.indigo),
                        _buildStatRow(
                            "Efficiency",
                            "${(result.efficiency * 100).toStringAsFixed(1)}%",
                            Colors.purple),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlgorithmChatScreen(results: results),
            ),
          );
        },
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
        label: const Text(
          'Ask AI Why?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
