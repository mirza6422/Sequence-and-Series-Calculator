import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sequence_provider.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/graph_plotter.dart';
import '../widgets/result_display_card.dart';

class RecurrenceScreen extends StatefulWidget {
  const RecurrenceScreen({super.key});

  @override
  State<RecurrenceScreen> createState() => _RecurrenceScreenState();
}

class _RecurrenceScreenState extends State<RecurrenceScreen> {
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _nTermController = TextEditingController();
  final Map<TextEditingController, TextEditingController> _initialConditions =
      {};
  int _initialConditionCount = 1;

  @override
  void initState() {
    super.initState();
    _addInitialConditionField();
  }

  void _addInitialConditionField() {
    setState(() {
      _initialConditions[TextEditingController()] = TextEditingController();
      _initialConditionCount = _initialConditions.length;
    });
  }

  void _removeInitialConditionField(TextEditingController keyController) {
    setState(() {
      _initialConditions.remove(keyController);
      keyController.dispose();
      _initialConditionCount = _initialConditions.length;
    });
  }

  @override
  void dispose() {
    _relationController.dispose();
    _nTermController.dispose();
    _initialConditions.forEach((key, value) {
      key.dispose();
      value.dispose();
    });
    super.dispose();
  }

  void _calculateRecurrence() {
    final provider = Provider.of<SequenceProvider>(context, listen: false);
    try {
      final String relation = _relationController.text;
      final int n = int.parse(_nTermController.text);
      final Map<String, double> parsedInitialConditions = {};

      for (var entry in _initialConditions.entries) {
        final key = entry.key.text.trim();
        final value = entry.value.text.trim();
        if (key.isNotEmpty && value.isNotEmpty) {
          parsedInitialConditions[key] = double.parse(value);
        }
      }

      if (relation.isEmpty) {
        _showErrorDialog('Recurrence relation cannot be empty.');
        return;
      }
      if (n <= 0) {
        _showErrorDialog('Please enter a positive integer for n.');
        return;
      }
      if (parsedInitialConditions.isEmpty) {
        _showErrorDialog('Please provide at least one initial condition.');
        return;
      }

      provider.calculateRecurrence(
        recurrenceRelation: relation,
        initialConditions: parsedInitialConditions,
        n: n,
      );
    } catch (e) {
      _showErrorDialog(
        'Please enter valid inputs for all fields. Ensure n and initial conditions are numbers.',
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
      appBar: AppBar(title: const Text('Recurrence Relations')),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomInputField(
                          controller: _relationController,
                          labelText:
                              'Recurrence Relation (e.g., a(n) = a(n-1) + a(n-2))',
                          keyboardType: TextInputType.text,
                          hintText: 'e.g., a(n) = a(n-1) + a(n-2)',
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          controller: _nTermController,
                          labelText: 'Nth Term to Find (n)',
                          keyboardType: TextInputType.number,
                          hintText: 'e.g., 5',
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Initial Conditions (e.g., a(0), a(1)):',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        ..._initialConditions.entries.map((entry) {
                          final indexController = entry.key;
                          final valueController = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomInputField(
                                    controller: indexController,
                                    labelText: 'Index (e.g., a(0))',
                                    keyboardType: TextInputType.text,
                                    hintText: 'e.g., a(0)',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomInputField(
                                    controller: valueController,
                                    labelText: 'Value',
                                    keyboardType: TextInputType.number,
                                    hintText: 'e.g., 0',
                                  ),
                                ),
                                if (_initialConditionCount > 1)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        _removeInitialConditionField(
                                          indexController,
                                        ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: _addInitialConditionField,
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.deepPurple,
                            ),
                            label: const Text('Add Initial Condition'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        provider.isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _calculateRecurrence,
                                child: const Text('Calculate Term'),
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
