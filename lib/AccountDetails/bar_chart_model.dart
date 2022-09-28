import 'package:charts_flutter/flutter.dart' as charts;

class BarChartModel {
  String month;
  String year;
  int financial;
  final charts.Color color;

  BarChartModel({required this.month, required this.year, required this.financial, required this.color,});
}