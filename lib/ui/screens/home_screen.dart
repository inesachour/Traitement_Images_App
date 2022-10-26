import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:traitement_image/core/models/pgm_image.dart';
import 'package:traitement_image/core/services/images_services.dart';
import 'package:traitement_image/core/models/ppm_image.dart';
import 'package:traitement_image/ui/widgets/charts_widgets.dart';
import 'package:traitement_image/ui/widgets/general_info_widgets.dart';
import 'package:traitement_image/ui/widgets/main_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var image;
  PGMImage? secondImage = null;




  @override
  Widget build(BuildContext context) {

    // ignore: prefer_function_declarations_over_variables
    VoidCallback onReadImageClick = () async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        String extension = await ImagesService().imageType(result.files.single.path!);
        if(extension == "ppm"){
          PPMImage img = await  ImagesService().readPPM(result.files.single.path!);
          image = img;
        }
        else if(extension == "pgm"){
          image = await ImagesService().readPGM(result.files.single.path!);
          secondImage = ImagesService().modifyContrastPGM(image);
        }
        setState((){});
      }
    };

    // ignore: prefer_function_declarations_over_variables
    VoidCallback onWriteImageClick = () async {
      if(image.runtimeType == PPMImage){
        ImagesService().writePPM(image, "D:\\Users\\Ines\\Desktop\\exemple2.ppm"); //TODO change path
      }
      else if(image.runtimeType == PGMImage){
        ImagesService().writePGM(image, "D:\\Users\\Ines\\Desktop\\exemple2.pgm"); //TODO change path
      }
    };

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: deviceWidth *0.15,
              height: deviceHeight,
              color: Colors.blue,
              child: Column(
                children: [
                  mainButton(
                    title: "Lire Image",
                    onPressed: onReadImageClick,
                  ),

                  mainButton(
                    title: "Ecrire Image",
                    onPressed: onWriteImageClick,
                    enabled: image != null,
                  ),

                ],
              ),
            ),

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
                      if(secondImage != null)
                      histogramChart(
                          data: ImagesService().histogrammePGM(secondImage!).asMap(),
                          barWidth: 4,
                          width: deviceWidth*0.7,
                          height: deviceWidth*0.2,
                          title: "Histogramme Apres modification de Contrast"
                      ),

                      histogramChart(
                          data: ImagesService().histogrammeCumulePGM(image).asMap(),
                          barWidth: 4,
                          width: deviceWidth,
                          height: deviceWidth*0.4,
                          title: "Histogramme Cumulé"
                      ),

                      histogramChart(
                          data: ImagesService().histogrammeEgalisePGM(image).asMap(),
                          barWidth: 4,
                          width: deviceWidth,
                          height: deviceWidth*0.4,
                          title: "Histogramme Egalisé"
                      ),
                    ],
                  ),
                ),
              ),



            Container(
              height: deviceHeight,
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
      ),
    );
  }
}
