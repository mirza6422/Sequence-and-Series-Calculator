class SequenceResult {
  final String type; // e.g., 'arithmetic', 'geometric'
  final String nthTermFormulaLatex;
  final String nthTermValue;
  final String sumFormulaLatex;
  final String sumValue;
  final String stepByStepSolution;
  final List<double> graphPoints; // For visualization
  final String? error; // For backend errors

  SequenceResult({
    required this.type,
    this.nthTermFormulaLatex = '',
    this.nthTermValue = '',
    this.sumFormulaLatex = '',
    this.sumValue = '',
    this.stepByStepSolution = '',
    this.graphPoints = const [],
    this.error,
  });

  factory SequenceResult.fromJson(Map<String, dynamic> json) {
    return SequenceResult(
      type: json['type'] ?? 'unknown',
      nthTermFormulaLatex: json['nth_term_formula_latex'] ?? '',
      nthTermValue: json['nth_term_value']?.toString() ?? '',
      sumFormulaLatex: json['sum_formula_latex'] ?? '',
      sumValue: json['sum_value']?.toString() ?? '',
      stepByStepSolution:
          json['step_by_step_solution'] ??
          'No step-by-step solution available.',
      graphPoints:
          (json['graph_points'] as List<dynamic>?)
              ?.map((e) => e as double)
              .toList() ??
          [],
      error: json['error'],
    );
  }

  // Factory constructor for error state
  factory SequenceResult.withError(String errorMessage) {
    return SequenceResult(type: 'error', error: errorMessage);
  }
}
