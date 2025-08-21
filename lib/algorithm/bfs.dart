import 'dart:collection';
import '../models/node.dart';
import '../models/maze.dart';

import '../models/path_results.dart';

class BFS {
  static Future<PathResult> findPath(Maze maze, {Function(Node)? onNodeVisited}) async {
    if (maze.startNode == null || maze.endNode == null) {
      return PathResult(
        path: [],
        visitedNodes: [],
        algorithmName: 'BFS',

        timeTaken: Duration.zero,

      );
    }

    Stopwatch stopwatch = Stopwatch()..start();
    maze.resetPathfinding();

    Node start = maze.startNode!;
    Node end = maze.endNode!;
    List<Node> visitedNodes = [];

    Queue<Node> queue = Queue<Node>();
    Set<Node> visited = <Node>{};

    queue.add(start);
    visited.add(start);

    while (queue.isNotEmpty) {
      Node current = queue.removeFirst();

      current.isVisited = true;
      visitedNodes.add(current);

      if (onNodeVisited != null) {
        onNodeVisited(current);
        await Future.delayed(Duration(milliseconds: 50));
      }

      if (current == end) {
        stopwatch.stop();
        List<Node> path = _reconstructPath(current);
        return PathResult(
          path: path,
          visitedNodes: visitedNodes,
          algorithmName: 'BFS',

          timeTaken: stopwatch.elapsed,

        );
      }

      for (Node neighbor in current.getNeighbors(maze.grid)) {
        if (!neighbor.isWall && !visited.contains(neighbor)) {
          neighbor.parent = current;
          visited.add(neighbor);
          queue.add(neighbor);
        }
      }
    }

    stopwatch.stop();
    return PathResult(
      path: [],
      visitedNodes: visitedNodes,
      algorithmName: 'BFS',

      timeTaken: stopwatch.elapsed,

    );
  }

  static List<Node> _reconstructPath(Node endNode) {
    List<Node> path = [];
    Node? current = endNode;

    while (current != null) {
      path.add(current);
      current = current.parent;
    }

    return path.reversed.toList();
  }
}