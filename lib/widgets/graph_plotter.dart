import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphPlotter extends StatelessWidget {
  final String title;
  final List<double> points;

  const GraphPlotter({super.key, required this.title, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const SizedBox.shrink(); // Don't show if no points
    }

    // Determine max Y value for scaling
    double maxY = points.reduce((curr, next) => curr > next ? curr : next);
    double minY = points.reduce((curr, next) => curr < next ? curr : next);
    if (maxY == minY) {
      // Avoid division by zero or flat line issues
      maxY += 1;
      minY -= 1;
    }
    if (maxY == 0 && minY == 0) {
      // Handle all zeros case
      maxY = 1;
      minY = -1;
    }

    List<FlSpot> flSpots = points
        .asMap()
        .entries
        .map(
          (entry) => FlSpot(entry.key.toDouble() + 1, entry.value),
        ) // X-axis starts from 1 (term number)
        .toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.5,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        interval: 1, // Show every term number
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: const Color(0xff37434d),
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: points.length.toDouble() + 1,
                  // Extend X-axis slightly
                  minY: minY - (maxY - minY) * 0.1,
                  // Add some padding
                  maxY: maxY + (maxY - minY) * 0.1,
                  // Add some padding
                  lineBarsData: [
                    LineChartBarData(
                      spots: flSpots,
                      isCurved: false,
                      // For sequences, usually straight lines between points
                      color: Colors.deepPurple,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  lineTouchData: const LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      // tooltipBgColor: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
