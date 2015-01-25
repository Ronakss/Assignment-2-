
/*processing Assignment 2 */
/*student number : C10717975*/
/*this assignment is about a game by useing mouse to defend yourself */

// This game include the flawing step 
// game screen
// game over screen
// the manu
// class
// PVectors
// random color
// mouse control 
// background fill stroke  


int LEASTa=10;    // the number
int LEASTaSPEED=1; // min speed
int MAXaSPEED=3;  // speed 3
int MAXaSIZE=30;  // the size of speed
int MINaSIZE=5;  // size other speed
float SHIPD=20.0; // the ships point
int NUMSTARS=1000;  //the stars number up to 1000
boolean gameon=false; //the gomeon when is false or not win
int gamepoint=0; // game on start at ponit zero
boolean win=false; // game win
int level=1;  //the game level 1 
boolean levelup=false; // the level up 
boolean start=false;  // starting of game
int deadastroids=0;  // the dead astorid 

// this the minim of music

import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
Minim minim;
AudioPlayer sou;



Ship player;
Astroid [] astarr= new Astroid[LEASTa];
Star [] stars= {
};

boolean TestStars( Star s, int current) {
  if (current>0) {
    for ( int i=0; i< current; i++) {
      if ( dist (s.bady.x, s.bady.y, stars[i].bady.x, stars[i].bady.y) < (( s.length + stars[i].length )/2) ) {
        return false; // if not
      }
    }
  }
  return true; //if possible
}
// the screen size 
void setup() {
  size(500, 500);
  background(20, 40, 40);


  // BGM
  minim = new Minim(this);
  sou = minim.loadFile("Teja.mp3");
  sou.loop(); 

  // the stars 

  openscreen();
  int m;
  for (int i=0; i<NUMSTARS; i++) {
    if (stars.length>0) {
      m=stars.length;
    } else {
      m=0;
    }
    Star x=new Star(new PVector(random(0, width), random(0, height)), random(1, 5));
    while ( TestStars (x, m)==false ) {
      x=new Star(new PVector(random(0, width), random(0, height)), random(1, 5));
    }
    stars =( Star [])append(stars, x);
  }
}

void draw() {

  if (gameon==true) {
    space();
    game();
  }

  if (start==true && player.explode==true) {
    player.exploder();
    if (player.dead==true) {
      gameover();
    }
  }
  if ( gameon==true) {
    score();
  }
  if ((deadastroids==LEASTa || deadastroids+1==LEASTa)&& win==false  ) {//WIN!!!!
    win=true;
    gameon=false;
    println("win", level);
    level++;
    println("next up", level);
    win();
  }
}

