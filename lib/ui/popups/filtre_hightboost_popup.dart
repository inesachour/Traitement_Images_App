import 'package:flutter/material.dart';
import 'package:traitement_image/core/services/alerts_service.dart';

class FiltreHightBoostPopup extends StatefulWidget {
  const FiltreHightBoostPopup({Key? key}) : super(key: key);

  @override
  State<FiltreHightBoostPopup> createState() => _FiltreHightBoostPopupState();
}

class _FiltreHightBoostPopupState extends State<FiltreHightBoostPopup> {

  final _formKey = GlobalKey<FormState>();
  AlertsService alertsService = AlertsService();
  int? selected;
  TextEditingController nController = TextEditingController();

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

                SizedBox(
                  height: deviceHeight*0.02,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth*0.1),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: nController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value)%2 == 0 || int.parse(value) < 3) {
                        return 'Entrer un n impair supérieur à 1';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "N",
                    ),
                  ),
                ),

                SizedBox(
                  height: deviceHeight*0.005,
                ),

                RadioListTile(
                  title: Text("Filtre Moyenneur"),
                  value: 0,
                  groupValue: selected,
                  onChanged: (value){
                    setState(() {
                      selected = int.parse(value.toString());
                    });
                  },
                ),

                RadioListTile(
                  title: Text("Filtre Median"),
                  value: 1,
                  groupValue: selected,
                  onChanged: (value){
                    setState(() {
                      selected = int.parse(value.toString());
                    });
                  },
                ),

                RadioListTile(
                  title: Text("Filtre Median Carre"),
                  value: 2,
                  groupValue: selected,
                  onChanged: (value){
                    setState(() {
                      selected = int.parse(value.toString());
                    });
                  },
                ),

                SizedBox(
                  height: deviceHeight*0.02,
                ),

                ElevatedButton(
                  child: Text("Confirmer"),
                  onPressed: (){
                    setState((){
                      if(_formKey.currentState?.validate() ?? false){
                        if(selected != null){
                          Navigator.pop(context,[selected!,int.parse(nController.text)]);
                        }
                        else{
                          alertsService.showAlert(context: context, alert: "Choisissez une option et une taille N", color: Colors.red);
                        }
                      }
                    });
                  },
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
