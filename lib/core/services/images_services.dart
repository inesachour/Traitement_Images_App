
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
    final File file = File("$path.pgm");
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
    final File file = File("$path.ppm");
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


  PGMImage modifyContrastPGM(PGMImage img, Map<int,int> points, String path){
    if(!points.keys.contains(0)) points.addAll({0:0});
    if(!points.keys.contains(img.maxValue)) points.addAll({img.maxValue : img.maxValue});

    //Trier Map des points
    Map<int,int> sortedByKeyMap = Map.fromEntries(
        points.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));

    //LUT
    List<int> newPixels = List.filled(img.maxValue+1,0);
    Map<double,double> fn;
    for(int j =0;j<sortedByKeyMap.length-1;j++){
      fn = newPoint(sortedByKeyMap.keys.elementAt(j), sortedByKeyMap.values.elementAt(j), sortedByKeyMap.keys.elementAt(j+1), sortedByKeyMap.values.elementAt(j+1));
      for(int i=sortedByKeyMap.keys.elementAt(j);i<=sortedByKeyMap.keys.elementAt(j+1);i++){
        newPixels[i] = (fn.keys.first * i + fn.values.first).ceil();
      }
    }

    //Creation de l'image modifié
    PGMImage img2 = PGMImage.clone(img);
    img2.mat = img.mat.map((item) => item.map((e) => e).toList()).toList();

    for (int row = 0; row < img2.lx; row++) {
      for (int col = 0; col < img2.ly; col++) {
        img2.mat[row][col] = newPixels[img2.mat[row][col]];
      }
    }
    writePGM(img2, path);
    return img2;
  }


   Map<double,double> newPoint(int x0, int y0, int x1, int y1){
    double a = (y1-y0)/(x1-x0);
    double b = y1 - a*x1;
    return {a:b};
  }

  PGMImage bruit(PGMImage img, String path){
    int r;
    var rng = Random();
    PGMImage img2 = PGMImage.clone(img);
    img2.mat = img.mat.map((item) => item.map((e) => e).toList()).toList();
    for (int row = 0; row < img2.lx; row++) {
      for (int col = 0; col < img2.ly; col++) {
        r = rng.nextInt(21);
        if(r==0) img2.mat[row][col] = 0;
        else if(r== img2.maxValue) img2.mat[row][col] = img2.maxValue;
      }
    }
    writePGM(img2, path);
    return img2;
  }

  PGMImage filtrerMoyenneur(PGMImage img, int n, String path){

    PGMImage img2 = PGMImage.clone(img);
    img2.mat =List.filled(img.lx, List.filled(img.ly,0));// img.mat.map((item) => item.map((e) => e).toList()).toList();

    List<List<int>> nvMat = List.filled(img.lx+ n-1, List.filled(img.ly+n-1,0));

    for(int i = (n/2).ceil(); i < img.lx+(n/2).ceil(); i++){
      for(int j = (n/2).ceil(); j < img.ly+(n/2).ceil(); j++){
        nvMat[i][j] = img.mat[i- (n/2).ceil()][j -(n/2).ceil()];
      }
    }

    int s=0;
    for (int row = 0; row < img2.lx; row++) {
      for (int col = 0; col < img2.ly; col++) {
        s=0;
        for(int i = row; i< row+n;i++){
          for(int j = col; j< col+n;j++){
            if (i==0)
            print(nvMat[i][j]);
            s += nvMat[i][j];
          }
        }
        img2.mat[row][col] = (s/(n*n)).ceil();
      }
    }

    writePGM(img2, path);
    return img2;
  }
}
