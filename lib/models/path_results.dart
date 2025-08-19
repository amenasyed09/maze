import 'node.dart';

class PathResult {
  final List<Node> path;
  final List<Node> visitedNodes;
  final String algorithmName;
  final int pathLength;
  final int nodesExplored;
  final Duration timeTaken;
  final bool pathFound;

  PathResult({
    required this.path,
    required this.visitedNodes,
    required this.algorithmName,
    required this.pathLength,
    required this.nodesExplored,
    required this.timeTaken,
    required this.pathFound,
  });

  double get efficiency => pathFound ? pathLength / nodesExplored : 0.0;

  @override
  String toString() {
    return '$algorithmName: ${pathFound ? "Found path of length $pathLength" : "No path found"} '
        '(Explored: $nodesExplored, Time: ${timeTaken.inMilliseconds}ms)';
  }
}