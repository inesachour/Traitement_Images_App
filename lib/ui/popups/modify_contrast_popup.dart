import 'package:flutter/material.dart';
import 'package:traitement_image/core/services/alerts_service.dart';

class ModifyContrastPopup extends StatefulWidget {
  const ModifyContrastPopup({Key? key}) : super(key: key);

  @override
  State<ModifyContrastPopup> createState() => _ModifyContrastPopupState();
}

class _ModifyContrastPopupState extends State<ModifyContrastPopup> {

  final _formKey = GlobalKey<FormState>();
  int pointsNumber = 1;
  Map<TextEditingController,TextEditingController> controllers = {TextEditingController() : TextEditingController()};
  AlertsService alertsService = AlertsService();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      child: Icon(Icons.add),
                      onPressed: (){
                        setState((){
                          pointsNumber++;
                          controllers.addAll({TextEditingController() : TextEditingController()});
                        });
                      },
                    ),
                    ElevatedButton(
                      child: Text("Confirmer"),
                      onPressed: (){
                        setState((){
                          if(_formKey.currentState?.validate() ?? false){
                            Map<int,int> points = {};
                            controllers.forEach((key, value) {
                              points.addAll({int.parse(key.text) : int.parse(value.text)});
                            });
                            if(points.isEmpty){
                              alertsService.showAlert(context: context, alert: "Aucun point entré", color: Colors.red);
                            }
                            else{
                              Navigator.pop(context,points);
                            }
                          }
                        });
                      },
                    ),
                  ],
                ),


                SizedBox(height: deviceHeight *0.03,),

                SizedBox(
                  height: deviceHeight*0.4,
                  width: deviceWidth*0.3,
                  child: ListView.builder(
                    itemCount: pointsNumber,
                    itemBuilder: (context, index){
                      return PointInput(
                        firstController: controllers.keys.elementAt(index),
                        secondController: controllers.values.elementAt(index),
                        onDelete: (){
                          setState((){
                            pointsNumber--;
                            controllers.remove(controllers.keys.elementAt(index));
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: Icon(Icons.close),
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


Widget PointInput({
  required TextEditingController firstController,
  required TextEditingController secondController,
  required VoidCallback onDelete,
}){
  return Row(
    children: [
      Expanded(
        child: TextFormField(
          validator: (value){
            if(value != null && int.tryParse(value) != null)
              return null;
            else
              return "Entrer un entier";
          },
          controller: firstController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "X",
            border: OutlineInputBorder(
            ),
          ),
        ),
      ),
      SizedBox(width: 10,),
      Expanded(
        child: TextFormField(
          validator: (value){
            if(value != null && int.tryParse(value) != null)
              return null;
            else
              return "Entrer un entier";
          },
          controller: secondController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "Y",
            border: OutlineInputBorder(
            ),
          ),
        ),
      ),

      IconButton(
        icon: Icon(Icons.close, color: Colors.red,),
        onPressed: onDelete,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    ],
  );
}
