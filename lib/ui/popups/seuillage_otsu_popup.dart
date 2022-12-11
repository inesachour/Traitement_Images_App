import 'package:flutter/material.dart';
import 'package:traitement_image/core/services/alerts_service.dart';

class SeuillageOtsuPopup extends StatefulWidget {
  const SeuillageOtsuPopup({Key? key}) : super(key: key);

  @override
  State<SeuillageOtsuPopup> createState() => _SeuillageOtsuPopupState();
}

class _SeuillageOtsuPopupState extends State<SeuillageOtsuPopup> {

  final _formKey = GlobalKey<FormState>();
  AlertsService alertsService = AlertsService();
  int? selected;

  @override
  Widget build(BuildContext context) {

    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [

                SizedBox(
                  height: deviceHeight*0.01,
                ),

                RadioListTile(
                  title: Text("Indépendant"),
                  value: 0,
                  groupValue: selected,
                  onChanged: (value){
                    setState(() {
                      selected = int.parse(value.toString());
                    });
                  },
                ),

                RadioListTile(
                  title: Text("ET"),
                  value: 1,
                  groupValue: selected,
                  onChanged: (value){
                    setState(() {
                      selected = int.parse(value.toString());
                    });
                  },
                ),

                RadioListTile(
                  title: Text("OU"),
                  value: 2,
                  groupValue: selected,
                  onChanged: (value){
                    setState(() {
                      selected = int.parse(value.toString());
                    });
                  },
                ),

                ElevatedButton(
                  child: Text("Confirmer"),
                  onPressed: (){
                    setState((){
                      if(_formKey.currentState?.validate() ?? false){
                        if(selected != null){
                          Navigator.pop(context,selected);
                        }
                        else{
                          alertsService.showAlert(context: context, alert: "Choisissez une option", color: Colors.red);
                        }
                      }
                    });
                  },
                ),
                SizedBox(
                  height: deviceHeight*0.01,
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.red,),
              onPressed: (){Navigator.pop(context, null);},
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
