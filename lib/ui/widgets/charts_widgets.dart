
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
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      children: [
        AutoSizeText(
          "$title :",
          minFontSize: 18,
          maxFontSize: 22,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: width,
            height: height,
            margin: EdgeInsets.all(20),
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
    ),
  );
}

Widget histogramPPMChart({
  required List<List<int>> datas,
  required double barWidth,
  required double height,
  required double width,
  required List<String> titles,
}){
  Map<int, dynamic> d0 = datas[0].asMap();
  Map<int, dynamic> d1 = datas[1].asMap();
  Map<int, dynamic> d2 = datas[2].asMap();
  return Container(
    child: Column(
      children: [
        histogramChart(data: d0, barWidth: barWidth, height: height, width: width, title: titles[0]),
        histogramChart(data: d1, barWidth: barWidth, height: height, width: width, title: titles[1]),
        histogramChart(data: d2, barWidth: barWidth, height: height, width: width, title: titles[2]),
      ],
    ),
  );
}

Widget histogramsMenu({
  required List<String> labels
}){

  List<Widget> btns = labels.map((e) => ElevatedButton(onPressed: (){}, child: Text(e))).toList();
  return Row(
    children: btns
  );
}
