import 'dart:math';

import 'node.dart';

class Maze {
  late List<List<Node>> grid;
  Node? startNode;
  Node? endNode;
  final int width;
  final int height;

  Maze(this.width, this.height) {
    _initializeGrid();
  }

  void _initializeGrid() {
    grid = List.generate(
      height,
          (y) => List.generate(
        width,
            (x) => Node(x: x, y: y),
      ),
    );
  }

  void setWall(int x, int y, bool isWall) {
    if (isValidPosition(x, y)) {
      grid[y][x].isWall = isWall;
    }
  }

  void setStart(int x, int y) {
    // Clear previous start
    if (startNode != null) {
      startNode!.isStart = false;
    }

    if (isValidPosition(x, y)) {
      startNode = grid[y][x];
      startNode!.isStart = true;
      startNode!.isWall = false;
    }
  }

  void setEnd(int x, int y) {
    // Clear previous end
    if (endNode != null) {
      endNode!.isEnd = false;
    }

    if (isValidPosition(x, y)) {
      endNode = grid[y][x];
      endNode!.isEnd = true;
      endNode!.isWall = false;
    }
  }

  bool isValidPosition(int x, int y) {
    return x >= 0 && x < width && y >= 0 && y < height;
  }

  void resetPathfinding() {
    for (var row in grid) {
      for (var node in row) {
        node.reset();
      }
    }
  }

  void clearMaze() {
    for (var row in grid) {
      for (var node in row) {
        node.isWall = false;
        node.isVisited = false;
        node.isPath = false;
        node.reset();
      }
    }
    startNode = null;
    endNode = null;
  }

  void generateRandomMazeWithMultiplePaths() {
    clearMaze();

    for (var row in grid) {
      for (var node in row) {
        node.isWall = true;
      }
    }

    _recursiveBacktrack(1, 1);

    final Random random = Random();
    int wallsToRemove = ((width * height) * 0.05).toInt();

    for (int i = 0; i < wallsToRemove; i++) {
      int x = random.nextInt(width);
      int y = random.nextInt(height);

      if (grid[y][x].isWall) {
        grid[y][x].isWall = false;
      }
    }


    setStart(1, 1);
    setEnd(width - 2, height - 2);
  }

  void _recursiveBacktrack(int x, int y) {
    grid[y][x].isWall = false;

    List<List<int>> directions = [
      [0, -2], [2, 0], [0, 2], [-2, 0]
    ];
    directions.shuffle();

    for (var dir in directions) {
      int newX = x + dir[0];
      int newY = y + dir[1];

      if (isValidPosition(newX, newY) && grid[newY][newX].isWall) {
        grid[y + dir[1] ~/ 2][x + dir[0] ~/ 2].isWall = false;
        _recursiveBacktrack(newX, newY);
      }
    }
  }
}