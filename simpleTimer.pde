PFont font;
String time = "010";
int t;
int interval = 10;

void setup()
{
  size(300, 300);
  font = createFont("Arial", 30);
  background(255);
  fill(0);
}

void draw()
{
    background(255);
   
    t = interval-int(millis()/1000);
    time = nf(t , 3);
    if(t == 0){
      println("GAME OVER");
    interval+=10;}

   text(time, width/2, height/2);
}
