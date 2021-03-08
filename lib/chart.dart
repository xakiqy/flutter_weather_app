import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_app/model/current_weather.dart';

class TodayChartTemperature extends StatefulWidget {
  final List<Hourly> hourly;

  TodayChartTemperature({Key? key, required this.hourly}) : super(key: key);

  @override
  _TodayChartTemperatureState createState() => _TodayChartTemperatureState();
}

class _TodayChartTemperatureState extends State<TodayChartTemperature> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    MinMaxModel yAxis = generalChartData(widget.hourly);
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                color: Color(0x3168A8)),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 28, bottom: 12),
              child: LineChart(
                mainData(yAxis),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(MinMaxModel yAxis) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff486d92),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff608bac),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xffecba40),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          getTitles: (value) {
            if (value.toInt().isOdd) {
              return DateTime.fromMillisecondsSinceEpoch(
                      widget.hourly[value.toInt()].dt!.toInt() * 1000)
                  .hour
                  .toString();
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xffecba40),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            if (value.toInt().isOdd) {
              return value.ceil().toString() + "°";
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 23,
      minY: yAxis.min! - 3,
      maxY: yAxis.max,
      lineBarsData: [
        LineChartBarData(
          spots: getSpots(widget.hourly),
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  List<FlSpot> getSpots(List<Hourly> hourly) {
    var listSpots = <FlSpot>[];
    for (int i = 0; i < hourly.length; i++) {
      listSpots.add(FlSpot(i.toDouble(), hourly[i].temp!));
    }
    return listSpots;
  }

  MinMaxModel generalChartData(List<Hourly> hourly) {
    var listHourly = List.of(hourly);
    listHourly.sort((a, b) => a.temp!.compareTo(b.temp!));
    return MinMaxModel(min: listHourly.first.temp, max: listHourly.last.temp);
  }
}
