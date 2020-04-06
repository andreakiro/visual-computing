PImage img;
PImage img2;
HScrollbar thresholdBar;
HScrollbar lolbar;

void settings() {
  size(800, 600);
}
void setup() {
  img = loadImage("board1.jpg");
  //img2 = loadImage("board1Thresholded.bmp");
  thresholdBar = new HScrollbar(0, 580, 800, 20);
  lolbar = new HScrollbar(0, 530, 800, 20);
  noLoop(); // no interactive behaviour: draw() will be called only once. 
}

void draw() {
  /* thresholdBar.update();
  lolbar.update();
  int threshold = (int) map(thresholdBar.getPos(), 0, 1, 0, 255);
  int threshold2 = (int) map(lolbar.getPos(), 0, 1, 0, 255);
  image(invertedBinaryThreshold(img, threshold), 0, 0); 
  image(hueMap(img), 0, 0);
  image(hueKiki(img, threshold, threshold2), 0, 0);
  thresholdBar.display();
  lolbar.display();
  PImage lol = thresholdHSB(img, 100, 200, 100, 255, 45, 100);
  image(lol, 0, 0);
  print(imagesEqual(lol, img2)); */
  
  float[][] gaussianblurkernel = {{ 9, 12, 9 },
                      { 12, 15, 12 },
                      { 9, 12, 9 }};
  PImage ourimage = convolute(img, gaussianblurkernel);
  print(imagesEqual(ourimage, loadImage("board1Blurred.bmp")));
  image(ourimage, 0, 0);
}

void drawLol() {
  image(img, 0, 0); //show image
  PImage img2 = img.copy(); //make a deep copy 
  img2.loadPixels(); // load pixels
  for (int x = 0; x < img2.width; x++)
    for (int y = 0; y < img2.height; y++)
      if (y%2==0)
        img2.pixels[y*img2.width+x] = color(0, 255, 0); img2.updatePixels();//update pixels
  image(img2, img.width, 0); 
}

PImage binaryThreshold(PImage img, int threshold) {
  // create a new, initially transparent, 'result' image 
  PImage result = createImage(img.width, img.height, RGB); 
  for(int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = brightness(img.pixels[i]) > threshold ? color(255) : color(0);
  }
  return result;
}

PImage invertedBinaryThreshold(PImage img, int threshold) {
  // create a new, initially transparent, 'result' image 
  PImage result = createImage(img.width, img.height, RGB); 
  for(int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = brightness(img.pixels[i]) > threshold ? color(0) : color(255);
  }
  return result;
}

PImage hueMap(PImage img) {
  // create a new, initially transparent, 'result' image 
  PImage result = createImage(img.width, img.height, RGB); 
  for(int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(hue(img.pixels[i]));
  }
  return result;
}

PImage hueKiki(PImage img, int min, int max) {
  // create a new, initially transparent, 'result' image 
  PImage result = createImage(img.width, img.height, RGB); 
  for(int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = hue(img.pixels[i]) > min && hue(img.pixels[i]) < max ? img.pixels[i] : color(0);
  }
  return result;
}

/* this is the function we'll use in the project */
PImage thresholdHSB(PImage img, int minH, int maxH, int minS, int maxS, int minB, int maxB) {
  PImage result = createImage(img.width, img.height, RGB); 
  for(int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = 
      hue(img.pixels[i]) >= minH && hue(img.pixels[i]) <= maxH &&
      saturation(img.pixels[i]) >= minS && saturation(img.pixels[i]) <= maxS &&
      brightness(img.pixels[i]) >= minB && brightness(img.pixels[i]) <= maxB ? color(255) : color(0);
  }
  return result;
}

boolean imagesEqual(PImage img1, PImage img2) {
  if(img1.width != img2.width || img1.height != img2.height) return false;
  for(int i = 0; i < img1.width*img1.height ; i++)
    if(red(img1.pixels[i]) != red(img2.pixels[i])) return false;
  return true;
}

PImage convolute(PImage img, float[][] kernel) {
  PImage result = createImage(img.width, img.height, ALPHA);
  int n = kernel.length;
  float normFactor = 0;
  
  for (int i = 0; i < kernel.length; i++)
    for (int j = 0; j < kernel[i].length; j++)
      normFactor += kernel[i][j];
  
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      float pixel = 0;
      for (int i = -n/2; i < n/2; i++) {
        for (int j = -n/2; j < n/2; j++) {
          float brightness = 0; 
          if (0 <= (y+i) && (y+i) < img.height && 0 <= (x+j) && (x+j) < img.width) {
            brightness = brightness(img.pixels[(y+i)*img.width + (x+j)]);
          }
          pixel += kernel[n/2+i][n/2+j] * brightness;
        }
       }
       result.pixels[y*img.width + x] = color(pixel / normFactor);
      }
    }
    
  return result;
}
