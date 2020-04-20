PImage img;
HScrollbar thresholdBar;

void settings() {
  size(800, 600);
}
void setup() {
  img = loadImage("BlobDetection_Test.png");
  noLoop();
}

void draw() {  
  /*float[][] gaussianblurkernel = {{ 9, 12, 9 },
                      { 12, 15, 12 },
                      { 9, 12, 9 }};
  PImage colorThreshold = thresholdHSB(img, 85, 145, 106, 255, 30, 150);
  //PImage a = convolute(colorThreshold, gaussianblurkernel);
  PImage edges = scharr(colorThreshold);
  PImage b = convolute(edges, gaussianblurkernel);
  PImage end = binaryThreshold(b, 100);
  image(end, 0, 0);*/
  PImage blob = new BlobDetection().findConnectedComponents(img, false);
  image(blob, 0, 0);
}

PImage binaryThreshold(PImage img, int threshold) {
  PImage result = createImage(img.width, img.height, RGB); 
  for(int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = brightness(img.pixels[i]) > threshold ? color(255) : color(0);
  }
  return result;
}

PImage invertedBinaryThreshold(PImage img, int threshold) { 
  PImage result = createImage(img.width, img.height, RGB); 
  for(int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = brightness(img.pixels[i]) > threshold ? color(0) : color(255);
  }
  return result;
}

PImage hueMap(PImage img) {
  PImage result = createImage(img.width, img.height, RGB); 
  for(int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(hue(img.pixels[i]));
  }
  return result;
}

PImage hueMinMax(PImage img, int min, int max) {
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
  for(int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }
  
  int n = kernel.length;
  
  float normFactor = 0;
  for (int i = 0; i < kernel.length; i++)
    for (int j = 0; j < kernel[i].length; j++)
      normFactor += kernel[i][j];
  
  for (int x = 1; x < img.width - 1; x++) {
    for (int y = 1; y < img.height - 1; y++) {
      int pixel = 0;
      for (int i = -n/2; i <= n/2; i++) {
        for (int j = -n/2; j <= n/2; j++) {
          pixel += kernel[n/2+i][n/2+j] * brightness(img.pixels[(y+i)*img.width + (x+j)]);
        }
      }
      pixel = (int) (pixel / normFactor);
      result.pixels[y*img.width + x] = color(pixel);
    }
  }
    
  return result;
}

PImage scharr(PImage img) {
  float[][] vKernel = {{ 3,0,-3 },
                        { 10, 0, -10 },
                        { 3,0,-3 }};
                        
  float[][] hKernel = {{ 3,10,3},
                        { 0,0,0},
                        { -3, -10, -3 } }; 
  PImage result = createImage(img.width, img.height, ALPHA);
  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }
  float max=0;
  float[] sum_h = new float[img.width * img.height];
  float[] sum_v = new float[img.width * img.height];
  float[] buffer = new float[img.width * img.height];
  
  sum_h = calculateSums(img, hKernel);
  sum_v = calculateSums(img, vKernel);
  for (int i = 0; i < img.width * img.height; i++) {
    buffer[i] = sqrt(sum_h[i] * sum_h[i] + sum_v[i] * sum_v[i]);
    if (buffer[i] > max) max = buffer[i];
  }
  
  for (int y = 1; y < img.height - 1; y++) { // Skip top and bottom edges
    for (int x = 1; x < img.width - 1; x++) { // Skip left and right
      int val = (int) ((buffer[y * img.width + x] / max) * 255);
      result.pixels[y * img.width + x] = color(val);
    }
  }
  return result;
}

float[] calculateSums(PImage img, float[][] kernel) {
  float[] result = new float[img.width * img.height];
  
  int n = kernel.length;
  
  for (int x = 1; x < img.width - 1; x++) {
    for (int y = 1; y < img.height - 1; y++) {
      float pixel = 0;
      for (int i = -n/2; i <= n/2; i++) {
        for (int j = -n/2; j <= n/2; j++) {
          pixel += kernel[n/2+i][n/2+j] * brightness(img.pixels[(y+i)*img.width + (x+j)]);
        }
      }
      result[y*img.width + x] = pixel;
    }
  }
    
  return result;
}
