import 'package:flutter/material.dart';

class FiltreMedianPopup extends StatefulWidget {
  const FiltreMedianPopup({Key? key}) : super(key: key);

  @override
  State<FiltreMedianPopup> createState() => _FiltreMedianPopupState();
}

class _FiltreMedianPopupState extends State<FiltreMedianPopup> {

  TextEditingController nController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      body: Stack(
        children: [

          Container(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth*0.02, vertical: deviceHeight*0.01),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: deviceWidth*0.06),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: nController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value)%2 == 0 || int.parse(value) < 3) {
                          return 'Entrer un n impair superieur à 1';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "N",
                      ),
                    ),
                  ),

                  SizedBox(
                    height: deviceHeight*0.02,
                  ),

                  CheckboxListTile(
                    title: Text("Masque carré"), //    <-- label
                    value: checkedValue,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (newValue) {
                      setState((){
                        checkedValue = newValue!;
                      });
                    },
                  ),

                  SizedBox(
                    height: deviceHeight*0.02,
                  ),

                  ElevatedButton(
                    onPressed: (){
                      if (_formKey.currentState!.validate()){
                        var x = int.parse(nController.text);
                        Navigator.pop(context,[x,checkedValue]);
                      }
                    },
                    child: Text("Confirmer"),
                  ),
                ],
              ),
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
