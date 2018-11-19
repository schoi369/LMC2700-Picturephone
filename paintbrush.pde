void setup() {
  size(800,600);
}

float thickness = 1;
float max = 7.5;
color brushColor = color(0);

void draw() {
  if (mousePressed) {
    stroke(brushColor);
    if (thickness < max) {
      strokeWeight(thickness);
      line(mouseX, mouseY, pmouseX, pmouseY); 
      thickness = thickness+0.25;
    } else {
      line(mouseX, mouseY, pmouseX, pmouseY);
      strokeWeight(max);
    }
  }
}

void mouseReleased() { 
  thickness = 1;
  strokeWeight(thickness);
}
