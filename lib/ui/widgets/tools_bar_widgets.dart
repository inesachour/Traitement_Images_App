import 'package:flutter/material.dart';

Widget toolBarButton({
  required VoidCallback onPressed,
  required String title,
  required double deviceWidth,
  required bool activated
}){
  return Container(
    width: deviceWidth*0.14,
    child: ElevatedButton(
      child: Text(
        title,
      ),
      onPressed: activated ? onPressed : null,
    ),
  );
}


Widget toolBar({
  required double deviceWidth,
  required double deviceHeight,
  required List<VoidCallback> onPressedList,
  required List<String> titles,
  required bool? imageIsPGM,
}){
  return Container(
    width: deviceWidth*0.15,
    height: deviceHeight*0.9,
    color: Colors.grey.shade200,
    child: Column(
      children: [

        ///Filtres
        Divider(),
        Container(
          width: deviceWidth,
          child: Text("Filtres", textAlign: TextAlign.center,),
        ),
        SizedBox(height: deviceHeight*0.01,),
        toolBarButton(
          onPressed: onPressedList[0],
          title: titles[0],
          deviceWidth: deviceWidth,
          activated: imageIsPGM != null && imageIsPGM,
        ),
        SizedBox(height: deviceHeight*0.01,),
        toolBarButton(
          onPressed: onPressedList[1],
          title: titles[1],
          deviceWidth: deviceWidth,
          activated: imageIsPGM != null && imageIsPGM,
        ),
        SizedBox(height: deviceHeight*0.01,),
        toolBarButton(
          onPressed: onPressedList[2],
          title: titles[2],
          deviceWidth: deviceWidth,
          activated: imageIsPGM != null && imageIsPGM,
        ),
        SizedBox(height: deviceHeight*0.01,),
        toolBarButton(
          onPressed: onPressedList[3],
          title: titles[3],
          deviceWidth: deviceWidth,
          activated: imageIsPGM != null && imageIsPGM,
        ),
        SizedBox(height: deviceHeight*0.01,),
        Divider(),

        ///Contrast
        Container(
          width: deviceWidth,
          child: Text("Contrast", textAlign: TextAlign.center,),
        ),
        SizedBox(height: deviceHeight*0.01,),
        toolBarButton(
          onPressed: onPressedList[4],
          title: titles[4],
          deviceWidth: deviceWidth,
          activated: imageIsPGM != null && imageIsPGM,
        ),
        SizedBox(height: deviceHeight*0.01,),
        Divider(),

        ///Seuillage
        Container(
          width: deviceWidth,
          child: Text("Seuillage", textAlign: TextAlign.center,),
        ),
        SizedBox(height: deviceHeight*0.01,),
        toolBarButton(
          onPressed: onPressedList[5],
          title: titles[5],
          deviceWidth: deviceWidth,
          activated: imageIsPGM != null && !imageIsPGM,
        ),
        SizedBox(height: deviceHeight*0.01,),
        toolBarButton(
          onPressed: onPressedList[6],
          title: titles[6],
          deviceWidth: deviceWidth,
          activated: imageIsPGM != null && !imageIsPGM,
        ),
        SizedBox(height: deviceHeight*0.01,),
        toolBarButton(
          onPressed: onPressedList[7],
          title: titles[7],
          deviceWidth: deviceWidth,
          activated: imageIsPGM != null && !imageIsPGM,
        ),
        SizedBox(height: deviceHeight*0.01,),
        toolBarButton(
          onPressed: onPressedList[8],
          title: titles[8],
          deviceWidth: deviceWidth,
          activated: imageIsPGM != null && !imageIsPGM,
        ),
        SizedBox(height: deviceHeight*0.01,),
        toolBarButton(
          onPressed: onPressedList[9],
          title: titles[9],
          deviceWidth: deviceWidth,
          activated: imageIsPGM != null && !imageIsPGM,
        ),
        SizedBox(height: deviceHeight*0.01,),
        toolBarButton(
          onPressed: onPressedList[10],
          title: titles[10],
          deviceWidth: deviceWidth,
          activated: imageIsPGM != null && !imageIsPGM,
        ),
      ],
    ),
  );
}
