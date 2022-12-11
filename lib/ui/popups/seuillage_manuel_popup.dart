import 'package:flutter/material.dart';
import 'package:traitement_image/core/services/alerts_service.dart';

class SeuillageManuelPopup extends StatefulWidget {
  const SeuillageManuelPopup({Key? key}) : super(key: key);

  @override
  State<SeuillageManuelPopup> createState() => _SeuillageManuelPopupState();
}

class _SeuillageManuelPopupState extends State<SeuillageManuelPopup> {

  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> controllers = [TextEditingController(),TextEditingController(),TextEditingController()];
  AlertsService alertsService = AlertsService();
  int? selected;

  @override
  Widget build(BuildContext context) {

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: deviceHeight*0.01,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth*0.04),
                  child: Row(
                    children: [
                      SizedBox(width: deviceWidth*0.01,),

                      Expanded(
                        child: TextFormField(
                          controller: controllers[0],
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) < 1 || int.parse(value) > 255) {
                              return 'Entrer une valeur valide';
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(width: deviceWidth*0.015,),

                      Expanded(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: controllers[1],
                          validator: (value) {
                            if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) < 1 || int.parse(value) > 255) {
                              return 'Entrer une valeur valide';
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(width: deviceWidth*0.015,),

                      Expanded(
                        child: TextFormField(
                          controller: controllers[2],
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) < 1 || int.parse(value) > 255) {
                              return 'Entrer une valeur valide';
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(width: deviceWidth*0.01,),

                    ],
                  ),
                ),

                SizedBox(height: deviceHeight*0.01,),

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

                SizedBox(height: deviceHeight*0.01,),

                ElevatedButton(
                  child: Text("Confirmer"),
                  onPressed: (){
                    setState((){
                      if(_formKey.currentState?.validate() ?? false){
                        if(selected != null){
                          List<int> seuils = [
                            int.parse(controllers[0].text),
                            int.parse(controllers[1].text),
                            int.parse(controllers[2].text),
                          ];
                          Navigator.pop(context,[seuils, selected]);
                        }
                        else{
                          alertsService.showAlert(context: context, alert: "Choisissez une option", color: Colors.red);
                        }
                      }
                    });
                  },
                ),
                SizedBox(height: deviceHeight*0.01,),
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
