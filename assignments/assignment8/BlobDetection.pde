import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;

class BlobDetection {
  
  PImage findConnectedComponents(PImage input, boolean onlyBiggest) {
    // First pass: label the pixels and store labels' equivalences
    int [] labels = new int [input.width*input.height];
    List<TreeSet<Integer>> labelsEquivalences = new ArrayList<TreeSet<Integer>>();
    int currentLabel = -1;
    
    for (int i = 0; i < labels.length; i++) {
      labels[i] = Integer.MAX_VALUE;
    }
    
    for (int x = 0; x < input.width; x++) {
      for (int y = 0; y < input.height; y++) {
        if (brightness(input.pixels[x + y*input.width]) == 1) {
          List<Integer> neighbors = new ArrayList();
          neighbors.add(currentLabel + 1);
          if (isInBound(x-1, y-1, input.width, input.height)) {
            neighbors.add(labels[x-1 + (y-1)*input.width]);
          }
          if (isInBound(x, y-1, input.width, input.height)) {
            neighbors.add(labels[x + (y-1)*input.width]);
          }
          if (isInBound(x+1, y-1, input.width, input.height)) {
            neighbors.add(labels[x+1 + (y-1)*input.width]);
          }
          if (isInBound(x-1, y, input.width, input.height)) {
            neighbors.add(labels[x-1 + y*input.width]);
          }
          int minLabel = currentLabel + 1;
          for (int i = 0; i < neighbors.size(); i++) {
            if (neighbors.get(i) == Integer.MAX_VALUE) continue;
            if (neighbors.get(i) < minLabel) minLabel = neighbors.get(i);
            if (neighbors.get(i) >= labelsEquivalences.size())
              labelsEquivalences.add(new TreeSet(neighbors));
            else labelsEquivalences.get(neighbors.get(i)).addAll(neighbors);
          }
          currentLabel = max(minLabel, currentLabel);
          labels[x + y*input.width] = minLabel;
        }
      }
    }
    
    // Second pass: re-label the pixels by their equivalent class
    // if onlyBiggest==true, count the number of pixels for each label
    
    List<Integer> sizes = new ArrayList();
    for (int i = 0; i < input.width * input.height; i++) {
      if (labels[i] != Integer.MAX_VALUE) {
        int label = labelsEquivalences.get(labels[i]).first();
        if (sizes.size() < label) sizes.add(1);
        else sizes.set(label, sizes.get(label) + 1);
        labels[i] = label;
      }
    }
     
    // Finally:
    // if onlyBiggest==false, output an image with each blob colored in one uniform color
    // if onlyBiggest==true, output an image with the biggest blob in white and others in black
    
    int fattestLabel = 0;
    if (onlyBiggest) {
      for (int i = 0; i < sizes.size(); i++)
        if (sizes.get(i) > fattestLabel) fattestLabel = sizes.get(i);
    }
    
    PImage result = createImage(input.width, input.height, ALPHA);
    for (int i = 0; i < input.width * input.height; i++) {
      if (labels[i] == Integer.MAX_VALUE) result.pixels[i] = color(0);
      else {
        if (onlyBiggest) result.pixels[i] = labels[i] == fattestLabel ? color(255) : color(0);
        else {
          int hue = (int) map(labels[i], 0, sizes.size(), 0, 255);
          result.pixels[i] = color(hue, 200, 200);
        }
      }
    }
    
    return result;
  }
  
  boolean isInBound(int x, int y, int sizex, int sizey) {
    return 0 <= x && x < sizex && 0 <= y && y < sizey;
  } 
}
