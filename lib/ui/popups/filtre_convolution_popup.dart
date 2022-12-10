import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:traitement_image/core/services/alerts_service.dart';

class FiltreConvolutionPopup extends StatefulWidget {
  const FiltreConvolutionPopup({Key? key}) : super(key: key);

  @override
  State<FiltreConvolutionPopup> createState() => _FiltreConvolutionPopupState();
}

class _FiltreConvolutionPopupState extends State<FiltreConvolutionPopup> {

  final _formKey = GlobalKey<FormState>();
  int n = 3;
  List<List<TextEditingController>> controllers = [];
  AlertsService alertsService = AlertsService();

  @override
  void initState() {
    super.initState();
    for(int i=0;i<n;i++){
      List<TextEditingController> list = [];
      for(int j=0;j<n;j++){
        list.add(TextEditingController());
      }
      controllers.add(list);
    }
  }


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
                  Row(
                    children: [
                      ElevatedButton(
                        child: Icon(Icons.plus_one),
                        onPressed: (){
                          setState((){
                            n+=2;
                            List<List<TextEditingController>> c = [];
                            for(int i=0;i<n;i++){
                              List<TextEditingController> list = [];
                              for(int j=0;j<n;j++){
                                list.add(TextEditingController());
                              }
                              c.add(list);
                            }
                            controllers = c;
                          });
                        },
                      ),
                      ElevatedButton(
                        child: Icon(Icons.exposure_minus_1),
                        onPressed: (){
                          setState((){
                            if(n>3){
                              n-=2;
                              List<List<TextEditingController>> c = [];
                              for(int i=0;i<n;i++){
                                List<TextEditingController> list = [];
                                for(int j=0;j<n;j++){
                                  list.add(TextEditingController());
                                }
                                c.add(list);
                              }
                              controllers = c;
                            }

                          });
                        },
                      ),
                    ],
                  ),


                  SizedBox(
                    height: deviceHeight*0.02,
                  ),


                  Expanded(
                    child: GridView.count(
                      crossAxisCount: n,
                      children: List.generate(n*n, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controllers[(index/n).floor()][index%n],
                            validator: (value) {
                              if (value == null || value.isEmpty || int.tryParse(value) == null) {
                                return 'Entrer une valeur';
                              }
                              return null;
                            },
                          ),
                        );
                      }),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: (){
                      if (_formKey.currentState!.validate()){
                        int x = 0;
                        List<List<int>> vals = [];

                        for(int i=0;i<n;i++){
                          List<int> l = [];
                          for(int j=0;j<n;j++){
                            x += int.parse(controllers[i][j].text);
                            l.add(int.parse(controllers[i][j].text));
                          }
                          vals.add(l);
                        }
                        if(x !=1){
                          alertsService.showAlert(context: context, alert: "La somme doit etre égale à 1", color: Colors.red); //TODO pop show twice
                        }
                        else{
                          Navigator.pop(context,vals);
                        }

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

