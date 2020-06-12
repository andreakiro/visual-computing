import processing.video.*;

class ImageProcessing extends PApplet {
  PImage img;
  PApplet parent;
  PVector rotation = new PVector(0, 0, 0);
  TwoDThreeD tdtd;
  float sampleRate = frameRate;
  OpenCV opencv;
  KalmanFilter2D kf1;
  KalmanFilter2D kf2;
  KalmanFilter2D kf3;
  KalmanFilter2D kf4;
  List<PVector> corners;
  
  PGraphics surf;
  
  //TDOD delete
  PImage img2;
  PImage img3;
  PImage img4;
  Movie vid;
  
  HoughTransform hough = new HoughTransform();
  BlobDetection blobDetection = new BlobDetection();
  QuadGraph quadGraph = new QuadGraph();
  float[][] gaussianblurkernel = {{ 9, 12, 9 },
                        { 12, 15, 12 },
                        { 9, 12, 9 }};
  /*                 
  float[][] gaussianblurkernelStronger = 
    {{ 0.000874, 0.006976, 0.01386, 0.006976, 0.000874 },
     { 0.006976, 0.0557, 0.110656, 0.0557, 0.006976 },
     { 0.01386, 0.110656, 0.219833, 0.110656, 0.01386 },
     { 0.006976, 0.0557, 0.110656, 0.0557, 0.006976 },
     { 0.000874, 0.006976, 0.01386, 0.006976, 0.000874 }};
  */                  
  int imgWidth = 500;
  int imgHeight = 300;
  
  ImageProcessing(PApplet p) {
    this.parent = p;
  }
  
  void settings() {
    //size(3 * imgWidth, 1 * imgHeight);
    size(960, 500);
  }
  
  void setup() {
    opencv = new OpenCV(this, 100, 100);
    tdtd = new TwoDThreeD(width, height, sampleRate);
    kf1 = new KalmanFilter2D();
    kf2 = new KalmanFilter2D();
    kf3 = new KalmanFilter2D();
    kf4 = new KalmanFilter2D();
    corners = new ArrayList();
    for(int i = 0; i < 4; ++i) corners.add(new PVector(width / 2, height / 2));
    
    surf = createGraphics(width, height);
    
    //img = loadImage("board1.jpg");
    vid = new Movie(parent, "testvideo.avi");
    vid.loop();
    
    //imgWidth = 500;
    //imgHeight = 300;
    
    //TDOD delete
    /*
    img2 = loadImage("board2.jpg");
    img3 = loadImage("board3.jpg");
    img4 = loadImage("board4.jpg");
    */
   
    //noLoop();
  }
  
  void draw() { 
    if (vid.available() == true) {
      vid.read(); 
    }
    img = vid.get();
    
    surf.beginDraw();
    surf.background(255);

    // Process
    //img.resize(480, 250);
    int minHue = 20;
    int maxHue = 144;
    int minSat = 22;
    int maxSat = 255;
    int minBri = 15;
    int maxBri = 250;
    if (img.width != 0 && img.height != 0) img.resize(480, 250);
    PImage colorThreshold = thresholdHSB(img, minHue, maxHue, minSat, maxSat, minBri, maxBri);
    PImage blurring = convolute(colorThreshold, gaussianblurkernel);
    PImage blob = blobDetection.findConnectedComponents(blurring, true);
    //PImage blurringBlob = convolute(blob, gaussianblurkernelStronger);
    PImage edges = scharr(blob);
    PImage filter = binaryThreshold(edges, 100);
    //filter.resize(imgWidth, imgHeight);
    List<PVector> lines = hough.hough(filter, 8);
    // Draw complete processing
    
    //image(img, 0, 0, imgWidth, imgHeight);
    surf.image(img, 0, 0);
    surf.image(filter, 0, img.height);
    hough.drawLines(lines, filter, surf);
    if (lines != null) {
      print("Nbr lines: "+ lines.size()+ "\n");
  
      fill(color(0,0, 200));
      List<PVector> detectedCorners = quadGraph.findBestQuad(lines, img.width, img.height, 27500, 12500, false);
      
      if (detectedCorners.isEmpty() || frameCount % 2 != 0) {
        corners.set(0, kf1.predict_and_correct(corners.get(0)));
        corners.set(1, kf2.predict_and_correct(corners.get(1)));
        corners.set(2, kf3.predict_and_correct(corners.get(2)));
        corners.set(3, kf4.predict_and_correct(corners.get(3)));
      } else {
        corners.set(0, kf1.predict_and_correct(detectedCorners.get(0)));
        corners.set(1, kf2.predict_and_correct(detectedCorners.get(1)));
        corners.set(2, kf3.predict_and_correct(detectedCorners.get(2)));
        corners.set(3, kf4.predict_and_correct(detectedCorners.get(3)));
      }
      
      for(PVector p: corners) {
        surf.circle(p.x, p.y, 30);
      }
      
      for(PVector c : corners) {
        c.z = 1;
      }
      rotation = tdtd.get3DRotations(corners);
    }
    
    surf.endDraw();
    image(surf, 0, 0);
    
    // test
    //image(blurring, imgWidth, imgHeight, imgWidth, imgHeight);
    
    
    // Draw result of edge detection
    // image(filter, 1 * imgWidth, 0, imgWidth, imgHeight);
    
    // Draw result of blob detection
    //image(blurringBlob, 2 * imgWidth, 0, imgWidth, imgHeight);
    
    
  
    
    /*
    PImage colorThreshold2 = thresholdHSB(img2, minHue, maxHue, minSat, maxSat, minBri, maxBri);
    PImage blurring2 = convolute(colorThreshold2, gaussianblurkernel);
    PImage blob2 = blobDetection.findConnectedComponents(blurring2, true);
    PImage edges2 = scharr(blob2);
    
    PImage colorThreshold3 = thresholdHSB(img3, minHue, maxHue, minSat, maxSat, minBri, maxBri);
    PImage blurring3 = convolute(colorThreshold3, gaussianblurkernel);
    PImage blob3 = blobDetection.findConnectedComponents(blurring3, true);
    PImage edges3 = scharr(blob3);
    
    PImage colorThreshold4 = thresholdHSB(img4, minHue, maxHue, minSat, maxSat, minBri, maxBri);
    PImage blurring4 = convolute(colorThreshold4, gaussianblurkernel);
    PImage blob4 = blobDetection.findConnectedComponents(blurring4, true);
    PImage edges4 = scharr(blob4);
    
    image(img2, 0, imgHeight, imgWidth, imgHeight);
    image(colorThreshold2, imgWidth, imgHeight, imgWidth, imgHeight);
    image(edges2, 2 * imgWidth, imgHeight, imgWidth, imgHeight);
    
    image(img3, 0, 2*imgHeight,imgWidth, imgHeight);
    image(colorThreshold3, imgWidth, 2*imgHeight, imgWidth, imgHeight);
    image(edges3, 2 * imgWidth, 2*imgHeight, imgWidth, imgHeight);
    
    image(img4, 0, 3* imgHeight, imgWidth, imgHeight);
    image(colorThreshold4, imgWidth, 3*imgHeight, imgWidth, imgHeight);
    image(edges4, 2 * imgWidth, 3*imgHeight, imgWidth, imgHeight);
    */
    
  }
  
  PVector getRotation() {
    return rotation;
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
    
    for (int x = kernel.length / 2; x < img.width - kernel.length /2; x++) {
      for (int y = kernel.length / 2; y < img.height - kernel.length/2 ; y++) {
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
}
