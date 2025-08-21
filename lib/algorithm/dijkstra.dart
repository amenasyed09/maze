import 'dart:collection';
import 'package:collection/collection.dart';

import '../models/node.dart';
import '../models/maze.dart';

import '../models/path_results.dart';

class Dijkstra {
  static Future<PathResult> findPath(Maze maze, {Function(Node)? onNodeVisited}) async {
    if (maze.startNode == null || maze.endNode == null) {
      return PathResult(
        path: [],
        visitedNodes: [],
        algorithmName: 'Dijkstra',

        timeTaken: Duration.zero,

      );
    }

    Stopwatch stopwatch = Stopwatch()..start();
    maze.resetPathfinding();

    Node start = maze.startNode!;
    Node end = maze.endNode!;
    List<Node> visitedNodes = [];

    PriorityQueue<Node> queue = PriorityQueue<Node>((a, b) => a.gCost.compareTo(b.gCost));
    Set<Node> visited = <Node>{};

    start.gCost = 0;
    queue.add(start);

    while (queue.isNotEmpty) {
      Node current = queue.removeFirst();

      if (visited.contains(current)) continue;
      visited.add(current);

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
          algorithmName: 'Dijkstra',

          timeTaken: stopwatch.elapsed,

        );
      }

      for (Node neighbor in current.getNeighbors(maze.grid)) {
        if (neighbor.isWall || visited.contains(neighbor)) continue;

        double newDistance = current.gCost + 1;

        if (newDistance < neighbor.gCost) {
          neighbor.gCost = newDistance;
          neighbor.parent = current;
          queue.add(neighbor);
        }
      }
    }

    stopwatch.stop();
    return PathResult(
      path: [],
      visitedNodes: visitedNodes,
      algorithmName: 'Dijkstra',

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