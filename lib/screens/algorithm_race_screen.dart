import 'package:flutter/material.dart';
import 'package:maze/screens/path_visualizer.dart';
import '../algorithm/astar.dart';
import '../algorithm/bfs.dart';
import '../algorithm/dfs.dart';
import '../models/maze.dart';
import '../models/node.dart';
import '../models/path_results.dart';
import 'results_screen.dart';

class AlgorithmRaceScreen extends StatefulWidget {
  final Maze maze;

  const AlgorithmRaceScreen({required this.maze});

  @override
  State<AlgorithmRaceScreen> createState() => _AlgorithmRaceScreenState();
}

class _AlgorithmRaceScreenState extends State<AlgorithmRaceScreen> {
  Map<String, PathResult> results = {};
  bool raceCompleted = false;

  @override
  void initState() {
    super.initState();
    _startRace();
  }

  Future<void> _startRace() async {
    final dfsMaze = Maze(widget.maze.width, widget.maze.height)..grid = _cloneGrid(widget.maze.grid);
    final bfsMaze = Maze(widget.maze.width, widget.maze.height)..grid = _cloneGrid(widget.maze.grid);
    final astarMaze = Maze(widget.maze.width, widget.maze.height)..grid = _cloneGrid(widget.maze.grid);

    dfsMaze.setStart(widget.maze.startNode!.x, widget.maze.startNode!.y);
    dfsMaze.setEnd(widget.maze.endNode!.x, widget.maze.endNode!.y);

    bfsMaze.setStart(widget.maze.startNode!.x, widget.maze.startNode!.y);
    bfsMaze.setEnd(widget.maze.endNode!.x, widget.maze.endNode!.y);

    astarMaze.setStart(widget.maze.startNode!.x, widget.maze.startNode!.y);
    astarMaze.setEnd(widget.maze.endNode!.x, widget.maze.endNode!.y);

    final dfsResult = await DFS.findPath(dfsMaze);
    final bfsResult = await BFS.findPath(bfsMaze);
    final astarResult = await AStar.findPath(astarMaze);

    setState(() {
      results = {
        'DFS (Turtle)': dfsResult,
        'BFS (Rabbit)': bfsResult,
        'A* (Eagle)': astarResult,
      };
      raceCompleted = true;
    });
  }

  List<List<Node>> _cloneGrid(List<List<Node>> original) {
    return original
        .map((row) => row.map((node) => Node(x: node.x, y: node.y, isWall: node.isWall)).toList())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Algorithm Race")),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: results.entries.map((entry) {
                return Expanded(
                  child: Column(
                    children: [
                      Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(
                        child: PathVisualizer(
                          maze: widget.maze,
                          result: entry.value,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          if (raceCompleted)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultsScreen(results: results),
                    ),
                  );
                },
                child: Text("View Results"),
              ),
            )
        ],
      ),
    );
  }
}
