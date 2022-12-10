// ignore_for_file: prefer_function_declarations_over_variables

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:traitement_image/core/models/pgm_image.dart';
import 'package:traitement_image/core/services/alerts_service.dart';
import 'package:traitement_image/core/services/images_services.dart';
import 'package:traitement_image/core/models/ppm_image.dart';
import 'package:traitement_image/ui/popups/morphology_popup.dart';
import 'package:traitement_image/ui/popups/filtre_convolution_popup.dart';
import 'package:traitement_image/ui/popups/filtre_median_popup.dart';
import 'package:traitement_image/ui/popups/filtre_moyenneur_popup.dart';
import 'package:traitement_image/ui/popups/modify_contrast_popup.dart';
import 'package:traitement_image/ui/popups/seuillage_otsu_popup.dart';
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
  PPMImage? imgSeuille;
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

    VoidCallback onFiltreMoyenneurClick = () async{
      int? n = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              child: FiltreMoyenneurPopup(),
              height: deviceHeight*0.18,
              width: deviceWidth*0.2,
            ),

          );
        },
      );
      if(n!=null){
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Enregister l\'image dans',
          fileName: "moyenneur",
        );

        if(outputFile != null){
          if(image.runtimeType == PGMImage){
            imagesService.filtreMoyenneur(image, n, outputFile);
          }
        }
      }
    };

    VoidCallback onFiltreMedianClick = () async {
      List? l = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              child: FiltreMedianPopup(),
              height: deviceHeight * 0.25,
              width: deviceWidth*0.25,
            ),

          );
        },
      );
      if (l != null) {
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Enregister l\'image dans',
          fileName: "median",
        );

        if (outputFile != null) {
          if (image.runtimeType == PGMImage) {
            imagesService.filtreMedian(image, l[0], l[1],outputFile);
          }
        }
      }
    };

    VoidCallback onFiltreConvolutionClick = () async{
      List<List<int>>? l = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              child: FiltreConvolutionPopup(),
              height: deviceHeight*0.5,
              width: deviceWidth*0.25,
            ),

          );
        },
      );
      if(l!=null){
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Enregister l\'image dans',
          fileName: "convolution",
        );

        if(outputFile != null){
          if(image.runtimeType == PGMImage){
            imagesService.filtreConvolution(image, l, outputFile);
          }
        }
      }
    };

    VoidCallback onModifyContrastClick = () async {
      Map<int,int>? l = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              child: ModifyContrastPopup(),
              height: deviceHeight*0.5,
              width: deviceWidth*0.25,
            ),

          );
        },
      );
      if(l!=null){
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Enregister l\'image dans',
          fileName: "contrast",
        );

        if(outputFile != null){
          if(image.runtimeType == PGMImage){
            imagesService.modifyContrastPGM(image, l, outputFile);
          }
        }
      }
    };

    VoidCallback onSeuillageOtsuClick = () async {
      int? option = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              child: SeuillageOtsuPopup(),
              height: deviceHeight*0.25,
              width: deviceWidth*0.25,
            ),

          );
        },
      );
      if(option!=null){
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Enregister l\'image dans',
          fileName: "otsu",
        );

        if(outputFile != null){
          if(image.runtimeType == PPMImage){
            setState((){
              imgSeuille = imagesService.seuillageOtsu(image, option, outputFile, true);
            });

          }
        }
      }
    };


    VoidCallback onMorphologyClick(String choice){
      return () async {
        int? n = await showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              content: Container(
                child: MorphologyPopup(),
                height: deviceHeight*0.2,
                width: deviceWidth*0.25,
              ),

            );
          },
        );
        if(n!=null){
          String? outputFile = await FilePicker.platform.saveFile(
            dialogTitle: 'Enregister l\'image dans',
            fileName: choice.toLowerCase(),
          );

          if(outputFile != null){
            if(imgSeuille == null)
              imgSeuille = imagesService.seuillageOtsu(image, 0, "",false);
            if(image.runtimeType == PPMImage){
              if(choice.toLowerCase() == "erosion"){
                imagesService.erosion(imgSeuille!, n, outputFile, true);
              }
              else if(choice.toLowerCase() == "dilatation"){
                imagesService.dilatation(imgSeuille!, n, outputFile,true);
              }
              else if(choice.toLowerCase() == "fermeture"){
                imagesService.fermeture(imgSeuille!, n, outputFile);
              }
              else if(choice.toLowerCase() == "ouverture"){
                imagesService.ouverture(imgSeuille!, n, outputFile);
              }

            }
          }
        }
      };
    }



    return SafeArea(
      child: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          children: [

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
                    toolBar(
                      deviceWidth: deviceWidth,
                      deviceHeight: deviceHeight,
                      imageIsPGM: image != null ? ( image.runtimeType == PGMImage ? true : false): null ,
                      onPressedList: [onFiltreMoyenneurClick, onFiltreMedianClick, onFiltreConvolutionClick, onModifyContrastClick, onSeuillageOtsuClick, onMorphologyClick("erosion"),onMorphologyClick("dilatation"),onMorphologyClick("ouverture"),onMorphologyClick("fermeture")],
                      titles: ["Filtre Moyenneur", "Filtre Median", "Convolution", "Modifier contrast", "Seuillage Otsu", "Erosion", "Dilatation", "Ouverture", "Fermeture"]
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

            //Footer Bar
            footerBar(
              deviceHeight: deviceHeight,
              deviceWidth: deviceWidth,
              moyenne: image != null && image.runtimeType == PGMImage ? ImagesService().moyennePGM(image).toStringAsFixed(2) : null,
              ecartType: image != null && image.runtimeType == PGMImage ? ImagesService().ecartTypePGM(image).toStringAsFixed(2) : null,
              show: image != null && image.runtimeType == PGMImage ,
            ),//TODO calcul de moyenne pour ppm
          ],
        ),
      ),
    );
  }
}
