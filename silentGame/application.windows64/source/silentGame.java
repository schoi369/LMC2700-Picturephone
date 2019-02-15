import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Random; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class silentGame extends PApplet {


//==================================

//Constants
final int MAX_PLAYERS = 12;
final int TIME_IN_SEC = 30;
final float BRUSH_MAX = 7.5f;
final int BRUSH_COLOR = color(0);

//brush
float brushThickness;

//state value
State state;

//for image display
PImage first;
PImage current;
PImage temp;

//game stuff
int bgColor;
int iteration;
String word;
String origWord;
boolean mouseDownFlag;
String guessTxt;

//timer
int begin; 
int duration;
int time;

//Font
PFont font;

//Logo
PImage logo;

//file reader stuff
String[] words;


public void setup() {
  
  frameRate(120);
  
  font = loadFont("NP48.vlw");
  logo = loadImage("logo.png");
  textFont(font, 48);
  
  words = loadStrings("nounlist.txt");
  
  goToStateHome();
}


public void draw() {
  
  
  switch (state) {
    case HOME:
      stateHome();
      break;
    case INSTRUCTIONS:
      stateInstructions();
      break;
    case START:
      stateStart();
      break;
    case DRAW:
      stateDraw();
      break;
    case GUESS:
      stateGuess();
      break;
    case END:
      stateEnd();
      break;
  }
  
}



public void goToStateHome() {
  state = State.HOME;
  
  bgColor = color(241,196,15);
  mouseDownFlag = false;
  iteration = 0;
  origWord = getRandomWord();
  word = origWord;
  
}

public void stateHome() {
  
  background(bgColor);

  image(logo, width / 2 + -430, height / 2 + -141);
  
  textSize(48);
  fill(0);
  text("START", width / 2 - 70, height / 2 + 120);
  
  textSize(48);
  fill(0);
  text("INSTRUCTIONS", width / 2 - 160, height / 2 + 200);
  
  
  if (mousePressed && mouseButton == LEFT && !mouseDownFlag) {
    if (mouseIntersection(width / 2 - 70, height / 2 + 80, 158, 45)) {
      goToStateStart();
    }
    else if (mouseIntersection(width / 2 - 160, height / 2 + 160, 158 * 2 + 30, 45)) {
      goToStateInstructions();
    }
    mouseDownFlag = true;
  }
  
}


public void goToStateInstructions() {
    state = State.INSTRUCTIONS;
    
    bgColor = color(230,126,34);
    
}

public void stateInstructions() {
  
  background(bgColor);
  
  fill(255);
  textSize(32);
  String instructionsAT3 = "This game requires a minimum of three players.\nPlayer One will view a random noun and"
  + "\n" + "will attempt to draw a picture that represents that\nnoun within 30 seconds." 
  + "\n" + "\n" + "DO NOT USE WORDS IN YOUR DRAWING.\n\nPlayer Two will see the picture that Player One drew" 
  + "\n" + "and type what they think the word is."
  + "\n" + "Clicking the 'done' button will allow you to see the"
  + "\n" + "original word, Player One’s drawing,\nand Player Two’s guess.";

  text(instructionsAT3, (width / 2) - 322, (height / 2) - 268);
  text("hit BACKSPACE to go back", width / 2, (height / 2) + 315);
  
}


public void goToStateStart() {
  
    bgColor = color(142,68,173);
    
    iteration++;
    stroke(1);
    state = State.START;
}


public void stateStart() {
  
  background(bgColor);

  fill(255);
  textSize(32);
  text("pass computer to player " + (iteration), width / 2, height / 2);
  text("click READY to begin", width / 2, height / 2 + 40);
  
  stroke(236, 240, 241);
  fill(bgColor);
  strokeWeight(1);
  rect(width / 2, height / 2 + 50, 88, 40);
  fill(255);
  text("READY", width / 2 + 4, height / 2 + 82);
  
  
  if (iteration % 2 == 0 && iteration >= 4) {
    text("click DONE to end", width / 2, height / 2 + 140);
    fill(bgColor);
    rect(width / 2, height / 2 + 150, 88, 40);
    fill(255);
    text("DONE", width / 2 + 9, height / 2 + 181);
    
  }
  
  if (mousePressed && mouseButton == LEFT && mouseIntersection(width / 2, height / 2 + 50, 88, 40)) {
    if (iteration % 2 == 0) {
      goToStateGuess();
    } else {
      goToStateDraw();
    }
  }
  else if (mousePressed && mouseButton == LEFT && mouseIntersection(width / 2, height / 2 + 150, 88, 40) && iteration >= 4 && iteration % 2 == 0) {
      goToStateEnd();
  }
}

public void goToStateDraw() {
  
  bgColor = color(231, 76, 60);
  
  background(bgColor);
   
  fill(255);
  textSize(24);
  text("DRAW:  " + word, width / 2 - 80, 36);
  text("or press ENTER to be done", width - 300, height - 20);
  text("RClick to clear canvas", 50, height - 20);
  
  fill(255);
  rect(50,50, width - 100, height - 100);
   
  begin = millis();
  duration = TIME_IN_SEC;
  time = TIME_IN_SEC;
  
  brushThickness = 1;
  
  state = State.DRAW;
}


public void stateDraw() {
  
  noStroke();
  fill(0);
  if (mousePressed && mouseButton == LEFT && mouseIntersection(60,60, width - 110, height - 110)) {
    paint();
  }
  if (mousePressed && mouseButton == RIGHT && mouseIntersection(60,60, width - 110, height - 110)) {
    fill(255);
   rect(50,50, width - 100, height - 100);
  }
  
  noStroke();
  fill(bgColor);
  rect(width / 2 + width / 4  + 120, 10, 40, 40);
  fill(255);
  textSize(24);
  text(time, width / 2 + width / 4 + 120, 36);
  
  updateTimer();
  
}


public void goToStateGuess() {
  
  brushThickness = 1;
  
  bgColor = color(26, 188, 156);
  
  guessTxt = "your guess here";
  temp = current;
  temp.resize(0,width/3 - 20);
  
  state = State.GUESS;
}

public void stateGuess() {
  
  background(bgColor);
  
  image(temp, 0, height/2 - temp.height / 2);
  
  fill(bgColor);
  noStroke();
  rect(width/2,0, width/2, height);
  textSize(24);
  fill(0);
  text("What did you see?", width/2, height/2);
  fill(color(255/2,255/2,255/2));
  text("[ " + guessTxt + " ]", width/2 + -1, height/2 + 40);
}

public void goToStateEnd() {
  
  bgColor = color(52,152,219);
  
  state = State.END;
}

public void stateEnd() {
  
  background(bgColor);
  
  textSize(32);
  text("Original word was: " + origWord, 20, height/2 - temp.height / 2 - 40);
  text("Last guess was: " + word, width - temp.width + 20, height/2 - temp.height / 2 - 40);
  
  PImage temp = first;
  temp.resize(0,width/3 - 20);
  image(temp, 0, height/2 - temp.height / 2);
  
  temp = current;
  temp.resize(0,width/3 - 20);
  image(temp, width - temp.width, height/2 - temp.height / 2);
  
  textSize(48);
  text("Press enter to restart", width / 2 - 218, height - height / 2 + 306);
  
}




public boolean mouseIntersection(float rx, float ry, float rw, float rh) {
  return mouseX >= rx &&         // right of the left edge AND
    mouseX <= rx + rw &&    // left of the right edge AND
    mouseY > ry &&         // below the top AND
    mouseY <= ry + rh;
}

public void updateTimer() {
  if (time > 0){  
    time = duration - (millis() - begin)/1000;
  } else {
    fill(bgColor);
    rect(0,0,width,45);
    rect(0,height - 45,width,45);
    current = get();
    if (iteration == 1) {
      first = current;
    }
    goToStateStart();
  }
}


public void paint() {
  if (mousePressed) {
    stroke(BRUSH_COLOR);
    if (brushThickness < BRUSH_MAX) {
      strokeWeight(brushThickness);
      line(mouseX, mouseY, pmouseX, pmouseY); 
      brushThickness = brushThickness + 0.25f;
    } else {
      line(mouseX, mouseY, pmouseX, pmouseY);
      strokeWeight(BRUSH_MAX);
    }
  }
}


public void mouseReleased() {
  
  if (state == State.DRAW) {
    brushThickness = 1;
    strokeWeight(brushThickness);
  }
  
  mouseDownFlag = false;
}


public void keyPressed() {
  
  if (state == State.END && keyCode == ENTER) {
    goToStateHome();
    return;
  }
  
  if (state == State.INSTRUCTIONS && keyCode == BACKSPACE) {
    goToStateHome();
    return;
  }
  
  if (state == State.DRAW && keyCode == ENTER) {
    fill(bgColor);
    rect(0,0,width,45);
    rect(0,height - 45,width,45);
    current = get();
    if (iteration == 1) {
      first = current;
    }
    goToStateStart();
    return;
  }
  
  if (state != State.GUESS) {
    return;
  }
  
  if (keyCode == BACKSPACE) {
    if (guessTxt.length() > 0) {
      guessTxt = guessTxt.substring(0, guessTxt.length()-1);
    }
  } else if (keyCode == DELETE) {
    guessTxt = "";
  } else if (keyCode == ENTER) {
    word = guessTxt;
    goToStateStart();
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && guessTxt.length() < 20) {
    guessTxt = guessTxt + key;
  }
}


public String getRandomWord() {
  return words[new Random().nextInt(words.length)];
}
enum State {
  
  HOME, INSTRUCTIONS, START, DRAW, GUESS, END;
  
}
  public void settings() {  size(1200, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "silentGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
