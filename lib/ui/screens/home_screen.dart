// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traitement_image/core/models/pgm_image.dart';
import 'package:traitement_image/core/services/alerts_service.dart';
import 'package:traitement_image/core/services/images_services.dart';
import 'package:traitement_image/core/models/ppm_image.dart';
import 'package:traitement_image/ui/popups/filtre_hightboost_popup.dart';
import 'package:traitement_image/ui/popups/morphology_popup.dart';
import 'package:traitement_image/ui/popups/filtre_convolution_popup.dart';
import 'package:traitement_image/ui/popups/filtre_median_popup.dart';
import 'package:traitement_image/ui/popups/filtre_moyenneur_popup.dart';
import 'package:traitement_image/ui/popups/modify_contrast_popup.dart';
import 'package:traitement_image/ui/popups/seuillage_manuel_popup.dart';
import 'package:traitement_image/ui/popups/seuillage_otsu_popup.dart';
import 'package:traitement_image/ui/widgets/charts_widgets.dart';
import 'package:traitement_image/ui/widgets/footer_widgets.dart';
import 'package:traitement_image/ui/widgets/image_editor.dart';
import 'package:traitement_image/ui/widgets/menu_widgets.dart';
import 'package:traitement_image/ui/widgets/tools_bar_widgets.dart';
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var image;
  PPMImage? imgSeuille;
  PGMImage? contrastedImage;
  PGMImage? filteredImage;
  PGMImage? bruit;
  ImagesService imagesService = ImagesService();
  AlertsService alertsService = AlertsService();
  int toolPanelSelected = 0;
  ui.Image? imageForPaint;
  ui.Image? bruitForPaint;


  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    VoidCallback onReadImageClick = () async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        String extension = await imagesService.imageType(result.files.single.path!);
        if(extension == "ppm"){
          PPMImage img = await imagesService.readPPM(result.files.single.path!);
          image = img;
          bruit = null;
          bruitForPaint = null;
          imageForPaint = await imagesService.displayPPM(image);
        }
        else if(extension == "pgm"){
          image = await imagesService.readPGM(result.files.single.path!);
          bruit = imagesService.bruit(image, "", false);
          imageForPaint = await imagesService.displayPGM(image);
          bruitForPaint = await imagesService.displayPGM(bruit!);
        }
        contrastedImage = null;
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

    VoidCallback onBruitClick = () async {
      if(image != null){
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Enregister l\'image dans',
          fileName: "bruit",
        );
        if(outputFile != null){
          if(image.runtimeType == PGMImage){
            if(bruit == null){
              setState(() {
                bruit = imagesService.bruit(image, outputFile, true);
              });
            }
            else{
              imagesService.writePGM(bruit!, outputFile);
            }
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
            content: SizedBox(
              child: FiltreMoyenneurPopup(),
              height: deviceHeight*0.18,
              width: deviceWidth*0.1,
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
            setState(() {
              filteredImage = imagesService.filtreMoyenneur(bruit!, n, outputFile, true);
            });
          }
        }
      }
    };

    VoidCallback onFiltreMedianClick = () async {
      List? l = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              child: FiltreMedianPopup(),
              height: deviceHeight * 0.25,
              width: deviceWidth*0.2,
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
            setState(() {
              filteredImage = imagesService.filtreMedian(bruit!, l[0], l[1],outputFile, true);

            });
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

    VoidCallback onFiltreHighBoostClick = () async{
      List<int>? l = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              child: FiltreHightBoostPopup(),
              height: deviceHeight*0.4,
              width: deviceWidth*0.25,
            ),

          );
        },
      );
      if(l!=null){
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Enregister l\'image dans',
          fileName: "high-boost",
        );

        if(outputFile != null){
          if(image.runtimeType == PGMImage){
            late PGMImage imageFiltreBas;
            if(l[0] == 0){ //Moyenneur
              imageFiltreBas = imagesService.filtreMoyenneur(image, l[1], outputFile,true);
            }
            else if(l[0] == 1){ //Median
              imageFiltreBas = imagesService.filtreMedian(image, l[1], false,outputFile,true);
            }
            else{ //Median carre
              imageFiltreBas = imagesService.filtreMedian(image, l[1], true,outputFile,true);
            }
            imagesService.filtreHighBoost(image, imageFiltreBas, outputFile);
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
              width: deviceWidth*0.2,
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

            setState(() {
              contrastedImage = imagesService.modifyContrastPGM(image, l, outputFile);
            });
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
              width: deviceWidth*0.2,
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

    VoidCallback onSeuillageManuelClick = () async {
      List? res = await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              child: SeuillageManuelPopup(),
              height: deviceHeight*0.35,
              width: deviceWidth*0.25,
            ),

          );
        },
      );
      if(res!=null){
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Enregister l\'image dans',
          fileName: "manuel",
        );

        if(outputFile != null){
          if(image.runtimeType == PPMImage){
            setState((){
              imgSeuille = imagesService.seuillageManuel(image, res[0], res[1], outputFile, true);
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
                height: deviceHeight*0.18,
                width: deviceWidth*0.18,
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
            imgSeuille ??= imagesService.seuillageOtsu(image, 0, "",false);
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
        body: Column(
          //clipBehavior: Clip.none,
          children: [

            Expanded(flex: 10,child:Column(
              children: [
                //Menu
                Expanded(
                  flex: 1,
                  child: menuBar(
                    deviceWidth: deviceWidth,
                    deviceHeight: deviceHeight,
                    onPressed: [onReadImageClick, onWriteImageClick, onBruitClick],
                    imageIsPGM: image != null ? (image.runtimeType == PGMImage ? true : false) : null,
                  ),
                ),


                //Screen
                Expanded(
                  flex: 8,
                  child: Row(
                    children: [

                      Expanded(
                        flex: 1,
                        child: toolBar(
                            deviceWidth: deviceWidth,
                            deviceHeight: deviceHeight,
                            imageIsPGM: image != null ? ( image.runtimeType == PGMImage ? true : false): null ,
                            onPressedList: [onFiltreMoyenneurClick, onFiltreMedianClick, onFiltreConvolutionClick, onFiltreHighBoostClick, onModifyContrastClick, onSeuillageOtsuClick, onSeuillageManuelClick, onMorphologyClick("erosion"),onMorphologyClick("dilatation"),onMorphologyClick("ouverture"),onMorphologyClick("fermeture")],
                            titles: ["Filtre Moyenneur", "Filtre Median", "Convolution", "Filtre High-Boost", "Modifier contrast", "Seuillage Otsu","Seuillage Manuel", "Erosion", "Dilatation", "Ouverture", "Fermeture"]
                        ),
                      ),


                    //Graphs
                        Expanded(
                          flex: 5,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                SizedBox(height: deviceHeight*0.05,),

                                if(image != null)
                                  Row(
                                    mainAxisAlignment : MainAxisAlignment.center,
                                    children: [
                                      if(imageForPaint != null)
                                      SizedBox(
                                        height : imageForPaint!.height.toDouble(),
                                        width: imageForPaint!.width.toDouble(),
                                        child: CustomPaint(
                                          isComplex:true,
                                          foregroundPainter: ImageEditor(image: imageForPaint!),
                                        ),
                                      ),

                                      SizedBox(
                                        width: deviceWidth*0.1,
                                      ),

                                      if(bruitForPaint != null)
                                      SizedBox(
                                        height : imageForPaint!.height.toDouble(),
                                        width: imageForPaint!.width.toDouble(),
                                        child: CustomPaint(
                                          isComplex:true,
                                          foregroundPainter: ImageEditor(image: bruitForPaint!),
                                        ),
                                      ),
                                    ],
                                  ),

                                SizedBox(height: deviceHeight*0.02,),

                                //PGM
                                if(image != null && image.runtimeType == PGMImage)
                                  histogramChart(
                                    data: imagesService.histogrammePGM(image).asMap(),
                                    barWidth: 10,
                                    width: image.lx*image.ly > 200 ? image.lx*image.ly*deviceWidth*0.000055 : deviceWidth*0.8,
                                    height: deviceWidth*0.25,
                                    title: "Histogramme",
                                  ),

                                if(image != null && image.runtimeType == PGMImage)
                                  histogramChart(
                                    data: ImagesService().histogrammeCumulePGM(image).asMap(),
                                    barWidth: 4,
                                    width: image.lx*image.ly > 200 ? image.lx*image.ly*deviceWidth*0.000055 : deviceWidth*0.8,
                                    height: deviceWidth*0.4,
                                    title: "Histogramme Cumulé",
                                  ),

                                if(image != null && image.runtimeType == PGMImage)
                                  histogramChart(
                                    data: ImagesService().histogrammeEgalisePGM(image).asMap(),
                                    barWidth: 4,
                                    width: image.lx*image.ly > 200 ? image.lx*image.ly*deviceWidth*0.000055 : deviceWidth*0.8,
                                    height: deviceWidth*0.4,
                                    title: "Histogramme Egalisé",
                                  ),

                                if(contrastedImage != null)
                                  histogramChart(
                                    data: ImagesService().histogrammePGM(contrastedImage!).asMap(),
                                    barWidth: 4,
                                    width: image.lx*image.ly > 200 ? image.lx*image.ly*deviceWidth*0.000055 : deviceWidth*0.8,
                                    height: deviceWidth*0.2,
                                    title: "Histogramme Apres modification de Contrast",
                                  ),


                              //PPM
                              if(image != null && image.runtimeType == PPMImage)
                                histogramPPMChart(
                                    datas: imagesService.histogrammePPM(image),
                                    barWidth: 10,
                                    width: image.lx*image.ly > 200 ? image.lx*image.ly*deviceWidth*0.000055 : deviceWidth*0.8,
                                    height: deviceWidth*0.25,
                                    titles: [ "Histogramme Rouge", "Histogramme Vert", "Histogramme Bleu"]
                                ),

                                if(image != null && image.runtimeType == PPMImage)
                                  histogramPPMChart(
                                      datas: imagesService.histogrammeCumulePPM(image),
                                      barWidth: 10,
                                      width: image.lx*image.ly > 200 ? image.lx*image.ly*deviceWidth*0.000055 : deviceWidth*0.8,
                                      height: deviceWidth*0.25,
                                      titles: [ "Histogramme Cumulé Rouge", "Histogramme Cumulé Vert", "Histogramme Cumulé Bleu"]
                                  ),

                                if(image != null && image.runtimeType == PPMImage)
                                  histogramPPMChart(
                                      datas: imagesService.histogrammeEgalisePPM(image),
                                      barWidth: 10,
                                      width: image.lx*image.ly > 200 ? image.lx*image.ly*deviceWidth*0.000055 : deviceWidth*0.8,
                                      height: deviceWidth*0.25,
                                      titles: [ "Histogramme Egalisé Rouge", "Histogramme Egalisé Vert", "Histogramme Egalisé Bleu"]
                                  ),

                                SizedBox(height: deviceHeight*0.02,)

                            ],
                          ),
                        ),
                      ),
                  ],
                ), )



              ],
            ), ),

            //Footer Bar
            Expanded(
              flex: 1,
              child: footerBar(
                deviceHeight: deviceHeight,
                deviceWidth: deviceWidth,
                moyennePGM: image != null && image.runtimeType == PGMImage ? imagesService.moyennePGM(image) : null,
                moyennesPPM: image != null && image.runtimeType == PPMImage ? imagesService.moyennePPM(image) : null,
                ecartTypePGM: image != null && image.runtimeType == PGMImage ? imagesService.ecartTypePGM(image) : null,
                ecartTypesPPM: image != null && image.runtimeType == PPMImage ? imagesService.ecartTypePPM(image) : null,
                imageIsPGM: image != null && image.runtimeType == PGMImage,
                signalBruit: (image!= null && image.runtimeType == PGMImage && filteredImage!=null) ? imagesService.signalBruit(image, filteredImage!) : null
              ),
            ),

          ],
        ),
      ),
    );
  }
}
