import 'dart:math';

import '../models/sequence_result.dart';

class MathCalculator {
  // --- Arithmetic Sequence Logic ---
  SequenceResult calculateArithmetic({
    required double a,
    required double d,
    required int n,
  }) {
    try {
      // Calculate nth term
      final double nthTermValue = a + (n - 1) * d;

      // Calculate sum of n terms
      final double sumValue = (n / 2) * (2 * a + (n - 1) * d);

      // Generate LaTeX formulas
      final String nthTermFormulaLatex = r'a_n = a + (n-1)d';
      final String sumFormulaLatex = 'S_n = \\frac{n}{2}(2a + (n-1)d)';

      // Generate step-by-step solution
      final StringBuffer steps = StringBuffer();
      steps.writeln(
        "Given: First term (a) = $a, Common difference (d) = $d, Term number (n) = $n",
      );
      steps.writeln("\n--- Nth Term Calculation ---");
      steps.writeln(
        "The formula for the nth term of an arithmetic sequence is: \$a_n = a + (n-1)d\$",
      );
      steps.writeln("Substitute the given values: \$a_{$n} = $a + ($n-1)$d\$");
      steps.writeln("\$a_{$n} = $a + ${(n - 1) * d}\$");
      steps.writeln("\$a_{$n} = $nthTermValue\$");

      steps.writeln("\n--- Sum of N Terms Calculation ---");
      steps.writeln(
        "The formula for the sum of the first n terms of an arithmetic sequence is: \$S_n = \\frac{n}{2}(2a + (n-1)d)\$",
      );
      steps.writeln(
        "Substitute the given values: \$S_{$n} = \\frac{$n}{2}(2($a) + ($n-1)$d)\$",
      );
      steps.writeln("\$S_{$n} = \\frac{$n}{2}(${2 * a} + ${(n - 1) * d})\$");
      steps.writeln("\$S_{$n} = \\frac{$n}{2}(${2 * a + (n - 1) * d})\$");
      steps.writeln("\$S_{$n} = $sumValue\$");

      // Generate graph points
      final List<double> graphPoints = [];
      for (int i = 1; i <= n; i++) {
        graphPoints.add(a + (i - 1) * d);
      }

      return SequenceResult(
        type: 'arithmetic',
        nthTermFormulaLatex: nthTermFormulaLatex,
        nthTermValue: nthTermValue.toStringAsFixed(4),
        sumFormulaLatex: sumFormulaLatex,
        sumValue: sumValue.toStringAsFixed(4),
        stepByStepSolution: steps.toString(),
        graphPoints: graphPoints,
      );
    } catch (e) {
      return SequenceResult.withError(
        'Error calculating arithmetic sequence: $e',
      );
    }
  }

  // --- Geometric Sequence Logic ---
  SequenceResult calculateGeometric({
    required double a,
    required double r,
    required int n,
    bool isInfinite = false,
  }) {
    try {
      double nthTermValue;
      String nthTermFormulaLatex = 'a_n = ar^{n-1}';
      if (!isInfinite) {
        nthTermValue = a * pow(r, n - 1);
      } else {
        nthTermValue = double.nan; // Not applicable for infinite series
      }

      double sumValue;
      String sumFormulaLatex;
      if (isInfinite) {
        if (r.abs() < 1) {
          sumValue = a / (1 - r);
          sumFormulaLatex = 'S_\\infty = \\frac{a}{1-r}';
        } else {
          sumValue = double.infinity; // Diverges
          sumFormulaLatex = 'S_\\infty \\text{ diverges if } |r| \\ge 1';
        }
      } else {
        if (r == 1) {
          sumValue = a * n;
          sumFormulaLatex = 'S_n = n \\cdot a \\text{ (if r=1)}';
        } else {
          sumValue = a * (1 - pow(r, n)) / (1 - r);
          sumFormulaLatex = 'S_n = \\frac{a(1-r^n)}{1-r}';
        }
      }

      // Generate step-by-step solution
      final StringBuffer steps = StringBuffer();
      steps.writeln("Given: First term (a) = $a, Common ratio (r) = $r");
      if (!isInfinite) {
        steps.writeln("Term number (n) = $n");
      }

      steps.writeln("\n--- Nth Term Calculation ---");
      steps.writeln(
        "The formula for the nth term of a geometric sequence is: \$a_n = ar^{n-1}\$",
      );
      if (!isInfinite) {
        steps.writeln(
          "Substitute the given values: \$a_{$n} = $a \\cdot $r^{${n - 1}}\$",
        );
        steps.writeln("\$a_{$n} = $nthTermValue\$");
      } else {
        steps.writeln(
          "Nth term calculation is not directly applicable for an infinite series in the same way as finite.",
        );
      }

      steps.writeln("\n--- Sum Calculation ---");
      if (isInfinite) {
        if (r.abs() < 1) {
          steps.writeln(
            "For an infinite geometric series where \$|r| < 1\$, the sum is: \$S_\\infty = \\frac{a}{1-r}\$",
          );
          steps.writeln(
            "Substitute the given values: \$S_\\infty = \\frac{$a}{1-$r}\$",
          );
          steps.writeln("\$S_\\infty = $sumValue\$");
        } else {
          steps.writeln(
            "The infinite geometric series diverges because \$|r| \\ge 1\$.",
          );
          steps.writeln("Sum to infinity: Diverges");
        }
      } else {
        steps.writeln(
          "The formula for the sum of the first n terms of a geometric sequence is: \$S_n = \\frac{a(1-r^n)}{1-r}\$",
        );
        steps.writeln(
          "Substitute the given values: \$S_{$n} = \\frac{$a(1-$r^{$n})}{1-$r}\$",
        );
        if (r == 1) {
          steps.writeln(
            "If r=1, \$S_n = n \\cdot a = $n \\cdot $a = $sumValue\$",
          );
        } else {
          steps.writeln("\$S_{$n} = $sumValue\$");
        }
      }

      // Generate graph points
      final List<double> graphPoints = [];
      int limit = n;
      if (isInfinite) {
        limit = 10; // Plot first 10 terms for visualization
      }
      for (int i = 1; i <= limit; i++) {
        graphPoints.add(a * pow(r, i - 1));
      }

      return SequenceResult(
        type: 'geometric',
        nthTermFormulaLatex: nthTermFormulaLatex,
        nthTermValue: nthTermValue.isNaN
            ? "N/A"
            : nthTermValue.toStringAsFixed(4),
        sumFormulaLatex: sumFormulaLatex,
        sumValue: sumValue.isInfinite
            ? "Diverges"
            : sumValue.toStringAsFixed(4),
        stepByStepSolution: steps.toString(),
        graphPoints: graphPoints,
      );
    } catch (e) {
      return SequenceResult.withError(
        'Error calculating geometric sequence: $e',
      );
    }
  }

