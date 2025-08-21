import '../models/node.dart';
import '../models/maze.dart';

import '../models/path_results.dart';

class DFS {
  static Future<PathResult> findPath(Maze maze, {Function(Node)? onNodeVisited}) async {
    if (maze.startNode == null || maze.endNode == null) {
      return PathResult(
        path: [],
        visitedNodes: [],
        algorithmName: 'DFS',

        timeTaken: Duration.zero,

      );
    }

    Stopwatch stopwatch = Stopwatch()..start();
    maze.resetPathfinding();

    Node start = maze.startNode!;
    Node end = maze.endNode!;
    List<Node> visitedNodes = [];
    Set<Node> visited = <Node>{};

    bool pathFound = await _dfsRecursive(start, end, visited, visitedNodes, maze, onNodeVisited);

    stopwatch.stop();

    if (pathFound) {
      List<Node> path = _reconstructPath(end);
      return PathResult(
        path: path,
        visitedNodes: visitedNodes,
        algorithmName: 'DFS',

        timeTaken: stopwatch.elapsed,

      );
    }

    return PathResult(
      path: [],
      visitedNodes: visitedNodes,
      algorithmName: 'DFS',

      timeTaken: stopwatch.elapsed,

    );
  }

  static Future<bool> _dfsRecursive(
      Node current,
      Node end,
      Set<Node> visited,
      List<Node> visitedNodes,
      Maze maze,
      Function(Node)? onNodeVisited,
      ) async {
    visited.add(current);
    current.isVisited = true;
    visitedNodes.add(current);

    if (onNodeVisited != null) {
      onNodeVisited(current);
      await Future.delayed(Duration(milliseconds: 50));
    }

    if (current == end) {
      return true;
    }

    for (Node neighbor in current.getNeighbors(maze.grid)) {
      if (!neighbor.isWall && !visited.contains(neighbor)) {
        neighbor.parent = current;
        if (await _dfsRecursive(neighbor, end, visited, visitedNodes, maze, onNodeVisited)) {
          return true;
        }
      }
    }

    return false;
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