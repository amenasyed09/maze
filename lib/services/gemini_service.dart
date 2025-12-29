// services/gemini_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/path_results.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  static final String _apiKey =
      dotenv.env['GEMINI_API_KEY'] ?? '';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';
  static Future<String> analyzeAlgorithmResults(
      Map<String, PathResult> results,
      String userQuestion,
      ) async {
    try {
      final winner = findWinner(results);
      final analysisContext = _buildAnalysisContext(results, winner);

      final prompt = '''
You are an AI algorithm expert analyzing a maze-solving competition. Here's the race data:

$analysisContext

User Question: $userQuestion

Please provide an insightful, educational response that:
1. Answers the user's specific question
2. Explains algorithmic concepts in simple terms
3. Uses the actual race data to support your explanation
4. Keeps response under 200 words
5. Be engaging and conversational

Focus on why certain algorithms performed better/worse based on the maze characteristics and algorithm properties.
''';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': _apiKey,
        },
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": "Explain Dijkstra’s algorithm briefly."}
              ]
            }
          ]
        }),
      );

      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return 'Sorry, I couldn\'t analyze the results right now. Please try again.';
      }
    } catch (e) {
      return 'Error analyzing results: ${e.toString()}';
    }
  }

  static String findWinner(Map<String, PathResult> results) {
    PathResult? bestResult;
    String winner = '';

    for (var entry in results.entries) {
      final result = entry.value;

      if (result.pathFound) {
        if (bestResult == null ||
            result.pathLength < bestResult.pathLength ||
            (result.pathLength == bestResult.pathLength &&
                result.nodesExplored < bestResult.nodesExplored) ||
            (result.pathLength == bestResult.pathLength &&
                result.nodesExplored == bestResult.nodesExplored &&
                result.computeTime < bestResult.computeTime)) {
          bestResult = result;
          winner = entry.key;
        }
      }
    }

    return winner.isNotEmpty ? winner : 'No winner (no paths found)';
  }


  static String _buildAnalysisContext(Map<String, PathResult> results, String winner) {
    final buffer = StringBuffer();
    buffer.writeln('RACE RESULTS:');
    buffer.writeln('Winner: $winner\n');

    for (var entry in results.entries) {
      final result = entry.value;
      buffer.writeln('${entry.key}:');
      buffer.writeln('- Path Found: ${result.pathFound}');
      if (result.pathFound) {
        buffer.writeln('- Path Length: ${result.pathLength}');
        buffer.writeln('- Nodes Explored: ${result.nodesExplored}');
        buffer.writeln('- Compute Time: ${result.computeTime.inMilliseconds} ms');
        buffer.writeln('- Visualization Time: ${result.visualizationTime?.inMilliseconds} ms');
        buffer.writeln('- Efficiency: ${(result.efficiency * 100).toStringAsFixed(1)}%');
      }
      buffer.writeln();
    }

    return buffer.toString();
  }

  static List<String> getSuggestedQuestions(Map<String, PathResult> results) {
    final winner = findWinner(results);
    return [
      'Why did $winner win this race?',
      'Which algorithm was most efficient and why?',
      'What maze characteristics influenced these results?',
      'How do the time complexities compare here?',
      'Which algorithm explored the fewest nodes?',
      'What would happen in a different maze layout?',
      'Explain the trade-offs between these algorithms',
    ];
  }
}