import 'dart:async';
import 'package:flutter/material.dart';
import '../models/maze.dart';
import '../models/node.dart';

import '../models/path_results.dart';
import 'maze_grid.dart';

class PathVisualizer extends StatefulWidget {
  final Maze maze;
  final PathResult result;

  const PathVisualizer({
    required this.maze,
    required this.result,
  });

  @override
  State<PathVisualizer> createState() => _PathVisualizerState();
}

class _PathVisualizerState extends State<PathVisualizer> {
  late Maze maze;

  @override
  void initState() {
    super.initState();
    maze = Maze(widget.maze.width, widget.maze.height);
    maze.grid = _cloneGrid(widget.maze.grid);
    _animate();
  }

  Future<void> _animate() async {
    for (final node in widget.result.visitedNodes) {
      if (!maze.grid[node.y][node.x].isStart && !maze.grid[node.y][node.x].isEnd) {
        setState(() => maze.grid[node.y][node.x].isVisited = true);
        await Future.delayed(Duration(milliseconds: 20));
      }
    }

    for (final node in widget.result.path) {
      if (!maze.grid[node.y][node.x].isStart && !maze.grid[node.y][node.x].isEnd) {
        setState(() => maze.grid[node.y][node.x].isPath = true);
        await Future.delayed(Duration(milliseconds: 30));
      }
    }
  }

  List<List<Node>> _cloneGrid(List<List<Node>> original) {
    return original
        .map((row) => row.map((node) => Node(x: node.x, y: node.y, isWall: node.isWall)).toList())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MazeGrid(maze: maze);
  }
}
