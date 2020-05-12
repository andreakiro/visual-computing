PImage img;
int imgWidth = 400;
int imgHeight = 300;

HoughTransform hough = new HoughTransform();
BlobDetection blobDetection = new BlobDetection();
QuadGraph quadGraph = new QuadGraph();
float[][] gaussianblurkernel = {{ 9, 12, 9 },
                      { 12, 15, 12 },
                      { 9, 12, 9 }};
                      
void settings() {
  size(3 * imgWidth, 1 * imgHeight);
}

void setup() {
  img = loadImage("board1.jpg");
  noLoop();
}

void draw() {   
  
  int minHue = 70;
  int maxHue = 143;
  int minSat = 55;
  int maxSat = 255;
  int minBri = 20;
  int maxBri = 190;
  // Process            
  PImage colorThreshold = thresholdHSB(img, minHue, maxHue, minSat, maxSat, minBri, maxBri);
  PImage blurring = convolute(colorThreshold, gaussianblurkernel);
  PImage blob = blobDetection.findConnectedComponents(blurring, true);
  PImage edges = scharr(blob);
  PImage filter = binaryThreshold(edges, 100);
  
  filter.resize(imgWidth, imgHeight);
  List<PVector> lines = hough.hough(filter, 6);
  
  // Draw complete processing
  image(img, 0, 0, imgWidth, imgHeight);
  hough.drawLines(lines, filter);
  if (lines != null) {
    for(PVector p: quadGraph.findBestQuad(lines, imgWidth, imgHeight, 500000, 5000, false)) {
      circle(p.x, p.y, 10);
    }
  }
  
  // Draw result of edge detection
   image(edges, 1 * imgWidth, 0, imgWidth, imgHeight);
  
  // Draw result of blob detection
  image(blob, 2 * imgWidth, 0, imgWidth, imgHeight);
}

PImage binaryThreshold(PImage img, int threshold) {
  PImage result = createImage(img.width, img.height, RGB); 
  for(int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = brightness(img.pixels[i]) > threshold ? color(255) : color(0);
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
