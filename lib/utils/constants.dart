import 'package:flutter/material.dart';

class AppConstants {

  static const int GRID_SIZE = 20;
  static const double CELL_SIZE = 18.0;

  static const Color WALL_COLOR = Colors.black;
  static const Color PATH_COLOR = Colors.white;
  static const Color START_COLOR = Colors.green;
  static const Color END_COLOR = Colors.red;
  static const Color VISITED_COLOR = Colors.lightBlue;
  static const Color CURRENT_COLOR = Colors.yellow;
  static const Color SOLUTION_COLOR = Colors.purple;

  static const Map<String, Color> ALGORITHM_COLORS = {
    'A*': Colors.purple,
    'BFS': Colors.blue,
    'DFS': Colors.orange,
    'Dijkstra': Colors.green,
  };

  static const int ANIMATION_SPEED = 50; // milliseconds
  static const int FAST_SPEED = 20;
  static const int SLOW_SPEED = 200;
}

enum CellType { wall, path, start, end, visited, current, solution }
enum AlgorithmState { ready, running, completed, failed }