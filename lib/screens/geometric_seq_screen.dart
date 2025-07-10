import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:provider/provider.dart';
import '../providers/sequence_provider.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/graph_plotter.dart';
import '../widgets/result_display_card.dart';

class GeometricSequenceScreen extends StatefulWidget {
  const GeometricSequenceScreen({super.key});

  @override
  State<GeometricSequenceScreen> createState() =>
      _GeometricSequenceScreenState();
}

class _GeometricSequenceScreenState extends State<GeometricSequenceScreen> {
  final TextEditingController _firstTermController = TextEditingController();
  final TextEditingController _commonRatioController = TextEditingController();
  final TextEditingController _nTermController = TextEditingController();
  bool _isInfiniteSeries = false;

  @override
  void dispose() {
    _firstTermController.dispose();
    _commonRatioController.dispose();
    _nTermController.dispose();
    super.dispose();
  }

  void _calculateGeometric() {
    final provider = Provider.of<SequenceProvider>(context, listen: false);
    try {
      final double a = double.parse(_firstTermController.text);
      final double r = double.parse(_commonRatioController.text);
      final int n = _isInfiniteSeries
          ? 0
          : int.parse(
              _nTermController.text,
            ); // n is not relevant for infinite sum

      if (!_isInfiniteSeries && n <= 0) {
        _showErrorDialog(
          'Please enter a positive integer for n for finite series.',
        );
        return;
      }
      if (_isInfiniteSeries && r.abs() >= 1) {
        _showErrorDialog(
          'For an infinite geometric series to converge, the absolute value of the common ratio (r) must be less than 1 ( |r| < 1 ).',
        );
        return;
      }

      provider.calculateGeometric(
        a: a,
        r: r,
        n: n,
        isInfinite: _isInfiniteSeries,
      );
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
      appBar: AppBar(title: const Text('Geometric Sequences')),
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
                          controller: _commonRatioController,
                          labelText: 'Common Ratio (r)',
                          keyboardType: TextInputType.number,
                          hintText: 'e.g., 0.5 or 2',
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CustomInputField(
                                controller: _nTermController,
                                labelText: 'Nth Term (n)',
                                keyboardType: TextInputType.number,
                                hintText: 'e.g., 5',
                                enabled:
                                    !_isInfiniteSeries, // Disable if infinite
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                const Text('Infinite Sum?'),
                                Switch(
                                  value: _isInfiniteSeries,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _isInfiniteSeries = value;
                                      if (value) {
                                        _nTermController
                                            .clear(); // Clear n if infinite
                                        provider
                                            .clearResult(); // Clear results if mode changes
                                      }
                                    });
                                  },
                                  activeColor: Colors.deepPurple,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        provider.isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _calculateGeometric,
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
                        title:
                            'Nth Term Value (n_{${_nTermController.text.isNotEmpty ? _nTermController.text : 'N/A'}})',
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
                        title: _isInfiniteSeries
                            ? 'Infinite Sum Formula'
                            : 'Sum Formula',
                        content: Math.tex(
                          provider.currentResult!.sumFormulaLatex,
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ResultDisplayCard(
                        title: _isInfiniteSeries
                            ? 'Sum to Infinity (S_{\\infty})'
                            : 'Sum of N Terms (S_{${_nTermController.text}})',
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
