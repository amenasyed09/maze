
import 'package:flutter/material.dart';
import '../models/maze.dart';
import '../models/node.dart';

class MazeGrid extends StatelessWidget {
  final Maze maze;
  final void Function(int x, int y)? onCellTapped;
  final String? aiCharacter;
  final int? aiX;
  final int? aiY;

  const MazeGrid({
    required this.maze,
    this.onCellTapped,
    this.aiCharacter,
    this.aiX,
    this.aiY,
  });

  Color? _getColor(Node node) {

    if (node.isPath && node.isVisited) return Colors.orange;
    if (node.isVisited && !node.isWall) return Colors.blue.withOpacity(0.5);
    return null;
  }

  String? _getImagePath(Node node) {
    if (node.isStart || node.isEnd) return 'assets/portal.webp';
    if (node.isWall) return 'assets/mud.jpg';
    if (!node.isVisited) return 'assets/grass.webp';
    return null;
  }

  String? _getCharacterImagePath() {
    if (aiCharacter == null) return null;
    return 'assets/images/$aiCharacter.png';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        final double maxWidth = constraints.maxWidth;
        final double maxHeight = constraints.maxHeight;

        final double sizeByWidth = maxWidth / maze.width;
        final double sizeByHeight = maxHeight / maze.height;


        final double cellSize = (sizeByWidth < sizeByHeight ? sizeByWidth : sizeByHeight)
            .clamp(2.0, 20.0);

        return Center(
          child: SizedBox(
            width: maze.width * cellSize,
            height: maze.height * cellSize,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: maze.grid.asMap().entries.map((rowEntry) {
                final int rowIndex = rowEntry.key;
                final List row = rowEntry.value;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.asMap().entries.map((colEntry) {
                    final int colIndex = colEntry.key;
                    final Node node = colEntry.value;

                    return GestureDetector(
                      onTap: () {
                        if (onCellTapped != null) onCellTapped!(node.x, node.y);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: cellSize,
                        height: cellSize,
                        decoration: BoxDecoration(
                          color: _getColor(node) ?? Colors.transparent,
                          border: cellSize > 4 && _getColor(node) != null
                              ? Border.all(
                            color: Colors.grey.shade400,
                            width: cellSize > 10 ? 0.5 : 0.2,
                          )
                              : null,
                          borderRadius: (node.isStart || node.isEnd) && _getColor(node) != null
                              ? BorderRadius.circular(cellSize * 0.2)
                              : null,
                        ),
                        child: Stack(
                          children: [
                            // Background image (if not visited or for walls/portals)
                            if (_getImagePath(node) != null)
                              Positioned.fill(
                                child: Image.asset(
                                  _getImagePath(node)!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {

                                    return Container(
                                      color: node.isWall ? Colors.black : Colors.white,
                                    );
                                  },
                                ),
                              ),

                            if (aiX == node.x && aiY == node.y && _getCharacterImagePath() != null)
                              Positioned.fill(
                                child: Image.asset(
                                  _getCharacterImagePath()!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {

                                    return Icon(
                                      Icons.pets,
                                      size: cellSize * 0.8,
                                      color: Colors.purple,
                                    );
                                  },
                                ),
                              ),


                            if (cellSize > 16 && _getColor(node) != null)
                              Positioned.fill(
                                child: _buildCellContent(node, cellSize) ?? const SizedBox(),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget? _buildCellContent(Node node, double cellSize) {
    if (cellSize < 12) return null;

    IconData? icon;
    Color? iconColor;

    if (node.isStart) {
      icon = Icons.play_arrow;
      iconColor = Colors.white;
    } else if (node.isEnd) {
      icon = Icons.flag;
      iconColor = Colors.white;
    } else if (node.isPath) {
      icon = Icons.circle;
      iconColor = Colors.white;
    }

    if (icon != null) {
      return Icon(
        icon,
        size: cellSize * 0.6,
        color: iconColor,
      );
    }

    return null;
  }
}