
import 'dart:io';
import 'dart:math';

import 'package:traitement_image/core/models/pgm_image.dart';
import 'package:traitement_image/core/models/ppm_image.dart';

class ImagesService {
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
    ly = int.parse(contents[2].split(" ")[0]);
    lx = int.parse(contents[2].split(" ")[1]);
    maxValue = int.parse(contents[3].split(" ")[0]);
    PPMImage img = PPMImage(lx: lx, ly: ly, maxValue: maxValue);
    List<int> pixels = [];
    for(int i =4 ; i< contents.length; i++) {
      contents[i].split(" ").forEach((element) {
        if (int.tryParse(element.trim()) != null) {
          pixels.add(int.parse(element.trim()));
        }
      });
    }
    for(int j=0; j<pixels.length; j+=3){

      img.r.add(pixels[j]);
      img.g.add(pixels[j+1]);
      img.b.add(pixels[j+2]);
    }
    return img;
  }

  void writePGM(PGMImage img, String path) async {
    final File file = File("$path.pgm");
    String text = "P2\n# commentaire\n${img.ly} ${img.lx}\n${img.maxValue}";
    for(int row =0 ; row < img.lx; row++){
      String text2 = "\n";
      for (int col = 0; col < img.ly; col++) {
        text2+= img.mat[row][col].toString();
        if(col != img.ly-1) {
          text2 += " ";
        }
      }
      text+=text2;
      text2= '';
    }
    await file.writeAsString(text);
  }

  void writePPM(PPMImage img, String path) async {

    final File file = File("$path.ppm");
    String text = "P3\n# commentaire\n${img.ly} ${img.lx}\n${img.maxValue}";
    for(int row =0 ; row < img.lx; row++){
      String text2 = "\n";
      for (int col = 0; col < img.ly; col++) {
        text2+= "${img.r[row*(img.ly) + col]} ";
        text2+= "${img.g[row*(img.ly) + col]} ";
        text2+= img.b[row*(img.ly) + col].toString();
        if(col != img.ly-1) {
          text2 += " ";
        }
      }
      text+=text2;
      text2= '';
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

  List<double> moyennePPM(PPMImage img){
    List<double> moys = List.filled(3, 0);
    for (int row = 0; row < img.lx; row++) {
      for (int col = 0; col < img.ly; col++) {
        moys[0] += img.r[row*img.ly + col];
        moys[1] += img.g[row*img.ly + col];
        moys[2] += img.b[row*img.ly + col];
      }
    }
    moys[0] = moys[0]/(img.lx*img.ly);
    moys[1] = moys[1]/(img.lx*img.ly);
    moys[2] = moys[2]/(img.lx*img.ly);
    return moys;
  }

  double moyennePPMFromHist(List<int> hist,int start, int end){
    double moy = 0;
    for(int i=start; i<= end;i++ ){
      moy += hist[i];
    }

    moy = moy/ (end-start+1);

    return moy;
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

  ///ecart type PPM
  List<double> ecartTypePPM(PPMImage img) {
    List<double> listE = List.filled(3, 0);
    List<double> listMoy = moyennePPM(img);

    for (int i = 0; i < img.r.length; i++) {
      listE[0] += pow(img.r[i] - listMoy[0], 2) / (img.lx * img.ly);
      listE[1] += pow(img.g[i] - listMoy[1], 2) / (img.lx * img.ly);
      listE[2] += pow(img.b[i] - listMoy[2], 2) / (img.lx * img.ly);
    }
    for (int i = 0; i < 3; i++) {
      listE[i] = sqrt(listE[i]);
    }
    return listE;
  }

  List<int> histogrammePGM(PGMImage img) {
    List<int> hist = List.filled(img.maxValue + 1, 0);
    for (int row = 0; row < img.lx; row++) {
      for (int col = 0; col < img.ly; col++) {
        hist[img.mat[row][col]] ++;
      }
    }
    return hist;
  }

  List<int> histogramme(List<int> pixels, int maxValue){
    List<int> hist = List.filled(maxValue+1,0);
    for (int row = 0; row < pixels.length; row++) {
      hist[pixels[row]]++;
    }
    return hist;
  }

  List<List<int>> histogrammePPM(PPMImage img){
    List<int> histR = List.filled(img.maxValue+1,0);
    List<int> histG = List.filled(img.maxValue+1,0);
    List<int> histB = List.filled(img.maxValue+1,0);
    for (int row = 0; row < img.lx; row++) {
      for (int col = 0; col < img.ly; col++) {
        histR[img.r[row*img.ly + col]] ++;
        histG[img.g[row*img.ly + col]] ++;
        histB[img.b[row*img.ly + col]] ++;
      }
    }
    return [histR, histG, histB];
  }

  ///histogram Cumulé PPM
  List<List<int>> histogrammeCumulePPM(PPMImage img) {
    List<List<int>> histCum = List.filled(3, []);
    int histLength = img.maxValue + 1;
    for (int i = 0; i < 3; i++) {
      histCum[i] = histogrammePPM(img)[i];

      for (int j = 1; j < histLength; j++) {
        histCum[i][j] += histCum[i][j - 1];
      }
    }
    return histCum;
  }

  List<int> histogrammeCumulePGM(PGMImage img) {
    List<int> hist = histogrammePGM(img);
    for (int i = 1; i < img.maxValue+1; i++) {
      hist[i] += hist[i-1];
    }
    return hist;
  }


  ///histogram égalisé PPM
  List<List<int>> histogrammeEgalisePPM(PPMImage img) {
    int histLength = img.maxValue + 1;

    List<List<int>> histE = List.filled(3, List.filled(histLength, 0));
    List<List<int>> hist = histogrammePPM(img);
    List<List<int>> histCum = histogrammeCumulePPM(img);
    List<List<int>> n = List.filled(3, []);

    for(int i=0;i<3;i++){
      n[i] = histCum[i].map((e) => (img.maxValue * (e / (img.lx * img.ly))).ceil())
          .toList();
      for(int j=0 ; j<histLength ;j++){
        histE[i][n[i][j]] += hist[i][j];
      }
    }

    return histE;
  }

  List<int> histogrammeEgalisePGM(PGMImage img) {
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

  PGMImage bruit(PGMImage img, String path, bool create){
    int r;
    var rng = Random();
    PGMImage img2 = PGMImage.clone(img);
    img2.mat = img.mat.map((item) => item.map((e) => e).toList()).toList();
    for (int row = 0; row < img2.lx; row++) {
      for (int col = 0; col < img2.ly; col++) {
        r = rng.nextInt(21);
        if(r==0) {
          img2.mat[row][col] = 0;
        } else if(r== 20) {
          img2.mat[row][col] = img2.maxValue;
        }
      }
    }
    if(create)
      writePGM(img2, path);
    return img2;
  }

  PGMImage filtreMoyenneur(PGMImage img, int n, String path, bool create){

    PGMImage img2 = PGMImage.clone(img);
    img2.mat = img.mat.map((item) => item.map((e) => e).toList()).toList();

    int x = (n/2).floor();

    for(int row =0; row <img.lx; row++){
      for (int col = 0; col < img.ly; col++) {
        int s=0;
        for(int i = row-x; i<= row+x;i++) {
          for (int j = col-x; j <= col+x; j++) {
            if((i>=0 && j>=0) && (i<img.lx && j<img.ly)){
              s+= img.mat[i][j];
            }
          }
        }
        img2.mat[row][col] = (s/(n*n)).floor();
      }
    }

    if(create)
      writePGM(img2, path);
    return img2;
  }

  PGMImage filtreMedian(PGMImage img, int n, bool square,String path, bool create){

    PGMImage img2 = PGMImage.clone(img);
    img2.mat = img.mat.map((item) => item.map((e) => e).toList()).toList();

    int x = (n/2).floor();

    for(int row =0; row <img.lx; row++){
      for (int col = 0; col < img.ly; col++) {
        List<int> pixels = [];
        if(square){
          for(int i = row-x; i<= row+x;i++) {
            for (int j = col-x; j <= col+x; j++) {
              if((i>=0 && j>=0) && (i<img.lx && j<img.ly)){
                pixels.add(img.mat[i][j]);
              }
              else{
                pixels.add(0);
              }
            }
          }
        }
        else{
          for(int i = -x; i <= x; i++) {
            if(i!=0){
              if(row+i<img.lx && row+i>=0){
                pixels.add(img.mat[row+i][col]);
              }
              else{
                pixels.add(0);
              }

              if(col+i<img.ly && col+i>=0){
                pixels.add(img.mat[row][col+i]);
              }
              else{
                pixels.add(0);
              }
            }
          }
          pixels.add(img.mat[row][col]);
        }
        pixels.sort();
        img2.mat[row][col] = pixels[(pixels.length/2).floor()];
      }
    }

    if(create)
      writePGM(img2, path);
    return img2;
  }

  PGMImage filtreConvolution(PGMImage img, List<List<int>> masque, String path){
    PGMImage img2 = PGMImage.clone(img);
    img2.mat = img.mat.map((item) => item.map((e) => e).toList()).toList();

    int x = (masque.length/2).floor();
    int s = 0;

    for(int row =0; row <img.lx; row++) {
      for (int col = 0; col < img.ly; col++) {
        for(int i = -x; i<= x;i++) {
          for (int j = -x; j <= x; j++) {
            if((row+i>=0 && col+j>=0) && (row+i<img.lx && col+j<img.ly)){
              s += img.mat[row+i][col+j]*masque[i+x][j+x];
            }
          }
        }
        int val = s.abs().floor();
        img2.mat[row][col] = val > img.maxValue ? img.maxValue : val;
        s=0;
      }
    }
    writePGM(img2, path);
    return img2;
  }

  PGMImage filtreHighBoost(PGMImage img, PGMImage imgFiltre ,String path){
    PGMImage img2 = PGMImage.clone(img);
    img2.mat = img.mat.map((item) => item.map((e) => e).toList()).toList();
    for(int row =0; row <img.lx; row++) {
      for (int col = 0; col < img.ly; col++) {
        int val = (img.mat[row][col] - imgFiltre.mat[row][col]);
        img2.mat[row][col] = val < 0 ? 0 : val;
      }
    }
    writePGM(img2, path);
    return img2;
  }

  //TODO
  double signalBruit(PGMImage original, PGMImage traite){
    double moy = moyennePGM(original);
    double x =0, y=0;

    for(int row =0; row <original.lx; row++){
      for (int col = 0; col < original.ly; col++) {
        x += pow(original.mat[row][col]-moy,2);
        y += pow(traite.mat[row][col] - original.mat[row][col],2);
      }
    }
    return sqrt(x/y);
  }

  PPMImage seuillageManuel(PPMImage img, List<int> seuils, int option, String path, bool create) {
    PPMImage img2 = PPMImage.clone(img);
    img2.r = img.r.map((e)=>e).toList();
    img2.g = img.g.map((e)=>e).toList();
    img2.b = img.b.map((e)=>e).toList();

    for(int row =0; row < img.lx; row++){
      for (int col = 0; col < img.ly; col++) {
        int x = row * img.ly + col;
        if(option ==0){
          img2.r[x] = (img.r[x] > seuils[0]) ? img2.maxValue : 0;
          img2.g[x] = (img.g[x] > seuils[1]) ? img2.maxValue : 0;
          img2.b[x] = (img.b[x] > seuils[2]) ? img2.maxValue : 0;
        }
        else if(option == 1){
          if((img.r[x] > seuils[0] && img.g[x] > seuils[1] && img.b[x] > seuils[2])){
            img2.r[x] = img2.maxValue;
            img2.g[x] = img2.maxValue;
            img2.b[x] = img2.maxValue;
           }
          else{
            img2.r[x] = 0;
            img2.g[x] = 0;
            img2.b[x] = 0;
          }
        }
        else{
          if((img.r[x] > seuils[0] || img.g[x] > seuils[1] || img.b[x] > seuils[2])){
            img2.r[x] = img2.maxValue;
            img2.g[x] = img2.maxValue;
            img2.b[x] = img2.maxValue;
          }
          else{
            img2.r[x] = 0;
            img2.g[x] = 0;
            img2.b[x] = 0;
          }
        }
      }
    }
    if(create)
      writePPM(img2, path);
    return img2;
  }

  //TODO ou option ???
  PPMImage seuillageOtsu(PPMImage img, int option,String path, bool create) {
    List<int> seuils= [0,0,0];

    seuils[0] = seuillageOtsuCouleur(img.r, img.maxValue);
    seuils[1] = seuillageOtsuCouleur(img.g, img.maxValue);
    seuils[2] = seuillageOtsuCouleur(img.b, img.maxValue);

    return seuillageManuel(img, seuils, option, path, create);

  }

  int seuillageOtsuCouleur(List<int> pixels, int maxValue){

    ///Calcul d'histogramme
    List<int> hist = histogramme(pixels, maxValue);

    ///Calcul de proba cumulé
    List<double> probasCumule= List.filled(maxValue+1, 0);
    probasCumule[0] = hist[0]/pixels.length;
    for(int i=1; i <= maxValue ;i++){
      probasCumule[i] = probasCumule[i-1] + hist[i]/ pixels.length;
    }

    ///calcul variance interclasse
    double moy = moyennePPMFromHist(hist, 0, maxValue);
    int kMax = 1;
    double varianceMax = 0;
    double moyC1 = 0;
    double variance = 0;
    for(int i=1; i< maxValue; i++){
      moyC1 = moyennePPMFromHist(hist, 0, i);
      variance = ((moy*probasCumule[i]- moyC1)*(moy*probasCumule[i]- moyC1))/(probasCumule[i]*(1-probasCumule[i]));
      if(variance > varianceMax){
        varianceMax = variance;
        kMax = i;
      }
    }

    return kMax;
  }

  PPMImage erosion(PPMImage img, int n, String path, bool create){
    PPMImage img2 = PPMImage.clone(img);
    int x = (n/2).floor();
    img2.r = erosionDilationColor(img.r, x, img.lx, img.ly,0);
    img2.g = erosionDilationColor(img.g, x, img.lx, img.ly,0);
    img2.b = erosionDilationColor(img.b, x, img.lx, img.ly,0);

    if(create) writePPM(img2, path);
    return img2;
  }

  PPMImage dilatation(PPMImage img, int n, String path, bool create){
    PPMImage img2 = PPMImage.clone(img);
    int x = (n/2).floor();
    img2.r = erosionDilationColor(img.r, x, img.lx, img.ly,img.maxValue);
    img2.g = erosionDilationColor(img.g, x, img.lx, img.ly,img.maxValue);
    img2.b = erosionDilationColor(img.b, x, img.lx, img.ly,img.maxValue);

    if(create) writePPM(img2, path);
    return img2;
  }

  /// val =0 : erosion | val = maxValue : dilatation
  List<int> erosionDilationColor(List<int> pixels, int x, int lx , int ly, int val){
    List<int> erosion = pixels.map((e) => e).toList();

    for(int row =0; row < lx; row++){
      for (int col = 0; col < ly; col++) {
        bool b = true;
        for(int i = row-x; i<= row+x;i++) {
          for (int j = col-x; j <= col+x; j++) {
            if((i>=0 && j>=0) && (i<lx && j<ly)){
              if(pixels[i*ly+j] == val){
                erosion[row*ly+col] = val;
                b = false;
                break;
              }
            }
          }
          if(!b) break;
        }
      }
    }
    return erosion;
  }

  PPMImage ouverture(PPMImage img, int n, String path){
    PPMImage img2 = PPMImage.clone(img);
    img2 = dilatation(erosion(img, n, path, false), n, path, false);

    writePPM(img2, path);
    return img2;
  }

  PPMImage fermeture(PPMImage img, int n, String path){
    PPMImage img2 = PPMImage.clone(img);
    img2 = erosion(dilatation(img, n, path, false), n, path, false);
    writePPM(img2, path);
    return img2;
  }

}
