// ignore_for_file: prefer_function_declarations_over_variables

import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:ui';

import 'package:bitmap/bitmap.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traitement_image/core/models/pgm_image.dart';
import 'package:traitement_image/core/services/alerts_service.dart';
import 'package:traitement_image/core/services/images_services.dart';
import 'package:traitement_image/core/models/ppm_image.dart';
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
  PGMImage? img;

  late VoidCallback onReadImageClick;
  late VoidCallback onWriteImageClick;
  late Function onModifyContrastClick;
  late Function onOptionSelected;


  // /// looking for a better way
  // Bitmap? bitmap ;
  // Uint8List? headedBitmap ;
  // getImg () async {
  //   img = await ImagesService().readPGM("C:\\Users\\Sammari Amal\\Downloads\\chat.pgm");
  //   if(img!=null) {
  //      bitmap = ImagesService().displayPGM(img!);
  //      headedBitmap = bitmap!.buildHeaded();
  //     imageForPaint = await bitmap!.buildImage();
  //     setState(() {
  //
  //     });
  //   }
  // }
  // getImg2nd () async {
  //   img = await ImagesService().readPGM("C:\\Users\\Sammari Amal\\Downloads\\chat.pgm");
  //   if(img!=null) {
  //     imageForPaint = await ImagesService().displayPGM1(img!);
  //     await imageForPaint?.toByteData(
  //         format: ImageByteFormat.rawStraightRgba
  //     );
  //     setState(() {
  //
  //     });
  //   }
  //
  // }
  // ui.Image? imageForPaint ;

  tryC() async {
      img = await ImagesService().readPGM("C:\\Users\\Sammari Amal\\Downloads\\chat.pgm");
      if(img != null) {
        imagesService.tryCreatePGM(img!, "C:\\Users\\Sammari Amal\\Desktop\\projet traitement d'images\\try");
      }

  }

  @override
  initState(){


    tryC();
    ///looking for a better way
    // getImg();
    //getImg2nd();

    /// ////////// Changement de l'emplacement (build ---> initstate)  //////////// ///
     onReadImageClick = () async {
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

        /// ----  Exercice 1 ----
        imagesService.seuillageManuel(image, [10,10,10],1, "C:\\Users\\Sammari Amal\\Desktop\\projet traitement d'images\\seuilManuel");


        /// ----  Exercice 2 ----
        var img = imagesService.seuillageOtsu(image, 1, "C:\\Users\\Sammari Amal\\Desktop\\projet traitement d'images\\seuilOtsu");

        /// ----  Exercice 3 ----

        ///1) Erosion
        imagesService.erosion(img, 3, "C:\\Users\\Sammari Amal\\Desktop\\projet traitement d'images\\erosion", true);
        ///2) Dilatation
        imagesService.dilatation(img, 3, "C:\\Users\\Sammari Amal\\Desktop\\projet traitement d'images\\dilatation", true);
        ///3) Ouverture
        imagesService.ouverture(img, 3, "C:\\Users\\Sammari Amal\\Desktop\\projet traitement d'images\\ouverture");
        ///3) Fermeture
        imagesService.fermeture(img, 3, "C:\\Users\\Sammari Amal\\Desktop\\projet traitement d'images\\fermeture");


        imagesService.writePPM(image, "C:\\Users\\Sammari Amal\\Desktop\\projet traitement d'images\\peppers1");

      }
    };
     onWriteImageClick = () async {
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
     onModifyContrastClick = (Map<int,int> points) async {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Enregister l\'image dans',
        fileName: "modified_contrast",
      );
      if(outputFile != null) {
        contrastedImage = imagesService.modifyContrastPGM(image, points,outputFile);
      }
    };
     onOptionSelected = (int i) {
      setState((){
        if(toolPanelSelected == i){
          toolPanelSelected = 0;
        }
        else{
          toolPanelSelected = i;
        }
      });
    };
     /// ////////////////////////////////////// ///

     super.initState();
  }


  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;


    return SafeArea(
      child: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          children: [

            //Footer Bar
            /*footerBar(
              deviceHeight: deviceHeight,
              deviceWidth: deviceWidth,
              moyenne: image != null ? ImagesService().moyennePGM(image).toStringAsFixed(2) : null,
              ecartType: image != null ? ImagesService().ecartTypePGM(image).toStringAsFixed(2) : null,
              show: image != null && image.runtimeType == PGMImage ,
            ),*/
            //TODO calcul de moyenne pour ppm

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
                      width: deviceWidth * 0.2,
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

                    /// Test zone ////////////////////////////////////////

                    // ///looking for a better way
                    // if(headedBitmap != null)
                    //   Image.memory(headedBitmap!,width: 800,height: 400,filterQuality: FilterQuality.none,),
                    //
                    // //Graphs
                    //
                    //
                    // if(imageForPaint != null)...[
                    //   CustomPaint(
                    //     isComplex:true,
                    //     foregroundPainter: ImageEditor(image: imageForPaint!),
                    //   ),
                    // ],



                    /// /////////////////////////////////////////////////







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
