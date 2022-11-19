import 'package:flutter/material.dart';

class ModifyContractPopup extends StatefulWidget {
  const ModifyContractPopup({Key? key}) : super(key: key);

  @override
  State<ModifyContractPopup> createState() => _ModifyContractPopupState();
}

class _ModifyContractPopupState extends State<ModifyContractPopup> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int pointsNumber = 1;
  Map<TextEditingController,TextEditingController> controllers = {TextEditingController() : TextEditingController()};

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      content: SizedBox(
        width: deviceWidth*0.3,
        height: deviceHeight*0.8,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -deviceHeight*0.05,
              right: 0,
              child: ElevatedButton(
                child: Icon(Icons.close),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(CircleBorder()),
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  padding: MaterialStateProperty.all(EdgeInsets.all(15))
                ),
                onPressed: (){
                  Navigator.pop(context, null);
                },
              ),
            ),
            Form(
              key: formKey,
              child: Column(
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

                  SizedBox(height: deviceHeight *0.03,),

                  SizedBox(
                    height: deviceHeight*0.65,
                    width: deviceWidth*0.3,
                    child: ListView.builder(
                      itemCount: pointsNumber,
                      itemBuilder: (context, index){
                        return PointInput(
                          firstController: controllers.keys.elementAt(index),
                          secondController: controllers.values.elementAt(index)
                        );
                      },
                    ),
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
                          Navigator.pop(context,points);
                        }
                      });
                    },
                  ),
                ],
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
    ],
  );
}