
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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

Widget menuDropDownButton({
  required String title,
  required List<VoidCallback>? onChanged,
  required List<String> options,
  bool enabled = true,
  required double deviceWidth
}){
  int i =0;
  return  DropdownButtonHideUnderline(
    child: DropdownButton2(
      customButton: AutoSizeText(
        title,
        style: TextStyle(
          color: enabled ? Colors.white : Colors.grey,
        ),
        minFontSize: 16,
        maxFontSize: 18,
      ),
      items: onChanged != null ? options.map((e) {
        return DropdownMenuItem(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e),
              if(i != options.length-1) Divider()
          ],
        ), value: i++,);
      }).toList() : null,
      onChanged: (int? val){
        if(onChanged != null && val != null) onChanged[val]();
      },
      dropdownWidth: deviceWidth * 0.15,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      dropdownElevation: 8,
      itemHeight: deviceWidth*0.03,
      buttonDecoration: BoxDecoration(
        color: Colors.red,
      )
    ),
  );
}