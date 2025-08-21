// In your PathResult class (path_result.dart)

import 'node.dart';

class PathResult {
  final List<Node> path;
  final List<Node> visitedNodes;
  final String algorithmName;
  final Duration timeTaken;
  final bool pathFound;

  PathResult({
    required this.path,
    required this.visitedNodes,
    required this.algorithmName,
    required this.timeTaken,
  }) : pathFound = path.isNotEmpty; // Path is found if the path list is not empty

  // FIX: Calculate pathLength directly from the path list.
  int get pathLength => path.length;

  // FIX: Calculate nodesExplored directly from the visitedNodes list.
  int get nodesExplored => visitedNodes.length;

  // FIX: The efficiency calculation is now automatically correct and safe.
  double get efficiency => (pathFound && nodesExplored > 0) ? pathLength / nodesExplored : 0.0;

  @override
  String toString() {
    return '$algorithmName: ${pathFound ? "Found path of length $pathLength" : "No path found"} '
        '(Explored: $nodesExplored, Time: ${timeTaken.inMilliseconds}ms)';
  }
}