// the layout of mouse when it be pressed by user or player 
// if the player win it's display this code line i mean the if
// the false than display else statement 
// i used the tandom becouse it's give the size of star each time when play 
void mousePressed() {
  if (gameon ==false&& win==true) {
    gameon=true;
    start=true;
    win=false;
    player= new Ship(color(#FF052B, #05FF5A, #E5FA08), SHIPD);
    for (int i=0; i<astarr.length; i++) {
      astarr[i] = new Astroid(random(0, width), random(0, height/4), random(LEASTaSPEED, MAXaSPEED), random(MINaSIZE, MAXaSIZE), color(150, 150, random(220, 255)));
    }
  } else if (gameon ==false) {
    gameon=true;
    start=true;
    player= new Ship(color(#FAD608, #05FF5A, #E5FA08), SHIPD);
    for (int i=0; i<astarr.length; i++) {
      astarr[i] = new Astroid(random(0, width), random(0, height/4), random(LEASTaSPEED, MAXaSPEED), random(MINaSIZE, MAXaSIZE), color(150, 150, random(220, 255)));
    }
  } else {
    gameon=false;
  }
}



// this part of the moon and some star that make screen nice it show the night 
void game() {
  // the moon line
  fill(#EAEAEA);
  ellipse(100, 100, 100, 100);
  // if this two // take out from background it make the sky black and left with star 
  // background(0);
  //constructor
  // the star line code it's give the random star very small one
  fill(0, 40);
  rect(0, 0, width, height);
  fill(255);
  ellipse(random(width), random(height), 2, 2);

  player.recal();
  player.display();
  for (int i=0; i <astarr.length; i++) {
    if (astarr[i].explode==true) {
      astarr[i].exploder();
    } else if (astarr[i].dead==false && astarr[i].explode==false) {
      astarr[i].recal();
      astarr[i].display();
      if ( dist(player.bady.x, player.bady.y, astarr[i].bady.x, astarr[i].bady.y)< (player.length+astarr[i].length)/2) {
        gameon=false; 
        player.explode();
      }
      for (int j=i+1; j<astarr.length && gameon==true && i< astarr.length-1; j++) {
        if (astarr[j].dead==false && astarr[j].explode==false) {
          if ( dist(astarr[j].bady.x, astarr[j].bady.y, astarr[i].bady.x, astarr[i].bady.y)< (astarr[j].length+astarr[i].length)/2) {
            astarr[i].explode();
            astarr[j].explode();
            gamepoint+=2;
          }
        }
      }//inner for loop
    }// last else if statement
  }//outer for loop


  int count=0;
  for (int i=0; i<astarr.length; i++) {
    if (astarr[i].dead==true) {
      count++;
    }
  }
  deadastroids=count;
}
// the screen when for frist time user can see it  user can see and read the some thing about the game 
void openscreen() {
  background(255);
  textSize(40);
  textAlign(CENTER);
  fill(0);
  text("Hello, dear comrade!", width/2, 50);
  textSize(20);
  textAlign(LEFT);
  text("Be careful out there in there is plane we call space. Move your mouse to avoid the Asteroids.", width/12, 100, (2*width)/3, 400);
  textSize(40);
  textAlign(CENTER);
  text("Survive!", width/2, 420); 
  // when user press the mouse and start play it 
  textSize(17);
  fill(#FC14F1, 200, 200);

  text("Press the mouse to start", width/2, 470);
}
// this is the game score on screen user can see how was the game went on for him or her 
void score() {
  fill(255, 150);
  rect(0, 500, 500, 540);
  fill(0); 
  textSize(12);
  text("Score: "+gamepoint, 50, 520);
  text("Number of Astroids: "+LEASTa, 170, 520);
  text("Max Speed of Astroids: "+MAXaSPEED, 330, 520);
  text("Level: "+level, 450, 520);
}
// this is when user win the game it show to you user 
void win() {
  background(255, 0, 0);
  textSize(50);
  textAlign(CENTER);
  text("BRAVO YOU WIN!!", width/2, height/2);
  int l=floor(random(0, 3));
  if (l%3==0) {
    LEASTa=LEASTa*2;
    astarr=new Astroid[LEASTa];
  } else if (l%3==1) {
    MAXaSPEED++;
  } else {
    MAXaSIZE--;
  }
}
// this is the time when the game is over and it show the score point of player and it tell the player to press the mouse to play again
void gameover() {
  background(100, 100, 255);
  fill(0);
  textSize(60);
  textAlign(CENTER);
  text(" YOU DIED :(", width/2, height/2);
  textSize(20);
  fill(0);
  text("Your Final Score :"+gamepoint, width/2, 400);
  text("Press the Mouse to PLAY AGAIN", width/2, 480);
  gamepoint=0;
  LEASTa=10;
  level=1;
  deadastroids=0;
  MAXaSPEED=3;
  MAXaSIZE=30;
}


void space() {
  background(20, 40, 80);
  for (int i=0; i<stars.length; i++) {
    stars[i].draw();
  }
}


// the class of astroid bady shape and color 
class Astroid {
  PVector bady;
  float speed;
  float length;
  color acolor;
  boolean explode;
  int type;
  int i;
  boolean dead;

  Astroid(float x, float y, float s, float d, color ac) {
    bady= new PVector(x, y);
    speed= s;
    acolor= ac;
    length=d;
    explode= false;
    type=floor(random(0, 3));
    dead=false;
    i=0;
  }

  void recal() {
    float dx= (mouseX-bady.x)/abs(mouseX-bady.x);
    float dy= (mouseY-bady.y)/abs(mouseY-bady.y);
    bady= new PVector( bady.x+(speed*dx), bady.y+(speed*dy));
  }
  // FUNCTION 
  void display() {
    noStroke();
    fill(acolor);
    ellipse(bady.x, bady.y, length, length );

    float j=random(1, 5);
    for (int i=0; i<j; i++) {
      fill(random(40, 120));
      if (type==0) {
        ellipse(bady.x + random(-length, length), bady.y +length/3, random(1, length/2), random(1, length/2));
      } else if (type==1) {
        ellipse(bady.x + random(-length, length), bady.y, random(1, length/2), random(.5, length/2));
      } else {
        ellipse(bady.x + random(-length, length), bady.y -length/3, random(1, length/2), random(1, length/2));
      }
    }
  }

  void explode() {
    explode=true;
  }


  void exploder() {
    noStroke();
    fill(acolor);
    ellipse( bady.x-(i*5), bady.y, length, length); 
    ellipse( bady.x+(i*5), bady.y, length, length);
    ellipse( bady.x, bady.y-(i*5), length, length);
    ellipse( bady.x, bady.y+(i*5), length, length);
    length--;
    i++;
    if (length <=0) {
      explode=false;
      dead=true;
    }
  }
}
// the class for ship when it is not win adn dead 
class Ship {
  PVector bady;
  color scolor;
  float length;
  int i;
  boolean dead;
  boolean explode;


  Ship(color sc, float d) {
    bady= new PVector(width/2, height/2);
    scolor= sc;
    length=d;
    i=0;
    explode= false;
    dead=false;
  }

  void recal() {
    bady=new PVector( constrain(mouseX, 0, width), constrain(mouseY, 0, height-40));
  }

  void display() {
    noStroke();
    fill(scolor);
    ellipseMode(CENTER);
    //hub of ship      the all important container of player
    ellipse(bady.x, bady.y, length, length);
    fill(0);
    //black inner cirlce of hub
    ellipse(bady.x, bady.y, length-(length/4), length-(length/4));

    //alien
    fill(80, 255, 80);
    ellipse(bady.x, bady.y-4, 4, 6);
    fill(0);
    ellipse(bady.x, bady.y-4, 2, 3);


    fill(scolor);
    //lower body of ship
    ellipse(bady.x, bady.y+5, length*2, length-(length/2));
    fill(color(random(0, 255), random(0, 255), random(0, 255)));
    //circle detail on the ship
    ellipse(bady.x-(length/3), bady.y+5, 3, 3);
    ellipse(bady.x, bady.y+5, 3, 3);
    ellipse(bady.x+(length/3), bady.y+5, 3, 3);
    fill(255);
    //streams
    ellipse(bady.x-(length/3), bady.y+15, 2, 5);
    ellipse(bady.x, bady.y+15, 2, 5);
    ellipse(bady.x+(length/3), bady.y+15, 2, 5);
  }

  void explode() {
    explode=true;
  }

  void exploder() {
    noStroke();
    fill(scolor);
    ellipse( bady.x-(i*10), bady.y, length, length); 
    ellipse( bady.x+(i*10), bady.y, length, length);
    ellipse( bady.x, bady.y-(i*10), length, length);
    ellipse( bady.x, bady.y+(i*10), length, length);
    length--;
    i++;
    if (length <=0) {
      explode=false;
      dead=true;
    }
  }
}
class Star
{
  PVector bady;
  float length;

  Star(PVector or, float d) {
    bady= new PVector(or.x, or.y);
    length=d;
  }

  void draw() {
    fill(255, 200);
    ellipse(bady.x, bady.y, length, length);
  }
}

