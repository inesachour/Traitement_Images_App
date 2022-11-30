// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:collection';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:traitement_image/core/models/pgm_image.dart';
import 'package:traitement_image/core/services/alerts_service.dart';
import 'package:traitement_image/core/services/images_services.dart';
import 'package:traitement_image/core/models/ppm_image.dart';
import 'package:traitement_image/ui/popups/modify_contrast_popup.dart';
import 'package:traitement_image/ui/widgets/charts_widgets.dart';
import 'package:traitement_image/ui/widgets/general_info_widgets.dart';
import 'package:traitement_image/ui/widgets/menu_buttons.dart';

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

        imagesService.seuillageManuel(image, [10,10,10], 2, "D:\\Users\\Ines\\Desktop\\Traitement D'images\\seuil");


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

    VoidCallback onModifyContrastClick = () async {
      Map<int,int>? value = await showDialog(context: context, builder: (context) => ModifyContractPopup());
      if(value != null){
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Enregister l\'image dans',
          fileName: "modified_contrast",
        );
        if(outputFile != null) {
          contrastedImage = imagesService.modifyContrastPGM(image, value,outputFile);
        }
      }
    };



    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: deviceWidth,
              height: deviceHeight*0.1,
              color: Colors.blue,
              child: Row(
                children: [

                  SizedBox(width: deviceWidth*0.02,),

                  menuDropDownButton(
                    title: "Fichier",
                    deviceWidth: deviceWidth,
                    onChanged: [onReadImageClick, onWriteImageClick],
                    options: ["Lire", "Ecrire"],
                  ),

                  SizedBox(width: deviceWidth*0.02,),

                  menuDropDownButton( //TODO
                    title: "Modification",
                    deviceWidth: deviceWidth,
                    onChanged: image != null && image.runtimeType == PGMImage ? [onModifyContrastClick] : null,
                    options: ["Modifier le contrast", "Filtre Moyenneur", "Filtre Median", "Filtre Convolution", "Filtre High Boost"],
                    enabled: image != null
                  ),

                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                if(image != null && image.runtimeType == PGMImage)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          histogramChart(
                            data: ImagesService().histogrammePGM(image).asMap(),
                            barWidth: 4,
                            width: deviceWidth*0.7,
                            height: deviceWidth*0.2,
                            title: "Histogramme"
                          ),
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


                Container(
                  height: deviceHeight *0.9,
                  width: deviceWidth*0.1,
                  color: Colors.blueGrey,
                  child: Column(
                    children: [
                      imageInfo(
                        title: "Moyenne",
                        value: image != null && image.runtimeType == PGMImage ? ImagesService().moyennePGM(image).toStringAsFixed(2) : null, //TODO NULL IF NO PGM
                      ),

                      imageInfo(
                        title: "Ecart Type",
                        value: image != null && image.runtimeType == PGMImage ? ImagesService().ecartTypePGM(image).toStringAsFixed(2) : null, //TODO NULL IF NO PGM
                      ),

                    ],
                  ),
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }
}
