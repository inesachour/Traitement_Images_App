import 'package:flutter/material.dart';

class FiltreMoyenneurPopup extends StatefulWidget {
  const FiltreMoyenneurPopup({Key? key}) : super(key: key);

  @override
  State<FiltreMoyenneurPopup> createState() => _FiltreMoyenneurPopupState();
}

class _FiltreMoyenneurPopupState extends State<FiltreMoyenneurPopup> {

  TextEditingController nController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [

          Container(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth*0.04, vertical: deviceHeight*0.01),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
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

                  SizedBox(
                    height: deviceHeight*0.02,
                  ),

                  ElevatedButton(
                    onPressed: (){
                      if (_formKey.currentState!.validate()){
                        var x = int.parse(nController.text);
                        Navigator.pop(context,x);
                      }
                    },
                    child: Text("Générer"),
                  ),
                ],
              ),
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
