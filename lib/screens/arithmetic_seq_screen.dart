import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:provider/provider.dart';

import '../providers/sequence_provider.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/graph_plotter.dart';
import '../widgets/result_display_card.dart';

class ArithmeticSequenceScreen extends StatefulWidget {
  const ArithmeticSequenceScreen({super.key});

  @override
  State<ArithmeticSequenceScreen> createState() =>
      _ArithmeticSequenceScreenState();
}

class _ArithmeticSequenceScreenState extends State<ArithmeticSequenceScreen> {
  final TextEditingController _firstTermController = TextEditingController();
  final TextEditingController _commonDifferenceController =
      TextEditingController();
  final TextEditingController _nTermController = TextEditingController();

  @override
  void dispose() {
    _firstTermController.dispose();
    _commonDifferenceController.dispose();
    _nTermController.dispose();
    super.dispose();
  }

  void _calculateArithmetic() {
    final provider = Provider.of<SequenceProvider>(context, listen: false);
    try {
      final double a = double.parse(_firstTermController.text);
      final double d = double.parse(_commonDifferenceController.text);
      final int n = int.parse(_nTermController.text);

      if (n <= 0) {
        _showErrorDialog('Please enter a positive integer for n.');
        return;
      }

      provider.calculateArithmetic(a: a, d: d, n: n);
    } catch (e) {
      _showErrorDialog('Please enter valid numbers for all fields.');
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
      appBar: AppBar(title: const Text('Arithmetic Sequences')),
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
                          controller: _firstTermController,
                          labelText: 'First Term (a)',
                          keyboardType: TextInputType.number,
                          hintText: 'e.g., 2',
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          controller: _commonDifferenceController,
                          labelText: 'Common Difference (d)',
                          keyboardType: TextInputType.number,
                          hintText: 'e.g., 3',
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          controller: _nTermController,
                          labelText: 'Nth Term (n)',
                          keyboardType: TextInputType.number,
                          hintText: 'e.g., 5',
                        ),
                        const SizedBox(height: 24),
                        provider.isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _calculateArithmetic,
                                child: const Text('Calculate'),
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
                        title: 'Nth Term Formula',
                        content: Math.tex(
                          provider.currentResult!.nthTermFormulaLatex,
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ResultDisplayCard(
                        title: 'Nth Term Value (n_{${_nTermController.text}})',
                        content: Text(
                          provider.currentResult!.nthTermValue,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ResultDisplayCard(
                        title: 'Sum Formula',
                        content: Math.tex(
                          provider.currentResult!.sumFormulaLatex,
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ResultDisplayCard(
                        title: 'Sum of N Terms (S_{${_nTermController.text}})',
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
                          title: 'Sequence Visualization',
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
