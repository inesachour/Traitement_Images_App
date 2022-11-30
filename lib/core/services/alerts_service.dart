
import 'package:flutter/material.dart';

class AlertsService{

  showAlert({required BuildContext context, required String alert, required Color color}){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(alert),
          backgroundColor: color,
        )
    );
  }
}