
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget imageInfo({
  required String title,
  required String? value,
}){
  return Container(
    padding: EdgeInsets.all(3),
    margin: EdgeInsets.symmetric(horizontal: 4),
    child: Row(
      children: [
        AutoSizeText(
          "$title :",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          maxFontSize: 18,
          minFontSize: 14,
        ),
        AutoSizeText(
          value ?? "",
          minFontSize: 14,
          maxFontSize: 16,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: Colors.white
          ),
        ),
      ],
    ),
  );
}

Widget footerBar({
  required double deviceHeight,
  required double deviceWidth,
  required String? moyenne,
  required String? ecartType,
  required bool show,
}){
  return Positioned(
    height: deviceHeight > 500? deviceHeight*0.1 : 50,
    child: Container(
      width: deviceWidth,
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      padding: EdgeInsets.all(deviceHeight*0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageInfo(
            title: "Moyenne",
            value: show ? moyenne : null, //TODO NULL IF NO PGM
          ),
          SizedBox(width: deviceWidth*0.1,),
          imageInfo(
            title: "Ecart Type",
            value: show ? ecartType : null, //TODO NULL IF NO PGM
          ),

        ],
      ),
    ),
    bottom: 0,
  );
}