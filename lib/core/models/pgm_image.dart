
class PGMImage{

  PGMImage({required this.lx, required this.ly, required this.maxValue});

  int lx;
  int ly;
  int maxValue;
  List<List<int>> mat = [];

  PGMImage.clone(PGMImage image): this(lx: image.lx, ly: image.ly, maxValue: image.maxValue);
}