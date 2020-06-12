import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;
import java.util.Map;
import java.util.Random;

class BlobDetection {
  
  PImage findConnectedComponents(PImage input, boolean onlyBiggest) {
    // First pass: label the pixels and store labels' equivalences
    int [] labels = new int [input.width*input.height];
    List<TreeSet<Integer>> labelsEquivalences = new ArrayList<TreeSet<Integer>>();
    int nextBlobLabel = -1;
    
    /*
    for (int i = 0; i < labels.length; i++) { // CHANGED
      labels[i] = Integer.MAX_VALUE;
    }
    */
    for (int y = 0; y < input.height; y++) {
      for (int x = 0; x < input.width; x++) {
        labels[x + y*input.width] = Integer.MAX_VALUE;
        if (brightness(input.pixels[x + y*input.width]) == 255) {
          List<Integer> neighbors = new ArrayList();
          if (isInBoundAndWhite(x-1, y-1, input)) {
            neighbors.add(labels[x-1 + (y-1)*input.width]);
          }
          if (isInBoundAndWhite(x, y-1, input)) {
            neighbors.add(labels[x + (y-1)*input.width]);
          }
          if (isInBoundAndWhite(x+1, y-1, input)) {
            neighbors.add(labels[x+1 + (y-1)*input.width]);
          }
          if (isInBoundAndWhite(x-1, y, input)) {
            neighbors.add(labels[x-1 + y*input.width]);
          }
          
          if (neighbors.isEmpty()) {
            nextBlobLabel += 1;
            labels[x + y*input.width] = nextBlobLabel;
            
            TreeSet ts = new TreeSet();
            ts.add(nextBlobLabel);
            labelsEquivalences.add(ts);
          } else {
            int minLabel = nextBlobLabel + 1;
            for (int nei : neighbors) { // CHANGED
              if (nei < minLabel) minLabel = nei;
            }
            labels[x + y*input.width] = minLabel;
            
            for (int i = 0; i < neighbors.size(); i++) {
              for (int j = 0; j < neighbors.size(); j++) {
                //labelsEquivalences.get(neighbors.get(i)).addAll(labelsEquivalences.get(neighbors.get(j))); // CHANGED
                labelsEquivalences.get(neighbors.get(i)).add(labelsEquivalences.get(neighbors.get(j)).first());

              }
            }
          }
        }
      }
    }
    
    // Second pass: re-label the pixels by their equivalent class
    // if onlyBiggest==true, count the number of pixels for each label
    
    Map<Integer, Integer> sizes = new HashMap();
    for (int i = 0; i < input.width * input.height; i++) {
      if (labels[i] != Integer.MAX_VALUE) {
        int label = labelsEquivalences.get(labels[i]).first();
        int s = sizes.getOrDefault(label, 0);
        sizes.put(label, s + 1);
        labels[i] = label;
      }
    }
     
    // Finally:
    // if onlyBiggest==false, output an image with each blob colored in one uniform color
    // if onlyBiggest==true, output an image with the biggest blob in white and others in black
    int fattestLabel = 0;
    Map<Integer, List<Integer>> labelColors = new HashMap();
    if (onlyBiggest) {
      for (Integer i: sizes.keySet()) {
        if (sizes.get(i) > sizes.get(fattestLabel)) fattestLabel = i;
      }
    } else {
      Random r = new Random();
      for (Integer i: sizes.keySet()) {
        List<Integer> c = new ArrayList();
        c.add(r.nextInt(255));
        c.add(r.nextInt(150) + 50);
        c.add(r.nextInt(150) + 50);
        labelColors.put(i, c);
      }
    }
    
    PImage result = createImage(input.width, input.height, ALPHA);
    for (int i = 0; i < input.width * input.height; i++) {
      if (labels[i] == Integer.MAX_VALUE) result.pixels[i] = color(0);
      else {
        if (onlyBiggest) result.pixels[i] = labels[i] == fattestLabel ? color(255) : color(0);
        else {
          List<Integer> l = labelColors.get(labels[i]);
          result.pixels[i] = color(l.get(0), l.get(1), l.get(2));
        }
      }
    }
    
    return result;
  }
  
  boolean isInBoundAndWhite(int x, int y, PImage img) {
    return 0 <= x && x < img.width && 0 <= y && y < img.height && brightness(img.pixels[x + y*img.width]) == 255;
  } 
}
