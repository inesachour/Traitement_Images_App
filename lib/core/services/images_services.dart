
import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:traitement_image/core/models/pgm_image.dart';
import 'package:traitement_image/core/models/ppm_image.dart';

class ImagesService{

  Future<String> imageType(String path) async {
    File file = File(path);
    String type = "";
    await file.readAsLines().then((value) {
      return {
      if(value[0]== "P2"){
        type = "pgm"
      }
      else if (value[0] == "P3"){
        type = "ppm"
      }
    };
    });
    return type;
  }

  Future<PGMImage> readPGM(String path) async {
    File file = File(path);
    int maxValue, lx, ly;
    final contents = await file.readAsLines();
    lx = int.parse(contents[2].split(" ")[1]);
    ly = int.parse(contents[2].split(" ")[0]);
    maxValue = int.parse(contents[3].split(" ")[0]);
    PGMImage img = PGMImage(lx: lx, ly: ly, maxValue: maxValue);
    for(int i =4 ; i< contents.length; i++){
      //contents[i].split(" ").forEach((element) {print(element);});
      contents[i] = contents[i].trim();
      List<int> pixels = contents[i].split(" ").map((e) => int.parse(e)).toList();
      img.mat.add(pixels);
    }
    return img;
  }

  Future<PPMImage> readPPM(String path) async {
    File file = File(path);
    int maxValue, lx, ly;
    final contents = await file.readAsLines();
    lx = int.parse(contents[2].split(" ")[1]);
    ly = int.parse(contents[2].split(" ")[0]);
    maxValue = int.parse(contents[3].split(" ")[0]);
    PPMImage img = PPMImage(lx: lx, ly: ly, maxValue: maxValue);
    for(int i =4 ; i< contents.length; i++){
      List<int> pixels = contents[i].split(" ").map((e) => int.parse(e)).toList();
      for(int j =0; j<pixels.length; j+=3){
        img.r.add(pixels[j]);
        img.g.add(pixels[j+1]);
        img.b.add(pixels[j+2]);
      }
    }
    return img;
  }

  void writePGM(PGMImage img, String path) async {
    final File file = File(path);
    String text = "P2\n# commentaire\n${img.ly} ${img.lx}\n${img.maxValue}";
    for(int row =0 ; row < img.lx; row++){
      text += "\n";
      for (int col = 0; col < img.ly; col++) {
        text+= img.mat[row][col].toString();
        if(col != img.ly-1) {
          text += " ";
        }
      }
    }
    await file.writeAsString(text);

  }

  void writePPM(PPMImage img, String path) async {
    final File file = File(path);
    String text = "P3\n# commentaire\n${img.ly} ${img.lx}\n${img.maxValue}";
    for(int row =0 ; row < img.lx; row++){
      text += "\n";
      for (int col = 0; col < img.ly; col++) {
        text+= "${img.r[row*img.lx + col]} ";
        text+= "${img.g[row*img.lx + col]} ";
        text+= img.b[row*img.lx + col].toString();
        if(col != img.ly-1) {
          text += " ";
        }
      }
    }
    await file.writeAsString(text);
  }

  double moyennePGM(PGMImage img){
    double moy = 0;
    for (int row = 0; row < img.lx; row++) {
      for (int col = 0; col < img.ly; col++) {
        moy += img.mat[row][col];
      }
    }
    return moy/(img.lx*img.ly);
  }

  double ecartTypePGM(PGMImage img){
    double moy = moyennePGM(img);
    double val = 0;
    for (int row = 0; row < img.lx; row++) {
      for (int col = 0; col < img.ly; col++) {
        val += pow(img.mat[row][col]- moy,2);
      }
    }
    val = val/(img.lx*img.ly);
    return sqrt(val);
  }

  List<int> histogrammePGM(PGMImage img){
    List<int> hist = List.filled(img.maxValue+1,0);
    for (int row = 0; row < img.lx; row++) {
      for (int col = 0; col < img.ly; col++) {
        hist[img.mat[row][col]] ++;
      }
    }
    return hist;
  }

  List<int> histogrammeCumulePGM(PGMImage img){
    List<int> hist = histogrammePGM(img);
    for (int i = 1; i < img.maxValue+1; i++) {
      hist[i] += hist[i-1];
    }
    return hist;
  }

  List<int> histogrammeEgalisePGM(PGMImage img){
    List<int> hist = histogrammePGM(img);
    List<int> n = histogrammeCumulePGM(img)
        .map(
            (e) => (img.maxValue*(e/(img.lx*img.ly))).ceil())
        .toList();

    List<int> histEgalise = List.filled(img.maxValue+1,0);
    for(int i=0;i<n.length;i++){
      histEgalise[n[i]] += hist[i];
    }

    return histEgalise;
  }


  PGMImage modifyContrastPGM(PGMImage img, Map<int,int> points){



    points = {0:0,50:100, 60:10, 150:200, 255:255};

    List<int> newPixels = List.filled(img.maxValue+1,0);
    Map<double,double> fn;
    for(int j =0;j<points.length-1;j++){
      fn = newPoint(points.keys.elementAt(j), points.values.elementAt(j), points.keys.elementAt(j+1), points.values.elementAt(j+1));
      for(int i=points.keys.elementAt(j);i<=points.keys.elementAt(j+1);i++){
        newPixels[i] = (fn.keys.first * i + fn.values.first).ceil();
      }
    }

    PGMImage img2 = PGMImage.clone(img);
    img2.mat = img.mat.map((item) => item.map((e) => e).toList()).toList();

    for (int row = 0; row < img2.lx; row++) {
      for (int col = 0; col < img2.ly; col++) {
        img2.mat[row][col] = newPixels[img2.mat[row][col]];
      }
    }
    writePGM(img2, "D:\\Users\\Ines\\Desktop\\new.pgm");
    return img2;
  }

   Map<double,double> newPoint(int x0, int y0, int x1, int y1){
    double a = (y1-y0)/(x1-x0);
    double b = y1 - a*x1;
    return {a:b};
  }

}
