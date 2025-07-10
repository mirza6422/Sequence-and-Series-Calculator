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
      // Calculate nth term and sum
      final double nthTermValue = a + (n - 1) * d;
      final double sumValue = (n / 2) * (2 * a + (n - 1) * d);

      // LaTeX formulas for flutter_math_fork (no dollar signs)
      final String nthTermFormulaLatex = r'a_n = a + (n - 1) d';
      final String sumFormulaLatex =
          r'S_n = \frac{n}{2} \bigl(2a + (n - 1) d\bigr)';

      // Build step-by-step solution
      final StringBuffer steps = StringBuffer();
      steps.writeln('Given: a = $a, d = $d, n = $n');
      steps.writeln('\n--- Nth Term Calculation ---');
      steps.writeln('Formula: $nthTermFormulaLatex');
      steps.writeln(
        r'Substitute: a_' +
            n.toString() +
            ' = ' +
            a.toString() +
            ' + (' +
            (n - 1).toString() +
            ') * ' +
            d.toString(),
      );
      steps.writeln(
        r'a_' + n.toString() + ' = ' + nthTermValue.toStringAsFixed(4),
      );

      steps.writeln('\n--- Sum of N Terms Calculation ---');
      steps.writeln('Formula: ' + sumFormulaLatex);
      steps.writeln(
        r'Substitute: S_' +
            n.toString() +
            ' = \frac{' +
            n.toString() +
            '}{2} (2*' +
            a.toString() +
            ' + (' +
            (n - 1).toString() +
            ')*' +
            d.toString() +
            ')',
      );
      steps.writeln(r'S_' + n.toString() + ' = ' + sumValue.toStringAsFixed(4));

      // Graph points
      final List<double> graphPoints = List.generate(n, (i) => a + i * d);

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
      return SequenceResult.withError('Error in arithmetic calculation: $e');
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
      // Nth term
      final String nthTermFormulaLatex = r'a_n = a r^{n - 1}';
      final double? nthTermValue = isInfinite ? null : a * pow(r, n - 1);

      // Sum logic
      late double? sumValue;
      late String sumFormulaLatex;
      if (isInfinite) {
        if (r.abs() < 1) {
          sumValue = a / (1 - r);
          sumFormulaLatex = r'S_∞ = \frac{a}{1 - r}';
        } else {
          sumValue = null;
          sumFormulaLatex = r'S_∞ diverges if |r| ≥ 1';
        }
      } else {
        if (r == 1) {
          sumValue = a * n;
          sumFormulaLatex = r'S_n = n · a';
        } else {
          sumValue = a * (1 - pow(r, n)) / (1 - r);
          sumFormulaLatex = r'S_n = \frac{a \bigl(1 - r^n\bigr)}{1 - r}';
        }
      }

      // Steps
      final StringBuffer steps = StringBuffer();
      steps.writeln('Given: a = $a, r = $r');
      if (!isInfinite) steps.writeln('n = $n');

      steps.writeln('\n--- Nth Term Calculation ---');
      steps.writeln('Formula: $nthTermFormulaLatex');
      if (!isInfinite) {
        steps.writeln(
          r'Substitute: a_' +
              n.toString() +
              '=' +
              a.toString() +
              ' · ' +
              r.toString() +
              '^' +
              (n - 1).toString(),
        );
        steps.writeln(
          r'a_' + n.toString() + ' = ' + nthTermValue!.toStringAsFixed(4),
        );
      } else {
        steps.writeln('Infinite series, nth term not applicable');
      }

      steps.writeln('\n--- Sum Calculation ---');
      steps.writeln('Formula: ' + sumFormulaLatex);
      if (sumValue != null) {
        steps.writeln(r'S = ' + sumValue.toStringAsFixed(4));
      } else {
        steps.writeln('Series diverges');
      }

      // Graph points
      final int limit = isInfinite ? 10 : n;
      final List<double> graphPoints = List.generate(
        limit,
        (i) => a * pow(r, i),
      );

      return SequenceResult(
        type: 'geometric',
        nthTermFormulaLatex: nthTermFormulaLatex,
        nthTermValue: nthTermValue == null
            ? 'N/A'
            : nthTermValue.toStringAsFixed(4),
        sumFormulaLatex: sumFormulaLatex,
        sumValue: sumValue == null ? 'Diverges' : sumValue.toStringAsFixed(4),
        stepByStepSolution: steps.toString(),
        graphPoints: graphPoints,
      );
    } catch (e) {
      return SequenceResult.withError('Error in geometric calculation: $e');
    }
  }

  // --- Sigma Notation Logic ---
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

      // LaTeX for sigma (no dollar signs)
      final String sigmaFormulaLatex =
          r'\sum_{' +
          variable +
          '=' +
          lowerBound.toString() +
          '}^{' +
          upperBound.toString() +
          '} (' +
          expression.replaceAll(variable, variable) +
          ')';

      steps.writeln('Formula: $sigmaFormulaLatex');
      steps.writeln('Expand and evaluate each term:');

      for (int i = lowerBound; i <= upperBound; i++) {
        final String currentExpr = expression.replaceAll(
          variable,
          i.toString(),
        );
        final double termValue = _evaluateSimpleExpression(currentExpr);
        totalSum += termValue;
        graphPoints.add(termValue);
        steps.writeln(
          '$variable = $i: $currentExpr = ${termValue.toStringAsFixed(4)}',
        );
      }

      steps.writeln('\nSum = ${totalSum.toStringAsFixed(4)}');

      return SequenceResult(
        type: 'sigma',
        sumValue: totalSum.toStringAsFixed(4),
        stepByStepSolution: steps.toString(),
        graphPoints: graphPoints,
      );
    } catch (e) {
      return SequenceResult.withError('Error in sigma notation: $e');
    }
  }

  // --- Recurrence Relation Logic ---
  SequenceResult calculateRecurrence({
    required String recurrenceRelation,
    required Map<String, double> initialConditions,
    required int n,
  }) {
    try {
      final Map<int, double> terms = {};
      final StringBuffer steps = StringBuffer();
      final List<double> graphPoints = [];

      // Record initial conditions
      initialConditions.forEach((key, value) {
        final match = RegExp(r'a\((\d+)\)').firstMatch(key);
        if (match != null) {
          final idx = int.parse(match.group(1)!);
          terms[idx] = value;
          steps.writeln('a($idx) = ${value.toStringAsFixed(4)}');
          graphPoints.add(value);
        }
      });

      // Compute terms up to n
      for (int i = 0; i <= n; i++) {
        if (terms.containsKey(i)) continue;
        String expr = recurrenceRelation;
        expr = expr.replaceAll('a(n)', '').replaceAll('=', '').trim();
        expr = expr.replaceAllMapped(RegExp(r'a\(n-(\d+)\)'), (m) {
          final prev = i - int.parse(m.group(1)!);
          return terms[prev]!.toString();
        });
        final double val = _evaluateSimpleExpression(expr);
        terms[i] = val;
        steps.writeln('a($i) = $expr = ${val.toStringAsFixed(4)}');
        graphPoints.add(val);
      }

      return SequenceResult(
        type: 'recurrence',
        nthTermValue: terms[n]!.toStringAsFixed(4),
        stepByStepSolution: steps.toString(),
        graphPoints: graphPoints,
      );
    } catch (e) {
      return SequenceResult.withError('Error in recurrence relation: $e');
    }
  }

  // --- Helper for simple expression evaluation ---
  double _evaluateSimpleExpression(String expression) {
    String expr = expression.replaceAll(' ', '');
    // Handle * and /
    while (expr.contains('*') || expr.contains('/')) {
      final match = RegExp(
        r'(-?\d+\.?\d*)([*/])(-?\d+\.?\d*)',
      ).firstMatch(expr);
      if (match == null) break;
      final a = double.parse(match.group(1)!);
      final b = double.parse(match.group(3)!);
      final res = match.group(2) == '*' ? a * b : a / b;
      expr = expr.replaceFirst(match.group(0)!, res.toString());
    }
    // Handle + and -
    while (expr.contains('+') ||
        (expr.contains('-') && !expr.startsWith('-'))) {
      final match = RegExp(
        r'(-?\d+\.?\d*)([+\-])(-?\d+\.?\d*)',
      ).firstMatch(expr);
      if (match == null) break;
      final a = double.parse(match.group(1)!);
      final b = double.parse(match.group(3)!);
      final res = match.group(2) == '+' ? a + b : a - b;
      expr = expr.replaceFirst(match.group(0)!, res.toString());
    }
    return double.parse(expr);
  }
}
