import 'package:flutter/material.dart';
import '../models/maze.dart';
import '../models/node.dart';

class MazeGrid extends StatelessWidget {
  final Maze maze;
  final void Function(int x, int y)? onCellTapped;

  const MazeGrid({
    required this.maze,
    this.onCellTapped,
  });

  Color _getColor(Node node) {
    if (node.isStart) return Colors.green;
    if (node.isEnd) return Colors.red;
    if (node.isPath) return Colors.orange;
    if (node.isVisited) return Colors.blue.withOpacity(0.5);
    if (node.isWall) return Colors.black;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width / maze.width;

    return Column(
      children: maze.grid.map((row) {
        return Row(
          children: row.map((node) {
            return GestureDetector(
              onTap: () {
                if (onCellTapped != null) onCellTapped!(node.x, node.y);
              },
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: _getColor(node),
                  border: Border.all(color: Colors.grey.shade300, width: 0.5),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
