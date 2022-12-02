// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:traitement_image/core/models/pgm_image.dart';
import 'package:traitement_image/core/services/alerts_service.dart';
import 'package:traitement_image/core/services/images_services.dart';
import 'package:traitement_image/core/models/ppm_image.dart';
import 'package:traitement_image/ui/widgets/charts_widgets.dart';
import 'package:traitement_image/ui/widgets/footer_widgets.dart';
import 'package:traitement_image/ui/widgets/menu_widgets.dart';
import 'package:traitement_image/ui/widgets/tools_bar_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var image;
  PGMImage? contrastedImage = null;
  ImagesService imagesService = ImagesService();
  AlertsService alertsService = AlertsService();
  int toolPanelSelected = 0;

  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    VoidCallback onReadImageClick = () async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        String extension = await imagesService.imageType(result.files.single.path!);
        if(extension == "ppm"){
          PPMImage img = await  imagesService.readPPM(result.files.single.path!);
          image = img;
        }
        else if(extension == "pgm"){
          image = await imagesService.readPGM(result.files.single.path!);
        }
        setState((){});

        //PGMImage bruit = ImagesService().bruit(image, "D:\\Users\\Ines\\Desktop\\Traitement D'images\\bruit");
        //var i = imagesService.filtreMedian(bruit,3,false,"D:\\Users\\Ines\\Desktop\\Traitement D'images\\f_med");
        //var j = imagesService.filtreMoyenneur(bruit,3,"D:\\Users\\Ines\\Desktop\\Traitement D'images\\f_moy");
        //print(imagesService.signalBruit(image, i));
        //print(imagesService.signalBruit(image, j));
        //imagesService.filtreConvolution(image,[[-1,-1,-1],[-1,9,-1],[-1,-1,-1]],"D:\\Users\\Ines\\Desktop\\Traitement D'images\\f-passe_haut");

        //imagesService.filtreHighBoost(image, j, "D:\\Users\\Ines\\Desktop\\Traitement D'images\\f_highboost");

        //imagesService.seuillageManuel(image, [10,10,10], 2, "D:\\Users\\Ines\\Desktop\\Traitement D'images\\seuil");


      }
    };

    VoidCallback onWriteImageClick = () async {
      if(image != null){
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Enregister l\'image dans',
          fileName: "export",
        );
        if(outputFile != null){
          if(image.runtimeType == PPMImage){
            imagesService.writePPM(image, outputFile);
          }
          else if(image.runtimeType == PGMImage){
            imagesService.writePGM(image, outputFile);
          }
        }
      }
      else{
        alertsService.showAlert(context: context, alert: "Aucune Image trouvée!", color: Colors.red);
      }
      


    };

    Function onModifyContrastClick = (Map<int,int> points) async {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Enregister l\'image dans',
        fileName: "modified_contrast",
      );
      if(outputFile != null) {
        contrastedImage = imagesService.modifyContrastPGM(image, points,outputFile);
      }
    };

    Function onOptionSelected = (int i) {
      setState((){
        if(toolPanelSelected == i){
          toolPanelSelected = 0;
        }
        else{
          toolPanelSelected = i;
        }
      });
    };


    return SafeArea(
      child: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          children: [

            //Footer Bar
            footerBar(
              deviceHeight: deviceHeight,
              deviceWidth: deviceWidth,
              moyenne: image != null ? ImagesService().moyennePGM(image).toStringAsFixed(2) : null,
              ecartType: image != null ? ImagesService().ecartTypePGM(image).toStringAsFixed(2) : null,
              show: image != null && image.runtimeType == PGMImage ,
            ),

            Column(
              children: [

                //Menu
                menuBar(
                  deviceWidth: deviceWidth,
                  deviceHeight: deviceHeight,
                  onChanged: [[onReadImageClick, onWriteImageClick]],
                  options : [["Lire une image", "Ecrire une image"]],
                ),

                //Screen
                Row(
                  children: [
                    Container(
                      width: deviceWidth*0.2,
                      child: Column(
                        children: [

                          toolBar(
                            deviceWidth: deviceWidth,
                            onOptionSelected:
                            onOptionSelected, selected: toolPanelSelected,
                          ),

                          if(toolPanelSelected == 1)
                            ModifyContract(onModifyContrast: onModifyContrastClick),
                          if(toolPanelSelected == 2)
                            ImageFilters()

                        ],
                      ),
                    ),

                    //Graphs
                    if(image != null && image.runtimeType == PGMImage)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [

                              /*histogramChart(
                              data: ImagesService().histogrammePGM(image).asMap(),
                              barWidth: 4,
                              width: deviceWidth*0.7,
                              height: deviceWidth*0.2,
                              title: "Histogramme"
                          ),*/
                              //if(contrastedImage != null)
                              /*histogramChart(
                                  data: ImagesService().histogrammePGM(contrastedImage!).asMap(),
                                  barWidth: 4,
                                  width: deviceWidth*0.7,
                                  height: deviceWidth*0.2,
                                  title: "Histogramme Apres modification de Contrast"
                              ),*/

                              /*histogramChart(
                                  data: ImagesService().histogrammeCumulePGM(image).asMap(),
                                  barWidth: 4,
                                  width: deviceWidth,
                                  height: deviceWidth*0.4,
                                  title: "Histogramme Cumulé"
                              ),*/

                              /*histogramChart(
                                  data: ImagesService().histogrammeEgalisePGM(image).asMap(),
                                  barWidth: 4,
                                  width: deviceWidth,
                                  height: deviceWidth*0.4,
                                  title: "Histogramme Egalisé"
                              ),*/
                            ],
                          ),
                        ),
                      ),
                  ],
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }
}