  // --- Sigma Notation Logic (Numerical Only) ---
  SequenceResult calculateSigmaNotation({
    required String expression,
    required String variable,
    required int lowerBound,
    required int upperBound,
  }) {
    try {
      double totalSum = 0.0;
      final StringBuffer steps = StringBuffer();
      final List<double> graphPoints = [];

      steps.writeln(
        "Given sum: \$\\sum_{$variable=$lowerBound}^{$upperBound} ($expression)\$",
      );
      steps.writeln(
        "Expand the sum by substituting values from lower bound to upper bound:",
      );

      for (int i = lowerBound; i <= upperBound; i++) {
        // Basic numerical evaluation: Replace variable with current value
        // WARNING: This is a very basic and limited parser.
        // For robust, secure, and complex expression parsing, consider a dedicated math expression parser library.
        String currentExpression = expression.replaceAll(
          variable,
          i.toString(),
        );

        // Attempt to evaluate the string expression.
        // This is a simplified approach. For production, use a dedicated math expression evaluator.
        // For example, you could use a package like 'math_expressions' or write a more robust parser.
        // Here, we'll try a very basic evaluation for simple cases.
        double termValue;
        try {
          // This is a highly simplified and potentially unsafe way to evaluate.
          // It only works for very basic arithmetic.
          // For example, "2*k+1" becomes "2*1+1"
          // A real parser would build an AST and evaluate it.
          termValue = _evaluateSimpleExpression(currentExpression);
        } catch (e) {
          return SequenceResult.withError(
            'Error evaluating expression "$currentExpression": $e. Please use simple arithmetic (e.g., 2*k + 1).',
          );
        }

        totalSum += termValue;
        graphPoints.add(termValue);
        steps.writeln("For \$$variable=$i\$: $currentExpression = $termValue");
      }

      steps.writeln("\nAdd the terms together:");
      steps.writeln("Sum = $totalSum");

      return SequenceResult(
        type: 'sigma',
        sumValue: totalSum.toStringAsFixed(4),
        stepByStepSolution: steps.toString(),
        graphPoints: graphPoints,
      );
    } catch (e) {
      return SequenceResult.withError('Error calculating sigma notation: $e');
    }
  }

