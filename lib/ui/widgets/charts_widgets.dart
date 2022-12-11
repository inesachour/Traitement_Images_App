
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget histogramChart({
  required Map<int, dynamic> data,
  required double barWidth,
  required double height,
  required double width,
  required String title,
}){
  return Column(
    children: [
      AutoSizeText(
        title,
        minFontSize: 12,
        maxFontSize: 16,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: width * 6.2,
          height: height,
          margin: const EdgeInsets.all(20),
          child: BarChart(
            BarChartData(
              barGroups: data.entries.map(
                    (data) => BarChartGroupData(
                        x: data.key,
                        barRods: [
                          BarChartRodData(
                            toY: data.value.toDouble(),
                            width: barWidth,
                        borderRadius: BorderRadius.zero,
                      ),
                    ]
                ) ,
              ).toList(),
            ),
          ),
        ),
      ),
    ],
  );
}
