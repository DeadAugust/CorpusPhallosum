OPC opc;
PImage texture;
Ring rings[];
float smoothX, smoothY;
boolean f = false;

import processing.io.*;

//int[] row = {2,3,4,14,15,17,18,22,23,24,25,27};
int[] row = {4,17,27,22,10,9,11,5,6,13,19,26};
int[] col = {14,15,18,23,24,25,8,7,12,16,20,21};
//int[] col = {5,6,7,8,11,12,13,16,19,20,21,26};
int[][] result = {
  {1,2,3,4,5,6,7,8,9,10,11,12},
  {13,14,15,16,17,18,19,20,21,22,23,24},
  {25,26,27,28,29,30,31,32,33,34,35,36},
  {37,38,39,40,41,42,43,44,45,46,47,48},
  {49,50,51,52,53,54,55,56,57,58,59,60},
  {61,62,63,64,65,66,67,68,69,70,71,72},
  {73,74,75,76,77,78,79,80,81,82,83,84},
  {85,86,87,88,89,90,91,92,93,94,95,96},
  {97,98,99,100,101,102,103,104,105,106,107,108},
  {109,110,111,112,113,114,115,116,117,118,119,120},
  {121,122,123,124,125,126,127,128,129,130,131,132},
  {133,134,135,136,137,138,139,140,141,142,143,144}
}; // I coulda just done result[12][12] huh...

float dildoX;
float dildoY;
long timer = 0;
float a, b, c;
boolean backSwitch = false;
boolean switchBack = true;

//sound
import processing.sound.*;
SoundFile file;
boolean musicFlip = true;
TriOsc triOsc;
Env env;
float attackTime = 0.001;
float sustainTime = 0.004;
float sustainLevel = 0.2;
float releaseTime = 0.2;


void setup()
{
  size(240, 240, P3D);
  colorMode(HSB, 100);
  texture = loadImage("ring.png");
  //frameRate(10);
  timer = millis();

  opc = new OPC(this, "127.0.0.1", 7890);

  /*
  for(int j=7; j>=0; j--) {
    for(int i=0; i<8; i++) {
      opc.ledStrip(i * 12, 12, width * 0.5,
      i * height / 12.0 + height / 24.0, width / 12.0, PI, false);
    }
  }

  for(int i=8; i<12; i++) {
    opc.ledStrip(i * 12, 12, width * 0.5,
    i * height / 12.0 + height / 24.0, width / 12.0, PI, false);
  }
  */

  //manual, whatever. in order from top down
  //strip 7
  opc.ledStrip(84, 12, width * 0.5,
    (0 * height) / 12.0 + (height / 24.0), width / 12.0, PI, false);
  //strip 6
  opc.ledStrip(72, 12, width * 0.5,
    (1.0 * height) / 12.0 + (height / 24.0), width / 12.0, PI, false);
  //strip 5
  opc.ledStrip(60, 12, width * 0.5,
    (2.0 * height) / 12.0 + (height / 24.0), width / 12.0, PI, false);
  //strip 4
  opc.ledStrip(48, 12, width * 0.5,
    (3.0 * height) / 12.0 + (height / 24.0), width / 12.0, PI, false);
  //strip 3
  opc.ledStrip(36, 12, width * 0.5,
    (4.0 * height) / 12.0 + (height / 24.0), width / 12.0, PI, false);
  //strip 2
  opc.ledStrip(24, 12, width * 0.5,
    (5.0 * height) / 12.0 + (height / 24.0), width / 12.0, PI, false);
  //strip 1
  opc.ledStrip(12, 12, width * 0.5,
    (6.0 * height) / 12.0 + (height / 24.0), width / 12.0, PI, false);
  //strip 0
  opc.ledStrip(0, 12, width * 0.5,
    (7.0 * height) / 12.0 + (height / 24.0), width / 12.0, PI, false);
  //strip 8
  opc.ledStrip(96, 12, width * 0.5,
    (11.0 * height) / 12.0 + (height / 24.0), width / 12.0, PI, false);
  //strip 9
  opc.ledStrip(108, 12, width * 0.5,
    (10.0 * height) / 12.0 + (height / 24.0), width / 12.0, PI, false);
  //strip 10
  opc.ledStrip(120, 12, width * 0.5,
    (9.0 * height) / 12.0 + (height / 24.0), width / 12.0, PI, false);
  //strip 11
  opc.ledStrip(132, 12, width * 0.5,
    (8.0 * height) / 12.0 + (height / 24.0), width / 12.0, PI, false);

  // We can have up to 100 rings. They all start out invisible.
  rings = new Ring[100];
  for (int i = 0; i < rings.length; i++) {
    rings[i] = new Ring();
  }

  for (int x=0; x<12; x++){
    GPIO.pinMode(row[x], GPIO.OUTPUT);
    GPIO.digitalWrite(row[x], GPIO.LOW); //flipped from example b/c contact keypad, not break
  }
  for (int x=0; x<12; x++){
    GPIO.pinMode(col[x], GPIO.INPUT);
  }
  file = new SoundFile(this, "ohh.mp3");
  triOsc = new TriOsc(this);
  env = new Env(this);
}

int keyRead(){
  int value = 0;
  for (int x=0; x<12; x++){
    GPIO.digitalWrite(row[x], GPIO.HIGH);
    delay(5);
    for (int y=0; y<12; y++){
      if (GPIO.digitalRead(col[y]) == GPIO.HIGH){
        delay(10);
        value = result[y][x];
        dildoX = (y) * width / 12 + width / 24;
        dildoY = (x) * height / 12 + height / 24;
      }
    }
    GPIO.digitalWrite(row[x], GPIO.LOW);
  }
  return (value);
}

float midiToFreq(int note) {
  return (pow(2, ((note-69)/12.0)))*440;
}

void draw()
{
  //background(0);
  long ohTime = millis() - timer;
  int key_stroke;
  key_stroke = keyRead();
  if (musicFlip){
    if (key_stroke != 0){
       println(key_stroke);
       timer = millis();
       backSwitch = false;
       if (ohTime >= 35){
         float note = map(key_stroke, 0, 144, 0, 127);
         int noti = (int)note;
         triOsc.play(midiToFreq(noti), 0.8);
         env.play(triOsc, attackTime, sustainTime, sustainLevel, releaseTime);
     }
    }
  }
  else{
    if (key_stroke != 0){
     println(key_stroke);
     timer = millis();
     backSwitch = false;
     if (ohTime >= 50){
       file.play();
     }
   }
  }
  long timeOut = millis() - timer;
  if (timeOut >= 5000){
     if (backSwitch != true){
       //a = random(10, 100);
       //b = random(10, 100);
       //c = random(50, 100);
       a = random(10, 100);
       b = random(55, 100);
       c = random(75, 100);
       backSwitch = true;
       musicFlip = !musicFlip;
     }
     else{
       background(a,b,c);
     }
  }
  else{
    background(0);
    rings[int(random(rings.length))].respawn(dildoX, dildoY);
    for (int i = 0; i < rings.length; i++) {
      rings[i].draw();
    }
  }
}
