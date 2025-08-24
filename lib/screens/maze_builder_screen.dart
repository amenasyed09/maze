import 'package:flutter/material.dart';
import '../models/maze.dart';
import 'algorithm_race_screen.dart';
import 'maze_grid.dart';

class MazeBuilderScreen extends StatefulWidget {
  @override
  _MazeBuilderScreenState createState() => _MazeBuilderScreenState();
}

class _MazeBuilderScreenState extends State<MazeBuilderScreen> {
  static const int rows = 20;
  static const int cols = 20;

  late Maze maze;

  @override
  void initState() {
    super.initState();
    maze = Maze(cols, rows);
    maze.setStart(0, 0);
    maze.setEnd(cols - 1, rows - 1);
  }

  void _toggleWall(int x, int y) {
    setState(() {
      final node = maze.grid[y][x];
      if (!node.isStart && !node.isEnd) {
        node.isWall = !node.isWall;
      }
    });
  }

  void _startRace() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AlgorithmRaceScreen(maze: maze)),
    );
  }

  void _generateRandom() {
    setState(() {
      maze.generateRandomMazeWithMultiplePaths();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Build Your Maze"),
        actions: [
          IconButton(icon: Icon(Icons.shuffle), onPressed: _generateRandom),
          IconButton(icon: Icon(Icons.play_arrow), onPressed: _startRace),
        ],
      ),
      body: Stack(
        children: [

          Column(
            children: [
              Expanded(
                child: MazeGrid(maze: maze, onCellTapped: _toggleWall),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,

                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _startRace,
                  icon: Icon(Icons.rocket_launch, color: Colors.white),
                  label: Text(
                    "Start Algorithm Race",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
