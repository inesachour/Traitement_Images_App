
class PPMImage{

  PPMImage({required this.lx, required this.ly, required this.maxValue});

  int lx;
  int ly;
  int maxValue;
  List<int> r = [];
  List<int> g = [];
  List<int> b = [];

  PPMImage.clone(PPMImage image): this(lx: image.lx, ly: image.ly, maxValue: image.maxValue);
}