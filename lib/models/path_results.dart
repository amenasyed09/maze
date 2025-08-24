import 'node.dart';

class PathResult {
  final List<Node> path;
  final List<Node> visitedNodes;
  final String algorithmName;
  final Duration computeTime;
  final Duration? visualizationTime;
  final bool pathFound;

  PathResult({
    required this.path,
    required this.visitedNodes,
    required this.algorithmName,
    required this.computeTime,
    this.visualizationTime,
  }) : pathFound = path.isNotEmpty;

  int get pathLength => path.length;
  int get nodesExplored => visitedNodes.length;

  double get efficiency =>
      (pathFound && nodesExplored > 0) ? pathLength / nodesExplored : 0.0;

  @override
  String toString() {
    return '$algorithmName: '
        '${pathFound ? "Found path of length $pathLength" : "No path found"} '
        '(Explored: $nodesExplored, '
        'Compute: ${computeTime.inMilliseconds}ms, '
        'Visual: ${visualizationTime?.inMilliseconds ?? 0}ms)';
  }
}
