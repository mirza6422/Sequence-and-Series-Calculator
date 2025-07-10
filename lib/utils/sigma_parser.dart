class SigmaParser {
  static SigmaParams parse(String expr) {
    // Simple placeholder; extend parsing logic as needed
    return SigmaParams(
      start: 1.0,
      diff: 1.0,
      ratio: 1.0,
      count: 5,
      isGeometric: false,
    );
  }
}

class SigmaParams {
  final double start, diff, ratio;
  final int count;
  final bool isGeometric;
  SigmaParams({
    required this.start,
    required this.diff,
    required this.ratio,
    required this.count,
    required this.isGeometric,
  });
}