  // Helper for very simple numerical expression evaluation (limited)
  // This is NOT a robust math expression parser.
  double _evaluateSimpleExpression(String expression) {
    // Basic operations, order of operations not fully robust
    // This is a placeholder. For real-world, use a package like `math_expressions`.
    try {
      expression = expression.replaceAll(' ', ''); // Remove spaces
      // Handle multiplication and division first
      while (expression.contains('*') || expression.contains('/')) {
        RegExp exp = RegExp(r'(-?\d+\.?\d*)([*/])(-?\d+\.?\d*)');
        var match = exp.firstMatch(expression);
        if (match == null) break;
        double num1 = double.parse(match.group(1)!);
        double num2 = double.parse(match.group(3)!);
        double result;
        if (match.group(2) == '*') {
          result = num1 * num2;
        } else {
          result = num1 / num2;
        }
        expression = expression.replaceFirst(
          match.group(0)!,
          result.toString(),
        );
      }
      // Handle addition and subtraction
      while (expression.contains('+') ||
          (expression.contains('-') && expression.indexOf('-') != 0)) {
        RegExp exp = RegExp(r'(-?\d+\.?\d*)([+\-])(-?\d+\.?\d*)');
        var match = exp.firstMatch(expression);
        if (match == null) break;
        double num1 = double.parse(match.group(1)!);
        double num2 = double.parse(match.group(3)!);
        double result;
        if (match.group(2) == '+') {
          result = num1 + num2;
        } else {
          result = num1 - num2;
        }
        expression = expression.replaceFirst(
          match.group(0)!,
          result.toString(),
        );
      }
      return double.parse(expression);
    } catch (e) {
      throw FormatException(
        'Invalid expression format for simple evaluation: $expression',
      );
    }
  }

  // --- Recurrence Relation Logic (Iterative Only) ---
  SequenceResult calculateRecurrence({
    required String recurrenceRelation,
    required Map<String, double> initialConditions,
    required int n,
  }) {
    try {
      final Map<int, double> terms = {};
      final StringBuffer steps = StringBuffer();
      final List<double> graphPoints = [];

      // Parse initial conditions
      final Map<int, double> parsedInitialConditions = {};
      for (var entry in initialConditions.entries) {
        final String key = entry.key; // e.g., "a(0)", "a(1)"
        final double value = entry.value;
        final RegExpMatch? match = RegExp(r'a\((\d+)\)').firstMatch(key);
        if (match != null && match.groupCount > 0) {
          final int index = int.parse(match.group(1)!);
          parsedInitialConditions[index] = value;
          terms[index] = value;
          steps.writeln("Initial condition: \$a($index) = $value\$");
          graphPoints.add(value);
        } else {
          return SequenceResult.withError(
            'Invalid initial condition key format: $key. Expected "a(index)".',
          );
        }
      }

      final int startIndex = terms.keys.isEmpty
          ? 0
          : terms.keys.reduce(max) + 1;

      // Iterate to calculate terms up to n
      for (int i = startIndex; i <= n; i++) {
        String currentRelation = recurrenceRelation;
        bool canCalculate = true;

        // Replace a(n-k) terms with their known values
        final RegExp termRegex = RegExp(r'a\(n-(\d+)\)');
        currentRelation = currentRelation.replaceAllMapped(termRegex, (match) {
          final int offset = int.parse(match.group(1)!);
          final int prevIndex = i - offset;
          if (terms.containsKey(prevIndex)) {
            return terms[prevIndex]!.toString();
          } else {
            canCalculate = false;
            return ''; // Placeholder, as we'll mark as uncalculable
          }
        });

        if (!canCalculate) {
          steps.writeln(
            "Cannot calculate \$a($i)\$: Missing initial conditions for required previous terms.",
          );
          return SequenceResult(
            type: 'recurrence',
            nthTermValue: "Insufficient initial conditions",
            stepByStepSolution: steps.toString(),
            graphPoints: graphPoints,
            error: "Insufficient initial conditions to calculate up to $n.",
          );
        }

        // Replace 'a(n)' and '=' for evaluation
        currentRelation = currentRelation
            .replaceAll('a(n)', '')
            .replaceAll('=', '')
            .trim();

        double termValue;
        try {
          // Evaluate the expression string
          // WARNING: This is a simplified numerical evaluation.
          // For a production app, use a robust math expression parser.
          termValue = _evaluateSimpleExpression(currentRelation);
        } catch (e) {
          steps.writeln(
            "Error evaluating \$a($i)\$: $e. Expression: $currentRelation",
          );
          return SequenceResult.withError(
            'Error evaluating recurrence relation for term $i: $e',
          );
        }

        terms[i] = termValue;
        steps.writeln("\$a($i) = $currentRelation = $termValue\$");
        graphPoints.add(termValue);
      }

      final double? finalNTermValue = terms[n];
      if (finalNTermValue == null) {
        return SequenceResult.withError(
          'Could not calculate $n-th term. Check relation and initial conditions.',
        );
      }

      return SequenceResult(
        type: 'recurrence',
        nthTermValue: finalNTermValue.toStringAsFixed(4),
        stepByStepSolution: steps.toString(),
        graphPoints: graphPoints,
      );
    } catch (e) {
      return SequenceResult.withError(
        'Error calculating recurrence relation: $e',
      );
    }
  }
}
