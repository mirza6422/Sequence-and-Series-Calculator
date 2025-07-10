import 'package:flutter/material.dart';

import '../models/sequence_result.dart';
import '../services/math_calculator.dart';

class SequenceProvider with ChangeNotifier {
  final MathCalculator _mathCalculator =
      MathCalculator(); // Instantiate the local math calculator
  SequenceResult? _currentResult;
  bool _isLoading = false;
  String? _errorMessage;

  SequenceResult? get currentResult => _currentResult;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // No initialization needed for MathCalculator as it's pure Dart
  SequenceProvider();

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setResult(SequenceResult? result) {
    _currentResult = result;
    _errorMessage = result?.error; // Update error message from result
    notifyListeners();
  }

  void clearResult() {
    _currentResult = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> calculateArithmetic({
    required double a,
    required double d,
    required int n,
  }) async {
    _setLoading(true);
    clearResult(); // Clear previous results
    // Call the Dart-only math calculator
    final result = _mathCalculator.calculateArithmetic(a: a, d: d, n: n);
    _setResult(result);
    _setLoading(false);
  }

  Future<void> calculateGeometric({
    required double a,
    required double r,
    required int n,
    bool isInfinite = false,
  }) async {
    _setLoading(true);
    clearResult(); // Clear previous results
    // Call the Dart-only math calculator
    final result = _mathCalculator.calculateGeometric(
      a: a,
      r: r,
      n: n,
      isInfinite: isInfinite,
    );
    _setResult(result);
    _setLoading(false);
  }

  Future<void> calculateSigmaNotation({
    required String expression,
    required String variable,
    required int lowerBound,
    required int upperBound,
  }) async {
    _setLoading(true);
    clearResult(); // Clear previous results
    // Call the Dart-only math calculator
    final result = _mathCalculator.calculateSigmaNotation(
      expression: expression,
      variable: variable,
      lowerBound: lowerBound,
      upperBound: upperBound,
    );
    _setResult(result);
    _setLoading(false);
  }

  Future<void> calculateRecurrence({
    required String recurrenceRelation,
    required Map<String, double> initialConditions,
    required int n,
  }) async {
    _setLoading(true);
    clearResult(); // Clear previous results
    // Call the Dart-only math calculator
    final result = _mathCalculator.calculateRecurrence(
      recurrenceRelation: recurrenceRelation,
      initialConditions: initialConditions,
      n: n,
    );
    _setResult(result);
    _setLoading(false);
  }
}
