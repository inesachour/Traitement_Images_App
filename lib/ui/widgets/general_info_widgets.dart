
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

imageInfo({
  required String title,
  required String? value,
}){
  return Column(
    children: [
      AutoSizeText(
        "$title :",
        style: TextStyle(color: Colors.white),
        maxFontSize: 16,
        minFontSize: 12,
      ),
      AutoSizeText(
        value ?? "",
        minFontSize: 14,
        maxFontSize: 16,
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}