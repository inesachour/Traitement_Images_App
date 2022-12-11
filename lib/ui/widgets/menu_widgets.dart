
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

mainButton({
  required String title,
  required VoidCallback? onPressed,
  bool enabled = true,
}){
  return Container(
    margin: EdgeInsets.all(10),
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
      child: AutoSizeText(
        title,
        maxFontSize: 16,
        minFontSize: 12,
        style: TextStyle(
          color: enabled ? Colors.blue : Colors.grey,
        ),
      ),
      onPressed: onPressed,

    ),
  );
}

Widget menuBar({
  required double deviceWidth,
  required double deviceHeight,
  required List<VoidCallback> onPressed,
  required bool? imageIsPGM,
}){
  return Container(
    width: deviceWidth,
    height: deviceHeight*0.08,
    color: Colors.blue,
    child: Row(
      children: [

        SizedBox(width: deviceWidth*0.02,),



        menuBarButton(
          deviceHeight: deviceHeight,
          title: "Importer une image",
          icon: Icons.download,
          activated: true,
          onPressed: onPressed[0]
        ),

        SizedBox(width: deviceWidth*0.02,),

        menuBarButton(
          deviceHeight: deviceHeight,
          title: "Exporter une image",
          icon: Icons.upload,
          activated: imageIsPGM != null,
            onPressed: onPressed[1]
        ),

        SizedBox(width: deviceWidth*0.02,),


        menuBarButton(
            deviceHeight: deviceHeight,
            title: "Exporter image bruit",
            icon: Icons.image,
            activated: imageIsPGM != null && imageIsPGM,
            onPressed: onPressed[2]
        ),

        SizedBox(width: deviceWidth*0.02,),

      ],
    ),
  );
}


Widget menuBarButton({
  required double deviceHeight,
  required String title,
  required IconData icon,
  required bool activated,
  required VoidCallback onPressed,
}){
  return Container(
    height: deviceHeight*0.045,
    child: FloatingActionButton.extended(
      label: AutoSizeText(
        title,
        style: TextStyle(
          color: activated ? Colors.blue : Colors.white,
        ),
        maxFontSize: 14,
        minFontSize: 8,
      ),
      backgroundColor: activated ? Colors.white : Colors.grey.shade300,
      icon: Icon(icon, color: activated ? Colors.blue : Colors.white,),
      onPressed: activated ? onPressed : null,
    ),
  );
}


Widget displayOtptions({
  required List<String> labels,
  required List<bool> activated,
  required List<VoidCallback> onPressed,
}){

  List<Widget> btns = [];
  for(int i=0; i<labels.length; i++){
    btns.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          child: Text(labels[i]),
          onPressed: onPressed[i],
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(activated[i] ? Colors.blue : Colors.grey),
          ),
        ),
      ),
    );
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: btns,
  );
}