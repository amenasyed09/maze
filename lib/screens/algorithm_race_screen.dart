  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
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
      // Force landscape orientation
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      _startRace();
    }

    @override
    void dispose() {
      // Reset orientation when leaving the screen
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      super.dispose();
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
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.6, // control how much of background is visible
                child: Image.asset(
                  "assets/background.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 30,),
                Expanded(
                  child: Row(
                    children: results.entries.map((entry) {
                      return Expanded(
                        child: Column(
                          children: [
                           getImage(entry.key),
                        getText(entry.key),
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
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.brown ,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResultsScreen(results: results),
                          ),
                        );
                      },
                      child: Text("View Results",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.white),),
                    ),
                  )
              ],
            ),
          ],
        ),
      );
    }
    Widget getImage(String key)
    {


    switch(key){
       case 'DFS (Turtle)':
         return Image.asset('assets/turtle.jpg',width: 20,);
       case 'BFS (Rabbit)':
        return Image.asset('assets/rabbit.jpg',width: 20,);
      case 'A* (Eagle)'  :
        return Image.asset('assets/eagle.webp',width: 20,);
      default :
        return Image.asset('assets/eagle.webp',width: 20,);


     }
    }
    Widget getText(String key)
    {


      switch(key){
        case 'DFS (Turtle)':
          return Text('DFS',style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black),);
        case 'BFS (Rabbit)':
          return Text('BFS',style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black),);

        case 'A* (Eagle)'  :
          return Text('A*',style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black),);
        default :
          return Text('DFS',style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black),);



      }
    }
  }
