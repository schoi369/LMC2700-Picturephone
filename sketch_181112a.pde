final int MAX_PLAYERS = 12;
final int TIME_IN_SEC = 10;

State state;

PImage first;
PImage current;

color bgColor;
int iteration;
String word;
String origWord;
boolean mouseDownFlag;
String guessTxt;

int begin; 
int duration;
int time;

void setup() {
  size(1200, 800);
  frameRate(120);
  
  goToStateHome();
}


void draw() {
  
  
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



void goToStateHome() {
  state = State.HOME;
  
  bgColor = color(255,255/2,0);
  background(bgColor);
  
  
  mouseDownFlag = false;
  
  iteration = 0;
  origWord = "horse";
  word = origWord;
  
}

void stateHome() {
 
  fill(bgColor);
  noStroke();
  rect(width / 2 - 70, height / 2 - 120, 158, 45);
  textSize(48);
  fill(0);
  text("START", width / 2 - 70, height / 2 - 80);
  
  if (mousePressed && mouseButton == LEFT && !mouseDownFlag) {
    if (mouseIntersection(width / 2 - 70, height / 2 - 120, 158, 45)) {
      goToStateStart();
    }
    mouseDownFlag = true;
  }
  
}


void goToStateInstructions() {
    state = State.INSTRUCTIONS;
    
    bgColor = color(255/2,40,255);
    background(bgColor);
    
    fill(0);
    textSize(32);
    
    text("instructions go here", width / 2, height / 2);
    text("click back to go back", width / 2, height / 2 + 40);
    
}

void stateInstructions() {
  
  stroke(0);
  fill(bgColor);
  rect(width / 2, height / 2 + 50, 88, 40);
  fill(0);
  text("back", width / 2, height / 2 + 80);
  
  if (mousePressed && mouseButton == LEFT && mouseIntersection(width / 2, height / 2 + 50, 88, 40)) {
    goToStateHome();
  }
  
}


void goToStateStart() {
    bgColor = color(255/2,255/2,255/2);
    background(bgColor);

    fill(0);
    textSize(32);
    text("pass computer to player " + (iteration + 1), width / 2, height / 2);
    text("click ready to begin", width / 2, height / 2 + 40);
    text("click done to end", width / 2, height / 2 + 140);
    
    iteration++;
    
    state = State.START;
}

void stateStart() {
  stroke(0);
  fill(bgColor);
  rect(width / 2, height / 2 + 50, 88, 40);
  fill(0);
  text("ready", width / 2, height / 2 + 80);
  stroke(0);
  fill(bgColor);
  rect(width / 2, height / 2 + 150, 88, 40);
  fill(0);
  text("done", width / 2, height / 2 + 180);
  
  if (mousePressed && mouseButton == LEFT && mouseIntersection(width / 2, height / 2 + 50, 88, 40)) {
    if (iteration % 2 == 0) {
      goToStateGuess();
    } else {
      goToStateDraw();
    }
  }
  else if (mousePressed && mouseButton == LEFT && mouseIntersection(width / 2, height / 2 + 150, 88, 40) && iteration >= 4) {
    goToStateEnd();
  }
}

void goToStateDraw() {
  bgColor = color(3*255/4,0,0);
  background(bgColor);
   
   fill(0);
   textSize(24);
   
   text("draw a:  " + word, width / 2 - 40, 40);
   
   fill(255);
   rect(50,50, width - 100, height - 100);
   
   begin = millis();
   duration = TIME_IN_SEC;
   time = TIME_IN_SEC;
  
   state = State.DRAW;
}

void stateDraw() {
  noStroke();
  fill(0);
  if (mousePressed && mouseButton == LEFT && mouseIntersection(60,60, width - 110, height - 110)) {
    ellipse(mouseX, mouseY, 20, 20);
  }
  if (mousePressed && mouseButton == RIGHT && mouseIntersection(60,60, width - 110, height - 110)) {
    fill(255);
   rect(50,50, width - 100, height - 100);
  }
  
  fill(bgColor);
  rect(width / 2 + width / 4, 10, 50, 40);
  fill(0);
  textSize(24);
  text(time, width / 2 + width / 4, 40);
  
  updateTimer();
  
}

void goToStateGuess() {
  bgColor = color(0,3*255/4,0);
  background(bgColor);
  guessTxt = "your guess here";
  PImage temp = current;
  temp.resize(0,width/3 - 20);
  image(temp, 0, height/2 - temp.height / 2);
  state = State.GUESS;
}

void stateGuess() {
  fill(bgColor);
  noStroke();
  rect(width/2,0, width/2, height);
  textSize(24);
  fill(0);
  text("What did you see?", width/2, height/2);
  fill(color(255/2,255/2,255/2));
  text("[ " + guessTxt + " ]", width/2 + 40, height/2 + 40);
}

void goToStateEnd() {
  bgColor = color(255,0,0);
  background(bgColor);
  
  textSize(32);
  text("orig word was: " + origWord,0,0);
  
  PImage temp = first;
  temp.resize(0,width/3 - 20);
  image(temp, 0, height/2 - temp.height / 2);
  
  temp = current;
  temp.resize(0,width/3 - 20);
  image(temp, width - temp.width, height/2 - temp.height / 2);
  
  state = State.END;
}

void stateEnd() {
}




boolean mouseIntersection(float rx, float ry, float rw, float rh) {
  return mouseX >= rx &&         // right of the left edge AND
    mouseX <= rx + rw &&    // left of the right edge AND
    mouseY > ry &&         // below the top AND
    mouseY <= ry + rh;
}

void updateTimer() {
  if (time > 0){  
    time = duration - (millis() - begin)/1000;
  } else {
    fill(bgColor);
    rect(0,0,width,45);
    current = get();
    if (iteration == 1) {
      first = current;
    }
    goToStateStart();
  }
}


void mouseReleased() {
  mouseDownFlag = false;
}


void keyPressed() {
  
  if (state == State.END) {
    goToStateHome();
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
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
    guessTxt = guessTxt + key;
  }
}
