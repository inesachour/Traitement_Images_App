
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget imageInfo({
  required String title,
  required double? value,
  required List<double>? values,
  required double deviceWidth,
}){
  return Container(
    padding: EdgeInsets.all(3),
    margin: EdgeInsets.symmetric(horizontal: 4),
    child: Row(
      children: [
        AutoSizeText(
          "$title : ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          maxFontSize: 18,
          minFontSize: 14,
        ),
        if(value != null)
          AutoSizeText(
          value.toStringAsFixed(2) ?? "",
          minFontSize: 14,
          maxFontSize: 16,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: Colors.white
          ),
        ),
        if(values != null)
          Row(
            children: [
              PPMImageInfo(
                color: Colors.red,
                title: "Rouge",
                value: values[0].toStringAsFixed(2),
              ),
              SizedBox(
                width: deviceWidth*0.005,
              ),
              PPMImageInfo(
                color: Colors.green,
                title: "Vert",
                value: values[1].toStringAsFixed(2),
              ),
              SizedBox(
                width: deviceWidth*0.005,
              ),
              PPMImageInfo(
                color: Colors.blue,
                title: "Bleu",
                value: values[2].toStringAsFixed(2),
              ),
            ],
          ),
      ],
    ),
  );
}

Widget footerBar({
  required double deviceHeight,
  required double deviceWidth,
  required double? moyennePGM,
  required List<double>? moyennesPPM,
  required double? ecartTypePGM,
  required List<double>? ecartTypesPPM,
}){
  return Positioned(
    height: deviceHeight > 500? deviceHeight*0.1 : 50,
    child: Container(
      width: deviceWidth,
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      padding: EdgeInsets.all(deviceHeight*0.02),
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageInfo(
              title: "Moyenne",
              value: moyennePGM,
              values: moyennesPPM,
              deviceWidth: deviceWidth
            ),
            SizedBox(width: deviceWidth*0.1,),
            imageInfo(
              title: "Ecart Type",
              value: ecartTypePGM,
              values: ecartTypesPPM,
              deviceWidth: deviceWidth
            ),

          ],
        ),
      ),
    ),
    bottom: 0,
  );
}

Widget PPMImageInfo({
  required Color color,
  required String title,
  required String value,
}){
  return Container(

    padding: EdgeInsets.all(6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: color
    ),
    child: AutoSizeText(
      "$title : $value",
      minFontSize: 14,
      maxFontSize: 16,
      style: TextStyle(
          overflow: TextOverflow.ellipsis,
          color: Colors.white
      ),
    ),
  );
}