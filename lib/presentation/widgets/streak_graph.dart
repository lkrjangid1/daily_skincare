import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StreakGraph extends StatefulWidget {
  const StreakGraph({super.key, required this.spots});
  final List<FlSpot> spots;

  @override
  State<StreakGraph> createState() => _StreakGraphState();
}

class _StreakGraphState extends State<StreakGraph> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        height: 270,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(
              show: false,
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: bottomTitleWidgets,
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            minX: 1,
            maxX: 30,
            minY: 0,
            maxY: 5,
            lineTouchData: const LineTouchData(
              enabled: false,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: widget.spots,
                isCurved: true,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(
                  show: false,
                ),
                color: const Color(0xff964F66),
                belowBarData: BarAreaData(
                  show: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Color(0xff964F66),
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('1D', style: style);
        break;
      case 10:
        text = const Text('10D', style: style);
        break;
      case 20:
        text = const Text('20D', style: style);
        break;
      case 30:
        text = const Text('30D', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}
