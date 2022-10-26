
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