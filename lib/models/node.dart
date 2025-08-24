  class Node {
    final int x, y;
    bool isWall;
    bool isStart;
    bool isEnd;
    bool isVisited;
    bool isPath;

    // For pathfinding
    double gCost = double.infinity; // Distance from start
    double hCost = double.infinity; // Heuristic distance to end
    double fCost = double.infinity; // gCost + hCost
    Node? parent;

    Node({
      required this.x,
      required this.y,
      this.isWall = false,
      this.isStart = false,
      this.isEnd = false,
      this.isVisited = false,
      this.isPath = false,
    });

    void reset() {
      isVisited = false;
      isPath = false;
      gCost = double.infinity;
      hCost = double.infinity;
      fCost = double.infinity;
      parent = null;
    }

    double distanceTo(Node other) {
      return ((x - other.x) * (x - other.x) + (y - other.y) * (y - other.y)).toDouble();
    }

    double manhattanDistanceTo(Node other) {
      return ((x - other.x).abs() + (y - other.y).abs()).toDouble();
    }


    List<Node> getNeighbors(List<List<Node>> grid) {
      List<Node> neighbors = [];

      List<List<int>> directions = [
        [0, -1],
        [0, 1],
        [-1, 0],
        [1, 0]
      ];

      for (var dir in directions) {
        int newX = x + dir[0];
        int newY = y + dir[1];

        if (newX >= 0 && newX < grid[0].length &&
            newY >= 0 && newY < grid.length) {
          neighbors.add(grid[newY][newX]); // Access grid with grid[y][x]
        }
      }

      return neighbors;
    }

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
            other is Node && runtimeType == other.runtimeType && x == other.x && y == other.y;

    @override
    int get hashCode => x.hashCode ^ y.hashCode;

    @override
    String toString() => 'Node($x, $y)';
  }