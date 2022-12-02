import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:traitement_image/core/services/alerts_service.dart';

class ModifyContract extends StatefulWidget {
  Function onModifyContrast;

  ModifyContract({Key? key, required this.onModifyContrast}) : super(key: key);

  @override
  State<ModifyContract> createState() => _ModifyContractState();
}

class _ModifyContractState extends State<ModifyContract> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int pointsNumber = 1;
  Map<TextEditingController,TextEditingController> controllers = {TextEditingController() : TextEditingController()};
  AlertsService alertsService = AlertsService();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: deviceWidth*0.3,
      child: Form(
        key: formKey,
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
                      if(formKey.currentState?.validate() ?? false){
                        Map<int,int> points = {};
                        controllers.forEach((key, value) {
                          points.addAll({int.parse(key.text) : int.parse(value.text)});
                        });
                        if(points.isEmpty){
                          alertsService.showAlert(context: context, alert: "Aucun point entré", color: Colors.red);
                        }
                        else{
                          widget.onModifyContrast(points);
                        }
                      }
                    });
                  },
                ),
              ],
            ),


            SizedBox(height: deviceHeight *0.03,),

            SizedBox(
              height: deviceHeight*0.5,
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


Widget toolBarOption({
  required VoidCallback onPressed,
  required String title,
  required bool selected
}){
  return Expanded(
      flex: 1,
      child: TextButton(
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.black: Colors.white,
          ),
        ),
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(selected ? Colors.white: Colors.grey),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.zero))
        ),
      ),
  );
}

Widget toolBar({
  required double deviceWidth,
  required Function onOptionSelected,
  required int selected,
}){
  return Row(
    children: [
      toolBarOption(
        onPressed: (){
          onOptionSelected(1);
        },
        title: "Contrast",
        selected: selected == 1,
      ),

      toolBarOption(
        onPressed: (){
          onOptionSelected(2);
        },
        title: "Filtres",
        selected: selected == 2,
      ),
    ],
  );
}


class ImageFilters extends StatefulWidget {
  const ImageFilters({Key? key}) : super(key: key);

  @override
  State<ImageFilters> createState() => _ImageFiltersState();
}

class _ImageFiltersState extends State<ImageFilters> {
  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Text("Filtre Moyenneur"),
      collapsed: Text(""),
      expanded: TextFormField(
        keyboardType: TextInputType.number,
        validator: (value){
          if(value != null){
            int? v = int.tryParse(value);
            if(v != null){
              if(v%2 ==1) return null;
            }
          }
          return "maha2ah";

        },
      ),
    );
  }
}
