import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sequence & Series Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCalculatorCard(
              context,
              title: 'Arithmetic Sequences',
              description:
                  'Calculate nth term and sum of arithmetic sequences.',
              route: '/arithmetic',
              icon: Icons.add_chart,
            ),
            const SizedBox(height: 16),
            _buildCalculatorCard(
              context,
              title: 'Geometric Sequences',
              description:
                  'Calculate nth term and sum of geometric sequences (finite & infinite).',
              route: '/geometric',
              icon: Icons.show_chart,
            ),
            const SizedBox(height: 16),
            _buildCalculatorCard(
              context,
              title: 'Sigma Notation',
              description: 'Parse and calculate sums using sigma notation.',
              route: '/sigma',
              icon: Icons.functions,
            ),
            const SizedBox(height: 16),
            _buildCalculatorCard(
              context,
              title: 'Recurrence Relations',
              description: 'Calculate terms for recurrence relations.',
              route: '/recurrence',
              icon: Icons.loop,
            ),
            // You can add more cards for other functionalities like 'n-th term finder' if it's a standalone feature
            // or integrate it within the existing sequence types.
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorCard(
    BuildContext context, {
    required String title,
    required String description,
    required String route,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.deepPurple),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
