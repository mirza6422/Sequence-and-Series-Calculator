import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sequence_provider.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/graph_plotter.dart';
import '../widgets/result_display_card.dart';

class SigmaNotationScreen extends StatefulWidget {
  const SigmaNotationScreen({super.key});

  @override
  State<SigmaNotationScreen> createState() => _SigmaNotationScreenState();
}

class _SigmaNotationScreenState extends State<SigmaNotationScreen> {
  final TextEditingController _expressionController = TextEditingController();
  final TextEditingController _variableController = TextEditingController();
  final TextEditingController _lowerBoundController = TextEditingController();
  final TextEditingController _upperBoundController = TextEditingController();

  @override
  void dispose() {
    _expressionController.dispose();
    _variableController.dispose();
    _lowerBoundController.dispose();
    _upperBoundController.dispose();
    super.dispose();
  }

  void _calculateSigma() {
    final provider = Provider.of<SequenceProvider>(context, listen: false);
    try {
      final String expression = _expressionController.text;
      final String variable = _variableController.text;
      final int lowerBound = int.parse(_lowerBoundController.text);
      final int upperBound = int.parse(_upperBoundController.text);

      if (expression.isEmpty || variable.isEmpty) {
        _showErrorDialog('Expression and variable cannot be empty.');
        return;
      }
      if (lowerBound > upperBound) {
        _showErrorDialog('Lower bound cannot be greater than upper bound.');
        return;
      }

      provider.calculateSigmaNotation(
        expression: expression,
        variable: variable,
        lowerBound: lowerBound,
        upperBound: upperBound,
      );
    } catch (e) {
      _showErrorDialog(
        'Please enter valid inputs for all fields. Ensure bounds are integers.',
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Input Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sigma Notation Calculator')),
      body: Consumer<SequenceProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CustomInputField(
                          controller: _expressionController,
                          labelText: 'Expression (e.g., 2*k + 1)',
                          keyboardType: TextInputType.text,
                          hintText: 'e.g., 2*k + 1',
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          controller: _variableController,
                          labelText: 'Variable (e.g., k)',
                          keyboardType: TextInputType.text,
                          hintText: 'e.g., k',
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          controller: _lowerBoundController,
                          labelText: 'Lower Bound',
                          keyboardType: TextInputType.number,
                          hintText: 'e.g., 1',
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          controller: _upperBoundController,
                          labelText: 'Upper Bound',
                          keyboardType: TextInputType.number,
                          hintText: 'e.g., 5',
                        ),
                        const SizedBox(height: 24),
                        provider.isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _calculateSigma,
                                child: const Text('Calculate Sum'),
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (provider.errorMessage != null)
                  ResultDisplayCard(
                    title: 'Error',
                    content: Text(
                      provider.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  )
                else if (provider.currentResult != null)
                  Column(
                    children: [
                      ResultDisplayCard(
                        title: 'Calculated Sum',
                        content: Text(
                          provider.currentResult!.sumValue,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ResultDisplayCard(
                        title: 'Step-by-Step Solution',
                        content: Text(
                          provider.currentResult!.stepByStepSolution,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      if (provider.currentResult!.graphPoints.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        GraphPlotter(
                          title: 'Terms Visualization',
                          points: provider.currentResult!.graphPoints,
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
