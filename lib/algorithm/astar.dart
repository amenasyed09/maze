import 'package:collection/collection.dart';

import '../models/maze.dart';
import '../models/node.dart';
import '../models/path_results.dart';

class AStar {
  static Future<PathResult> findPath(Maze maze, {Function(Node)? onNodeVisited}) async {
    if (maze.startNode == null || maze.endNode == null) {
      return PathResult(
        path: [],
        visitedNodes: [],
        algorithmName: 'A*',
        computeTime: Duration.zero,
        visualizationTime: Duration.zero,
      );
    }

    Stopwatch stopwatch = Stopwatch()..start();
    maze.resetPathfinding();

    Node start = maze.startNode!;
    Node end = maze.endNode!;
    List<Node> visitedNodes = [];

    PriorityQueue<Node> openSet = PriorityQueue<Node>((a, b) => a.fCost.compareTo(b.fCost));
    Set<Node> closedSet = <Node>{};

    start.gCost = 0;
    start.hCost = start.manhattanDistanceTo(end);
    start.fCost = start.gCost + start.hCost;

    openSet.add(start);

    while (openSet.isNotEmpty) {
      Node current = openSet.removeFirst();
      closedSet.add(current);

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
          algorithmName: 'A*',
          computeTime: stopwatch.elapsed,
          visualizationTime: Duration(milliseconds: visitedNodes.length * 50),
        );
      }

      for (Node neighbor in current.getNeighbors(maze.grid)) {
        if (neighbor.isWall || closedSet.contains(neighbor)) continue;

        double tentativeGCost = current.gCost + 1;

        if (tentativeGCost < neighbor.gCost) {
          neighbor.parent = current;
          neighbor.gCost = tentativeGCost;
          neighbor.hCost = neighbor.manhattanDistanceTo(end);
          neighbor.fCost = neighbor.gCost + neighbor.hCost;

          if (!openSet.contains(neighbor)) {
            openSet.add(neighbor);
          }
        }
      }
    }

    stopwatch.stop();
    return PathResult(
      path: [],
      visitedNodes: visitedNodes,
      algorithmName: 'A*',
      computeTime: stopwatch.elapsed,
      visualizationTime: Duration(milliseconds: visitedNodes.length * 50),
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
