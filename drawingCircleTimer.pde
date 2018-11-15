Timer timer;

void setup(){
  noStroke();

  //textSize(12);
  timer = new Timer(this,"onTimerTick","onTimerComplete");
  // start a timer for 10 seconds (10 * 1000 ms) with a tick every second (1000 ms) 
  timer.reset(10 * 1000,1000);
}

void draw(){
  background(0);
  drawTimer();
  //rect(0,0,timer.progress * width,height);
  //blendMode(DIFFERENCE);
  text("'1' = reset"+
     "\n'2' = cancel"+
     "\n'3' = pause"+
     "\n'4' = resume"+
     "\n"+(int)(timer.progress * 100)+"%",10,15);
}

void drawTimer(){
  pushStyle();
  noFill();
  stroke(255);
  strokeWeight(3);
  ellipse(450, 54,90,90);
  fill(192,0,0);
  noStroke();
  pushMatrix();
  translate(50,50);
  rotate(radians(-90));
  arc(0, 0, 90, 90, 0, timer.progress * TWO_PI, PIE);
  popMatrix();
  popStyle();
}

void keyPressed(){
  if(key == '1'){
    timer.reset(3000,10);
  }
  if(key == '2'){
    timer.cancel();
  }
  if(key == '3'){
    timer.pause();
  }
  if(key == '4'){
    timer.resume();
  }
}

public void onTimerTick(){
  println("tick",(int)(timer.progress * 100),"%");
}

public void onTimerComplete(){
  println("complete");
}

import java.lang.reflect.Method;
// utility timer class
class Timer implements Runnable{
  // is the timer still ticking or on hold ?
  boolean isPaused = false;
  // is the thread still running ?
  boolean isRunning = true;

  // how close are we to completion (0.0 = 0 %, 1.0 = 100%)
  float progress = 0.0;
  // a reference to the time in ms since the start of the timer or reset
  long now;
  // default duration
  long duration = 10000;
  // default tick interval
  long tickInterval = 1000;
  // time at pause
  long pauseTime;

  // reference to the main sketch
  PApplet parent;
  // function to call on each tick
  Method onTick;
  // function to call when timer has completed
  Method onComplete;

  Timer(PApplet parent,String onTickFunctionName,String onCompleteFunctionName){
    this.parent = parent;
    // try to store a reference to the tick function based on its name
    try{
      onTick = parent.getClass().getMethod(onTickFunctionName);
    }catch(Exception e){
      e.printStackTrace();
    }

    // try to store a reference to the complete function based on its name
    try{
      onComplete = parent.getClass().getMethod(onCompleteFunctionName);
    }catch(Exception e){
      e.printStackTrace();
    }
    // auto-pause
    isPaused = true;
    // get millis since the start of the program
    now = System.currentTimeMillis();
    // start the thread (processes run())
    new Thread(this).start();
  }

  // start a new stop watch with new settings
  void reset(long newDuration,long newInterval){
    duration = newDuration;
    tickInterval = newInterval;
    now = System.currentTimeMillis();
    progress = 0;
    isPaused = false;
    println("resetting for ",newDuration,"ticking every",newInterval);
  } 

  // cancel an existing timer
  void cancel(){
    isPaused = true;
    progress = 0.0;
  }

  // stop this thread
  void stop(){
    isRunning = false;
  }

  void pause(){
    isPaused = true;
    pauseTime = (System.currentTimeMillis() - now); 
  }
  void resume(){
    now = System.currentTimeMillis() - pauseTime;
    isPaused = false;
  }

  public void run(){
    while(isRunning){

      try{
          //sleep per tick interval
          Thread.sleep(tickInterval);
          // if we're still going
          if(!isPaused){
            // get the current millis
            final long millis = System.currentTimeMillis();
            // update how far we're into this duration
            progress = ((millis - now) / (float)duration);
            // call the tick function
            if(onTick != null){
              try{
                onTick.invoke(parent);
              }catch(Exception e){
                e.printStackTrace();
              }
            }
            // if we've made, pause the timer and call on complete
            if(progress >= 1.0){
              isPaused = true;
              // call on complete
              if(onComplete != null){
              try{
                  onComplete.invoke(parent);
                }catch(Exception e){
                  e.printStackTrace();
                }
              }
            }
          }
        }catch(InterruptedException e){
          println(e.getMessage());
        }
      }
    }

}
