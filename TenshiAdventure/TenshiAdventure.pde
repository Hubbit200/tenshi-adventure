import processing.javafx.*;

//SAVING
final String fileName = "saveInfo.txt";
String[] saveData = new String [12];

//GENERAL VARIABLES ---------------------------------------------------
int gameMode=-3, visMenuGame=0, countdownInt, fadeInt=0, goalMethod;
float oneUnit;
PImage arrowL, arrowLPressed, arrowR, arrowRPressed, game1, game1Pressed, gameOver, close, closePressed, settings, settingsPressed, home, homePressed, back, backPressed, slider, sliderHandle, sfx, music, fullscreenIcon, checkEmpty, check;
PImage b1, homeSquare, homeSquarePressed, retry, retryPressed, loading, creditsPressed, credits, game2, game2Pressed, scoreBG, highscore, highscorePressed, blur, patata, shopbg, shopTable, shoptenshi1, shoptenshi2, counterImg, infoHigh, backNoShadow;
boolean imgLoaded, fadeIn, screenFading, doneChange, highscoresOpen;
PFont pixelatedFont, pixelatedFontBig;

//DINO GAME VARIABLES ----------------------
int g1x, g2x, m2x, m1x, c1x, c2x;
int speed, totYOG, totY;
float totSpeedY, realSpeed;
boolean totJumping, lost, crouching, boosting;
collisionObject [] sushi = new collisionObject[4];
overlapObject [] pickups = new overlapObject[2];
PImage tot1, tot2, tot3, tot4, tot5, tot6, tot7, tot8, tot9, tot10, ground, mountains, clouds, sushi1, sushi2, tree, penguin1, penguin2, boost;
int timeLastSushi = 0, timeLastPickup = 0, boostingTime, score, counter;

//NAP GAME VARIABLES ----------------------
int mapSize=60, tileSize, sofaPos, prevClosest, gameLength = 90000;
int[] inventory=new int[3];
float yPos=mapSize/2, xPos=2, rotation, angle, closestObjDist;
int mapX[]=new int[mapSize], mapY[]=new int[mapSize], mapPos[]=new int[mapSize*mapSize], xPressed, yPressed;
PImage bush, grass, napTenshi, vignette, good1, good2, good3, sofa, sofa2, arrow, inventoryImg;
pickupObject objs[] = new pickupObject[40];
long timer = 0;



//SETTINGS FUNCTION ---------------------------------------------------------------------------------------------------------------------------------------------------------------
void settings() {
  loadSave();
  if (int(saveData[2])==-1)fullScreen(FX2D);
  else size(1280, 720, FX2D);
}

//SETUP FUNCTION ------------------------------------------------------------------------------------------------------------------------------------------------------------------
void setup() {
  frameRate(60);
  textAlign(CENTER);
  rectMode(CENTER);
  fill(255);
  loading=loadImage("loadingScreen.png");
  imageMode(CENTER);
  image(loading, width/2, height/2, width, height);
  oneUnit=height/1080f;
  pixelatedFont = createFont("MotorolaScreentype.ttf", 30);
  pixelatedFontBig = createFont("MotorolaScreentype.ttf", 38);
  textFont(pixelatedFontBig);
  tileSize=width/24;
  thread("loadImages");
}

//DRAW FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------------------------
void draw() {
  switch(gameMode) {
  case 0:
    image(b1, width/2, height/2, width, height);
    menuDraw();
    fill(0, 255);
    break;
  case 1:
    background(143, 211, 255);
    dinoGameDraw();
    break;
  case 2:
    background(0);
    napTimeDraw();
    break;
  case -1:
    image(b1, width/2, height/2, width, height);
    settingsDraw();
    break;
  case -2:
    image(b1, width/2, height/2, width, height);
    creditsDraw();
    break;
  case -3:
    image(loading, width/2, height/2, width, height);
    text("Loading...", width/9*8, height/11*10);
    if (imgLoaded && countdownInt>35 && screenFading==false) {
      goalMethod=0;
      countdownInt=millis();
      doneChange=false;
      screenFading=true;
    } else countdownInt++;
    break;
  case -4:
    image(shopbg, width/2, height/2, width, height);
    shopDraw();
    break;
  }

  if (screenFading)fadeScreen();
}

//CREDITS DRAW ------------------------------------------------------
void creditsDraw() {
  if (counter==0) {
    credits("Directed & programmed by", "Leo Humphreys Newman", 3500);
  } else if (counter==1) {
    credits("Head of design & lead artist", "Hector Jimenez Alvarez", 3000);
  } else if (counter==2) {
    credits("Instagram manager & concept artist", "Celia Xiaoju Fernandez Guzman", 2000);
  } else if (counter==3) {
    credits("Head writer & Twitter co-manager", "Nicolas Urias Sanchez", 2000);
  } else if (counter==4) {
    credits("Twitter co-manager & concept artist", "Sergio Catalan Elias", 2000);
  } else { 
    gameMode=-1;
    counter=0;
  }
}

//SETTINGS DRAW ------------------------------------------------------
void settingsDraw() {
  //Exit button ----------------------------
  if (mouseX>width/10*9-width/30 && mouseX<width/10*9+width/30 && mouseY>height/8-width/30 && mouseY<height/8+width/30) {
    image(closePressed, width/10*9, height/8, width/15, width/15);
    if (millis()-countdownInt>500 && mousePressed) {
      saveSave();
      exit();
    }
  } else image(close, width/10*9, height/8, width/15, width/15);
  //Back button ----------------------------
  if (mouseX>width/10-width/30 && mouseX<width/10+width/30 && mouseY>height/8-width/30 && mouseY<height/8+width/30) {
    image(backPressed, width/10, height/8, width/15, width/15);
    if (millis()-countdownInt>500 && mousePressed) {
      saveSave();
      gameMode=0;
      countdownInt=millis();
    }
  } else image(back, width/10, height/8, width/15, width/15);

  image(slider, width/5*3, height/3, width/4, height/24);
  image(music, width/5*1.6, height/3, width/9, height/24);
  image(sliderHandle, map(int(saveData[0]), 0, 100, width/5*3-width/9, width/5*3+width/9), height/3, height/35, height/16);
  if (mousePressed && mouseX>width/5*3-width/9 && mouseX<width/5*3+width/9 && mouseY>height/3-height/15 && mouseY<height/3+height/15)saveData[0]=str(int(map(mouseX, width/5*3-width/9, width/5*3+width/9, 0, 100)));

  image(slider, width/5*3, height/24*11, width/4, height/24);
  image(sfx, width/5*1.6, height/24*11, width/13, height/24);
  image(sliderHandle, map(int(saveData[1]), 0, 100, width/5*3-width/9, width/5*3+width/9), height/24*11, height/35, height/16);
  if (mousePressed && mouseX>width/5*3-width/9 && mouseX<width/5*3+width/9 && mouseY>height/24*11-height/15 && mouseY<height/24*11+height/15)saveData[1]=str(int(map(mouseX, width/5*3-width/9, width/5*3+width/9, 0, 100)));

  image(fullscreenIcon, width/5*1.6, height/24*14, width/5, height/24);
  if (int(saveData[2])==1)image(checkEmpty, width/5*3, height/24*14, height/13, height/13);
  else image(check, width/5*3, height/24*14, height/13, height/13);

  if (mouseX>width/2-height/6 && mouseX<width/2+height/6 && mouseY>height/24*18-height/13 && mouseY<height/24*18+height/13) {
    image(creditsPressed, width/2, height/4*3, height/3, height/13);
    if (mousePressed) {
      fadeInt = 0;
      gameMode=-2;
      countdownInt=millis();
    }
  } else image(credits, width/2, height/4*3, height/3, height/13);
}


//SHOP DRAW ------------------------------------------------------
void shopDraw() {
  //Back button ----------------------------
  if (mouseX>width/10-width/30 && mouseX<width/10+width/30 && mouseY>height/8-width/30 && mouseY<height/8+width/30) {
    image(backPressed, width/10, height/8, width/15, width/15);
    if (millis()-countdownInt>500 && mousePressed) {
      saveSave();
      gameMode=0;
      countdownInt=millis();
    }
  } else image(back, width/10, height/8, width/15, width/15);

  //Table and tenshi
  if (millis()%1000<=500)image(shoptenshi1, width/2, height/3.5);
  else image(shoptenshi2, width/2, height/3.5);
  image(shopTable, width/2, height/1.32, width, height/2);
  image(counterImg, width/1.2, height/8, width/6, height/9);
  fill(200, 130, 120);
  text(saveData[3], width/1.22, height/7);
}


//MENU DRAW ------------------------------------------------------
void menuDraw() {
  if (!highscoresOpen) {
    //Shop button -----------------------------
    if (mouseX<width/5 && mouseY>height/4*3) {
      if (millis()-countdownInt>500 && mousePressed) {
        gameMode=-4;
        countdownInt=millis();
      }
    }
    //Left arrow -----------------------------
    if (visMenuGame!=0 && mouseX>width/5-width/30 && mouseX<width/5+width/30 && mouseY>height/2-width/13 && mouseY<height/2+width/13) {
      image(arrowLPressed, width/5, height/2, width/15, width/13);
      if (millis()-countdownInt>500 && mousePressed) {
        visMenuGame=constrain(visMenuGame-1, 0, 1);
        countdownInt=millis();
      }
    } else if (visMenuGame!=0) image(arrowL, width/5, height/2, width/15, width/13);
    //Right arrow -----------------------------
    if (visMenuGame!=1 && !highscoresOpen && mouseX>width/5*4-width/30 && mouseX<width/5*4+width/30 && mouseY>height/2-width/13 && mouseY<height/2+width/13) {
      image(arrowRPressed, width/5*4, height/2, width/15, width/13);
      if (millis()-countdownInt>500 && mousePressed) {
        visMenuGame=constrain(visMenuGame+1, 0, 1);
        countdownInt=millis();
      }
    } else if (visMenuGame!=1) image(arrowR, width/5*4, height/2, width/15, width/13);
    //Settings button -------------------------------
    if (!highscoresOpen && mouseX>width/10-width/30 && mouseX<width/10+width/30 && mouseY>height/8-width/30 && mouseY<height/8+width/30) {
      image(settingsPressed, width/10, height/8, width/15, width/15);
      if (millis()-countdownInt>500 && mousePressed) {
        gameMode=-1;
        countdownInt=millis();
      }
    } else image(settings, width/10, height/8, width/15, width/15);
    //Exit button -------------------------------
    if (!highscoresOpen && mouseX>width/10*9-width/30 && mouseX<width/10*9+width/30 && mouseY>height/8-width/30 && mouseY<height/8+width/30) {
      image(closePressed, width/10*9, height/8, width/15, width/15);
      if (millis()-countdownInt>500 && mousePressed) {
        exit();
      }
    } else image(close, width/10*9, height/8, width/15, width/15);

    //Game select button ------------------------
    if (!highscoresOpen && mouseX>width/2-width/5.6 && mouseX<width/2+width/5.6 && mouseY>height/2-height/5.5 && mouseY<height/1.54) {
      switch(visMenuGame) {
      case 0:
        image(game1Pressed, width/2, height/2, width/2.8, height/2.75);
        break;
      case 1:
        image(game2Pressed, width/2, height/2, width/2.8, height/2.75);
        break;
      }
      if (mousePressed) {
        switch(visMenuGame) {
        case 0:
          goalMethod=1;
          break;
        case 1:
          resetNapTime();
          goalMethod=2;
          break;
        }
        countdownInt=millis();
        doneChange=false;
        screenFading=true;
      }
    } else {
      switch(visMenuGame) {
      case 0:
        image(game1, width/2, height/2, width/2.8, height/2.75);
        break;
      case 1:
        image(game2, width/2, height/2, width/2.8, height/2.75);
        break;
      }
    }
    //Highscores button
    if (!highscoresOpen && mouseX>width/1.6 && mouseX<width/1.4 && mouseY>height/1.54 && mouseY<height/1.3) {
      image(highscorePressed, width/1.5, height/1.45, width/15, height/7.7);
      if (mousePressed)highscoresOpen=true;
    } else image(highscore, width/1.5, height/1.45, width/15, height/7.7);
    
    //Highscores and info panel
  } else {
    image(blur, width/2, height/2, width, height);
    image(infoHigh, width/2, height/2, width/1.5, height/1.5);
    if (mouseX>width/6 && mouseX<width/4 && mouseY>height/6 && mouseY<height/4) {
      image(backPressed, width/2-width/3.28, height/2-height/3.43, width/17.5, width/17.5);
      if (mousePressed)highscoresOpen=false;
    } else image(backNoShadow, width/2-width/3.26, height/2-height/3.43, width/17.5, width/17.5);
    fill(255);
    if (visMenuGame == 0)text("Help Tenshi pass the obstacles and collect crisps while on his scooter, on his amazing journey in Tenshi Scooter! (Arrow keys or W/S to jump and crouch)", width/3, height/1.6, width/4, height/2);
    else text("Help Tenshi navigate the maze and find amazing Nap Objects, and then take them back to his sofa! (Arrow keys or W/A/S/D to move, click to pick up and drop)", width/3, height/1.6, width/4, height/2);
    fill(0);
    if (visMenuGame == 0)text("-1st Place:\n     "+saveData[6]+" points\n\n-2nd Place:\n     "+saveData[7]+" points\n\n-3rd Place:\n     "+saveData[8]+" points", width/3*2, height/1.7, width/4, height/2);
    else text("-1st Place:\n     "+saveData[9]+" points\n\n-2nd Place:\n     "+saveData[10]+" points\n\n-3rd Place:\n     "+saveData[11]+" points", width/3*2, height/1.7, width/4, height/2);
  }
}

//LOAD NECESSARY IMAGES -------------------------------------------------------------------------------------------------
void loadImages() {
  b1=loadImage("background1.png");
  arrowLPressed=loadImage("arrow1Pressed.png");
  arrowL=loadImage("arrow1.png");
  arrowRPressed=loadImage("arrow2Pressed.png");
  arrowR=loadImage("arrow2.png");
  tot1=loadImage("personaje1.png");
  tot2=loadImage("personaje2.png");
  tot3=loadImage("personaje15.png");
  tot4=loadImage("personaje16.png");
  tot5=loadImage("personaje3.png");
  tot6=loadImage("personaje4.png");
  tot7=loadImage("personaje17.png");
  tot8=loadImage("personaje18.png");
  tot9=loadImage("personaje13.png");
  tot10=loadImage("personaje14.png");
  game1=loadImage("game1.png");
  game1Pressed=loadImage("game1Pressed.png");
  ground=loadImage("Grass.png");
  mountains=loadImage("Mountains.png");
  clouds=loadImage("Clouds.png");
  sushi1=loadImage("sushi1.png");
  sushi2=loadImage("sushi2.png");
  gameOver=loadImage("gameover.png");
  close=loadImage("Close1.png");
  closePressed=loadImage("Close2.png");
  settings=loadImage("ajustes1.png");
  settingsPressed=loadImage("ajustes2.png");
  credits=loadImage("credits.png");
  creditsPressed=loadImage("creditsPressed.png");
  tree=loadImage("tree.png");
  home=loadImage("homeb1.png");
  homePressed=loadImage("homeb2.png");
  back=loadImage("patras1.png");
  backPressed=loadImage("patras2.png");
  sliderHandle=loadImage("loquesemuevedelslider.png");
  slider=loadImage("slider.png");
  music=loadImage("Music.png");
  sfx=loadImage("SFX.png");
  fullscreenIcon = loadImage("fullscreen.png");
  checkEmpty = loadImage("checkbox1.png");
  check = loadImage("checkbox2.png");
  bush = loadImage("tiles1.png");
  grass = loadImage("tiles2.png");
  homeSquare = loadImage("botonesgameover1.png");
  homeSquarePressed = loadImage("botonesgameover2.png");
  retry = loadImage("botonesgameover3.png");
  retryPressed = loadImage("botonesgameover4.png");
  game2 = loadImage("Boton menu3.png");
  game2Pressed = loadImage("Boton menu4.png");
  penguin1 = loadImage("penguin1.png");
  penguin2 = loadImage("penguin3.png");
  scoreBG = loadImage("score.png");
  napTenshi = loadImage("tenshinaptime.png");
  vignette = loadImage("vignette.png");
  good1 = loadImage("good1.png");
  good2 = loadImage("good2.png");
  good3 = loadImage("good3.png");
  sofa = loadImage("sofa.png");
  sofa2 = loadImage("sofa2.png");
  arrow = loadImage("arrow.png");
  highscore = loadImage("highscore1.png");
  highscorePressed = loadImage("highscore2.png");
  blur = loadImage("blurred.png");
  boost = loadImage("boost.png");
  patata = loadImage("patata.png");
  shopbg = loadImage("shopbg1.png");
  shopTable = loadImage("shop1.png");
  shoptenshi1 = loadImage("shoptenshi1.png");
  shoptenshi2 = loadImage("shoptenshi2.png");
  counterImg = loadImage("counter.png");
  infoHigh = loadImage("infoHigh.png");
  backNoShadow = loadImage("botonsinsombra.png");
  inventoryImg = loadImage("inv.png");
  imgLoaded=true;
}

//RESET DINO GAME VARS -----------------------------------------------------------------------------------------------------
void dinoInit() {
  //Dino game var setup
  score=0;
  g1x=width/4*3;
  g2x=width+width/4*5;
  m1x=width/4*3;
  m2x=width+width/4*5;
  c1x=width/4*3;
  c2x=width+width/4*5;
  totYOG=int(height/1.3);
  totY=totYOG;
  for (int i=0; i<sushi.length-1; i++) {                              
    sushi[i]=new collisionObject();
  }
  fill(0);
  textSize(45);
  countdownInt=0;
  oneUnit=height/1080f;
  realSpeed=oneUnit*11f;
  speed=int(realSpeed);
  counter=0;
  pickups[0] = new overlapObject((int)random(-100, -60));
  pickups[1] = new overlapObject((int)random(-300, -200));
  lost=false;
  timeLastPickup=0;
  timeLastSushi=0;
  boosting=false;
}

//DRAW TENSHI SCOOTER --------------------------------------------------------------------------------------------------------
void dinoGameDraw() {
  if (!lost) {
    //Parallax1 -----------------------------
    image(clouds, c1x, height/3, width*1.5, height/3*2);
    image(clouds, c2x, height/3, width*1.5, height/3*2);
    c1x-=speed/5*2;
    if (c1x<-width/4*3) {
      c1x=width+width/4*5;
      c2x=width/4*3;
    }
    c2x-=speed/5*2;
    if (c2x<-width/4*3) {
      c2x=width+width/4*5;
      c1x=width/4*3;
    }
    //Parallax2 -----------------------------
    image(mountains, m1x, height/2-height/12, width*1.5, height/9*5);
    image(mountains, m2x, height/2-height/12, width*1.5, height/9*5);
    m1x-=speed/3*2;
    if (m1x<-width/4*3) {
      m1x=width+width/4*5;
      m2x=width/4*3;
    }
    m2x-=speed/3*2;
    if (m2x<-width/4*3) {
      m2x=width+width/4*5;
      m1x=width/4*3;
    }

    //Ground & trees ---------------------
    image(tree, g1x, height/20*11, height/4.2, height/3.2);
    image(tree, g2x, height/20*11, height/4, height/3);
    image(ground, g1x, height-height/6, width*1.5, height/3);
    image(ground, g2x, height-height/6, width*1.5, height/3);
    g1x-=speed;
    g2x-=speed;
    if (g1x<-width/4*3) {
      g1x=width+width/4*5;
      g2x=width/4*3;
    }
    if (g2x<-width/4*3) {
      g2x=width+width/4*5;
      g1x=width/4*3;
    }

    //Totoro -----------------------------
    totY+=totSpeedY;
    if (boosting) {
      if (millis()-boostingTime>2000) {
        boosting=false;
        speed-=15;
      }
    }
    if (totY>totYOG && totJumping==true) {
      totY=totYOG;
      totSpeedY=0;
      totJumping=false;
    } else if (totJumping && totY<totYOG) {
      totSpeedY+=oneUnit*(realSpeed/(oneUnit*9));
    }
    if (!totJumping && !crouching && !boosting) {
      if (frameCount%10==0)image(tot1, width/5, totY, width/9, width/9);
      else image(tot2, width/5, totY, width/9, width/9);
    } else if (totJumping && !crouching && !boosting) {
      if (frameCount%10==0)image(tot3, width/5, totY, width/9, width/9);
      else image(tot4, width/5, totY, width/9, width/9);
    } else if (crouching) {
      if (frameCount%10==0)image(tot7, width/5, totY, width/9, width/9);
      else image(tot8, width/5, totY, width/9, width/9);
    } else {
      if (frameCount%10==0)image(tot9, width/5, totY, width/9, width/9);
      else image(tot10, width/5, totY, width/9, width/9);
    }

    //Sushi -----------------------------
    for (int i=0; i<sushi.length-1; i++) {
      sushi[i].drawObs();
    }

    //Counter
    fill(0);
    image(counterImg, width/8, height/11, width/6, height/12);
    image(patata, width/8+width/16.5, height/11, height/19, height/18);
    fill(255);
    text(score, width/9, height/9);

    //Increment speed
    if (countdownInt>=3 && !boosting) {
      realSpeed+=oneUnit;
      speed=round(realSpeed);
      countdownInt=0;
    }

    pickups[0].drawObject();
    pickups[1].drawObject();

    //LOST -------------------------------------------------------
  } else if (counter==0) {
    image(clouds, c1x, height/3, width*1.5, height/3*2);
    image(clouds, c2x, height/3, width*1.5, height/3*2);
    image(mountains, m1x, height/2-height/12, width*1.5, height/9*5);
    image(mountains, m2x, height/2-height/12, width*1.5, height/9*5);
    image(tree, g1x, height/20*11, height/4.2, height/3.2);
    image(tree, g2x, height/20*11, height/4, height/3);
    image(ground, g1x, height-height/6, width*1.5, height/3);
    image(ground, g2x, height-height/6, width*1.5, height/3);
    for (int i=0; i<sushi.length-1; i++) {
      sushi[i].drawObs();
    }
    countdownInt=millis();
    speed=0;
    counter=1;
  } else if (counter==1) {
    image(clouds, c1x, height/3, width*1.5, height/3*2);
    image(clouds, c2x, height/3, width*1.5, height/3*2);
    image(mountains, m1x, height/2-height/12, width*1.5, height/9*5);
    image(mountains, m2x, height/2-height/12, width*1.5, height/9*5);
    image(tree, g1x, height/20*11, height/4.2, height/3.2);
    image(tree, g2x, height/20*11, height/4, height/3);
    image(ground, g1x, height-height/6, width*1.5, height/3);
    image(ground, g2x, height-height/6, width*1.5, height/3);
    for (int i=0; i<sushi.length-1; i++) {
      sushi[i].drawObs();
    }
    if (frameCount%12==0)image(tot5, width/5, totY, width/9, width/9);
    else image(tot6, width/5, totY, width/9, width/9);
    if (millis()-countdownInt>2000)counter=2;
  } else if (counter==2) {
    image(gameOver, width/2, height/2, width, height);
    //Home button
    if (mouseX>width/5*3-width/8 && mouseX<width/5*3+width/12 && mouseY>height/5*4.3-height/10 && mouseY<height/5*4.3+height/10) {
      image(homeSquarePressed, width/5*3, height/5*4.3, width/6, height/10);
      if (mousePressed) {
        countdownInt=millis();
        doneChange=false;
        screenFading=true;
        goalMethod=0;
      }
      //Retry button
    } else image(homeSquare, width/5*3, height/5*4.3, width/6, height/10);
    if (mouseX>width/5*4-width/12 && mouseX<width/5*4+width/8 && mouseY>height/5*4.3-height/10 && mouseY<height/5*4.3+height/10) {
      image(retryPressed, width/5*4, height/5*4.3, width/6, height/10);
      if (mousePressed) {
        countdownInt=millis();
        doneChange=false;
        screenFading=true;
        goalMethod=1;
      }
    } else image(retry, width/5*4, height/5*4.3, width/6, height/10);
    fill(0, 255);
    image(scoreBG, width/5*3.5, height/1.48, width/5.5, height/8);
    textSize(90);
    text(score, width/5*3.4, height/1.4);
    textSize(30);
    text(saveData[6], width/5*3.8, height/1.39);
  }
}

void totoroDie() {
  lost=true;
  if (score>int(saveData[8])) {
    if (score>int(saveData[7])) {
      if (score>int(saveData[6])) {
        saveData[8]=saveData[7];
        saveData[7]=saveData[6];
        saveData[6]=str(score);
      } else {
        saveData[8]=saveData[7];
        saveData[7]=str(score);
      }
    } else saveData[8]=str(score);
  }
  saveSave();
}



//DRAW NAP TIME --------------------------------------------------------------------------------------------------------
void napTimeDraw() {
  fill(255);
  /*for (int i=0; i<mapPos.length; i++) {
   if (mapPos[i]==0)image(grass, (width/(mapSize)*(i%mapSize))+width/mapSize/2, (height/mapSize)*(1+((i-(i%mapSize))/mapSize))-height/mapSize/2, width/mapSize, height/mapSize);
   else image(bush, (width/(mapSize)*(i%mapSize))+width/mapSize/2, (height/mapSize)*(1+((i-(i%mapSize))/mapSize))-height/mapSize/2, width/mapSize, height/mapSize);
   }*/

  if (keyPressed) {
    if (xPressed==-1 && mapPos[round(xPos-0.85)+mapSize*(round(yPos-0.5)+1)]!=1 && mapPos[round(xPos-0.85)+mapSize*(round(yPos+0.5)+1)]!=1 && mapPos[round(xPos-0.85)+mapSize*(round(yPos)+1)]!=1) {
      if (yPressed==0)xPos-=0.1;
      else xPos-=0.07;
    } else if (xPressed==1 && mapPos[round(xPos+0.9)+mapSize*(round(yPos-0.8)+1)]!=1 && mapPos[round(xPos+0.9)+mapSize*(round(yPos+0.5)+1)]!=1 && mapPos[round(xPos+0.9)+mapSize*(round(yPos)+1)]!=1) {
      if (yPressed==0)xPos+=0.1;
      else xPos+=0.07;
    }
    if (yPressed==-1 && mapPos[round(xPos-0.5)+mapSize*(round(yPos-1.1)+1)]!=1 && mapPos[round(xPos)+mapSize*(round(yPos-1.1)+1)]!=1 && mapPos[round(xPos+0.5)+mapSize*(round(yPos-1.1)+1)]!=1) {
      if (xPressed==0)yPos-=0.1;
      else yPos-=0.07;
    } else if (yPressed==1 && mapPos[round(xPos-0.5)+mapSize*(round(yPos+0.6)+1)]!=1 && mapPos[round(xPos)+mapSize*(round(yPos+0.6)+1)]!=1 && mapPos[round(xPos+0.5)+mapSize*(round(yPos+0.6)+1)]!=1) {
      if (xPressed==0)yPos+=0.1;
      else yPos+=0.07;
    }
  }

  for (int i=0; i<mapPos.length; i++) {
    //if (i!=round(xPos)+mapSize*(round(yPos-0.8)+1) && i!=round(xPos)+mapSize*(round(yPos+0.5)+1) && i!=round(xPos+0.7)+mapSize*(round(yPos-0.8)+1) && i!=round(xPos+0.7)+mapSize*(round(yPos)+1) && i!=round(xPos+0.7)+mapSize*(round(yPos+0.5)+1) && i!=round(xPos-0.7)+mapSize*(round(yPos-0.8)+1) && i!=round(xPos-0.7)+mapSize*(round(yPos)+1) && i!=round(xPos-0.7)+mapSize*(round(yPos+0.5)+1)) {
    if (mapPos[i]==0 || mapPos[i]==2)image(grass, width/2+tileSize*((i%mapSize)-xPos), tileSize*((i-(i%mapSize))/mapSize-yPos+round(height/tileSize)/2), tileSize, tileSize);
    else if (mapPos[i]==1)image(bush, width/2+tileSize*((i%mapSize)-xPos), tileSize*((i-(i%mapSize))/mapSize-yPos+round(height/tileSize)/2), tileSize, tileSize);
    //}
  }

  //draw objects and calculate distance to closest
  for (int i = 0; i<objs.length; i++) {
    objs[i].drawObject();
    if ((dist(width/2, height/2, objs[i].pixelX, objs[i].pixelY)<closestObjDist || closestObjDist==0) && dist(width/2, height/2, objs[i].pixelX, objs[i].pixelY)<150) {
      if (i!=prevClosest) {
        closestObjDist=dist(width/2, height/2, objs[i].pixelX, objs[i].pixelY);
        objs[i].closest=true;
        objs[prevClosest].closest=false;
        prevClosest=i;
      }
    }
  }

  //Draw sofa
  if (sofaPos%mapSize>mapSize/2)image(sofa2, width/2+tileSize*((sofaPos%mapSize)-xPos-0.5), tileSize*((sofaPos-(sofaPos%mapSize))/mapSize-yPos+round(height/tileSize)/2), tileSize*2, tileSize*3);
  else image(sofa, width/2+tileSize*((sofaPos%mapSize)-xPos-0.5), tileSize*((sofaPos-(sofaPos%mapSize))/mapSize-yPos+round(height/tileSize)/2), tileSize*2, tileSize*3);



  //Vignette and arrow
  image(vignette, width/2, height/2, width, height);
  if (mouseX>width/7*3 && mouseX<width/7*4 && mouseY>height/5*2 && mouseY<height/5*3) {
    pushMatrix();
    translate(width/2, height/2);
    if ((sofaPos%mapSize)-xPos>0) {
      angle=atan((float)(1*(((sofaPos-(sofaPos%mapSize))/mapSize)-yPos)/((sofaPos%mapSize)-xPos)));
      //println((float)(-1*((sofaPos-(sofaPos%mapSize)))/mapSize)/(sofaPos%mapSize));
    } else {
      angle=atan((float)(-1*(((sofaPos-(sofaPos%mapSize))/mapSize)-yPos)/((sofaPos%mapSize)-xPos)));
      if (angle<0) {
        angle=angle+(2*PI);
        angle=PI-angle;
      } else if (angle>0)angle=PI-angle;
    }
    rotate(angle);
    tint(255, map(dist(xPos, yPos, sofaPos%mapSize, (sofaPos-(sofaPos%mapSize))/mapSize), 0, mapSize*1.2, 0, 255));
    image(arrow, 0, 0, tileSize*3.7, tileSize*2.2);
    tint(255, 255);
    popMatrix();
  }

  //Draw Tenshi
  pushMatrix();
  translate(width/2, height/2);
  if (yPressed==0 && xPressed==-1)rotation=PI;
  else if (yPressed==0 && xPressed==1)rotation=0;
  else if (yPressed==-1 && xPressed==0)rotation=3*PI/2;
  else if (yPressed==1 && xPressed==0)rotation=PI/2;
  else if (yPressed==1 && xPressed==1)rotation=PI/4;
  else if (yPressed==-1 && xPressed==1)rotation=-PI/4;
  else if (yPressed==1 && xPressed==-1)rotation=PI*3/4;
  else if (yPressed==-1 && xPressed==-1)rotation=-PI*3/4;
  rotate(rotation);
  image(napTenshi, 0, 0, width/15, width/15);
  popMatrix();

  //Draw inventory
  noFill();
  stroke(235);
  image(inventoryImg, width/2, height/1.06, width/5.4, tileSize*1.18);
  stroke(0);
  for (int i=1; i<inventory.length+1; i++) {
    switch(inventory[i-1]) {
    case 1:
      image(good1, width/8+width/16*(4+i), height/1.06, tileSize, tileSize);
      break;
    case 2:
      image(good2, width/8+width/16*(4+i), height/1.06, tileSize, tileSize);
      break;
    case 3:
      image(good3, width/8+width/16*(4+i), height/1.06, tileSize, tileSize);
      break;
    }
  }

  //Counter
  fill(0);
  textSize(height/24);
  image(counterImg, width/8, height/11, width/6, height/12);
  image(patata, width/8+width/16.5, height/11, height/19, height/18);
  fill(255);
  text(score, width/9, height/9);

  //Drop items at sofa
  if (dist(width/2+tileSize*((sofaPos%mapSize)-xPos-0.5), tileSize*((sofaPos-(sofaPos%mapSize))/mapSize-yPos+round(height/tileSize)/2), width/2, height/2)<180) {
    if (mousePressed) {
      for (int i=0; i<inventory.length; i++) {
        if (inventory[i]!=0) {
          switch(inventory[i]) {
          case 1:
            score+=1;
            break;
          case 2:
            score+=2;
            break;
          case 3:
            score+=5;
            break;
          }
          inventory[i]=0;
        }
      }
    }
  }

  text((int)((gameLength-(millis()-timer))/1000), width/2, height/10);
  
  //Lose
  if (gameLength-(millis()-timer)<100 && !screenFading && !lost) {
    if (score>int(saveData[11])) {
      if (score>int(saveData[10])) {
        if (score>int(saveData[9])) {
          saveData[11]=saveData[10];
          saveData[10]=saveData[9];
          saveData[9]=str(score);
        } else {
          saveData[11]=saveData[10];
          saveData[10]=str(score);
        }
      } else saveData[11]=str(score);
    }
    saveSave();
    lost = true;
  }
  
  if (lost) {
    image(gameOver, width/2, height/2, width, height);
    //Home button
    if (mouseX>width/5*3-width/8 && mouseX<width/5*3+width/12 && mouseY>height/5*4.3-height/10 && mouseY<height/5*4.3+height/10) {
      image(homeSquarePressed, width/5*3, height/5*4.3, width/6, height/10);
      if (mousePressed) {
        countdownInt=millis();
        doneChange=false;
        screenFading=true;
        goalMethod=0;
      }
      //Retry button
    } else image(homeSquare, width/5*3, height/5*4.3, width/6, height/10);
    if (mouseX>width/5*4-width/12 && mouseX<width/5*4+width/8 && mouseY>height/5*4.3-height/10 && mouseY<height/5*4.3+height/10) {
      image(retryPressed, width/5*4, height/5*4.3, width/6, height/10);
      if (mousePressed) {
        countdownInt=millis();
        doneChange=false;
        screenFading=true;
        goalMethod=2;
      }
    } else image(retry, width/5*4, height/5*4.3, width/6, height/10);
    fill(0, 255);
    image(scoreBG, width/5*3.5, height/1.48, width/5.5, height/8);
    textSize(height/12);
    text(score, width/5*3.4, height/1.4);
    textSize(height/36);
    text(saveData[9], width/5*3.8, height/1.39);
  }
}

//Reset Nap Tive Variables
void resetNapTime(){
  lost = false;
  for(int i = 0; i < mapSize*mapSize; i++){
    mapPos[i]=0;
  }
  mapGenerate();
}



//COLLISION OBJECT -----------------------------------------------------------------------------------------------------------------------------------------------------------------
class collisionObject {
  int obsX=-30;
  boolean fin, scored;
  int obsNum;
  int posY=totYOG+height/55;
  void drawObs() {
    if (obsNum==0)image(sushi1, obsX, posY, width/20, height/10);
    else if (obsNum==1)image(sushi2, obsX, posY, width/16, height/12);
    else if (obsNum==2 && millis()%200<=100)image(penguin1, obsX, posY, width/16, height/12);
    else if (obsNum==2)image(penguin2, obsX, posY, width/16, height/12);
    obsX-=speed;
    if (obsX>0) {
      noFill();
      rectMode(CORNERS);
      //rect(obsX-width/40,posY-height/34,obsX+width/32,posY+height/22);
      //rect(width/5+width/20,totY-width/20,width/5-width/30,totY+width/26);
      //rect(obsX-width/40, posY-height/34, obsX+width/32, posY+height/28);
      if (!boosting) {
        if (obsNum==0 && obsX-width/50<width/5+width/20 && obsX+width/40>width/5-width/30 && totY+width/26>posY-height/22 && !lost) {
          totoroDie();
        } else if (obsNum==1 && obsX-width/40<width/5+width/20 && obsX+width/32>width/5-width/30 && totY+width/26>posY-height/34 && !lost) {
          totoroDie();
        } else if (obsNum==2 && obsX-width/40<width/5+width/20 && obsX+width/32>width/5-width/30 && totY+width/26>posY-height/34 && !crouching && !lost) {
          totoroDie();
        }
      }
      if (!scored && obsX<width/5) {
        //score++;
        countdownInt++;
        scored=true;
      }
    } else if (fin) {
      if (millis()-timeLastSushi>2000) {
        reset();
      }
    } else if (!fin && timeLastSushi==0) {
      fin=true;
      timeLastSushi=millis();
    }
  }
  void reset() {
    obsX=width+width/int(random(4, 40));
    fin=false;
    obsNum=int(random(-0.49, 2.49));
    if (obsNum==2) posY=totYOG-height/9;
    else posY=totYOG+height/40;
    timeLastSushi=0;
    scored=false;
  }
}

//KEY PRESSED ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
void keyPressed() {
  if (gameMode==1) {
    if ((keyCode==32 || keyCode==38 || keyCode==87) && !totJumping && !crouching) {
      totJumping=true;
      totSpeedY=-height/45;
      totY+=totSpeedY;
    } else if ((keyCode==40 || keyCode==83) && !crouching && !totJumping) {
      crouching=true;
    }
  } else if (gameMode==2) {
    if (keyCode==37 || keyCode==65)xPressed=-1;
    else if (keyCode==39 || keyCode==68)xPressed=1;
    if (keyCode==38 || keyCode==87)yPressed=-1;
    else if (keyCode==40 || keyCode==83)yPressed=1;
  }
}

void mousePressed() {
  if (gameMode==-1) {
    if (mouseX>width/5*3-height/13 && mouseX<width/5*3+height/13 && mouseY>height/24*14-height/13 && mouseY<height/24*14+height/13)saveData[2]=str(int(saveData[2])*-1);
  }
}

void keyReleased() {
  if (gameMode==1 && crouching && (keyCode==40 || keyCode==83))crouching=false;
  else if (gameMode==2) {
    if (keyCode==37 || keyCode==65)xPressed=0;
    else if (keyCode==39 || keyCode==68)xPressed=0;
    if (keyCode==38 || keyCode==87)yPressed=0;
    else if (keyCode==40 || keyCode==83)yPressed=0;
  }
}

//SAVE INFO ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
void createSave() {
  saveData[0] = "50";
  saveData[1] = "50";
  saveData[2] = "-1";
  saveData[3] = "0";
  saveData[4] = "0";
  saveData[5] = "0";
  saveData[6] = "0";
  saveData[7] = "0";
  saveData[8] = "0";
  saveData[9] = "0";
  saveData[10] = "0";
  saveData[11] = "0";
}

void loadSave() {
  if (dataFile(fileName).isFile()) {
    saveData=loadStrings(dataPath(fileName));
  } else {
    createSave();
    saveSave();
  }
}

void saveSave() {
  saveStrings(dataPath(fileName), saveData);
}

//FADE FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
void credits(String role, String name, int duration) {
  fill(0, fadeInt);
  textFont(pixelatedFontBig);
  text(role, width/2, height/5*2);
  textFont(pixelatedFont);
  text(name, width/2, height/2);
  if ((fadeInt==0 && !fadeIn) || fadeIn) {
    fadeInt+=3;
    fadeIn=true;
    if (fadeInt>=253) {
      fadeIn=false;
      fadeInt=255;
    }
  }
  if (millis()-countdownInt>duration && !fadeIn) {
    fadeInt-=3;
    if (fadeInt<=3) {
      fadeInt=0;
      counter++;
      countdownInt=millis();
    }
  }
}

void fadeScreen() {
  fill(0, fadeInt);
  rectMode(CENTER);
  rect(width/2, height/2, width, height);
  fadeInt=int(map(millis()-countdownInt, 0, 1000, 0, 510));
  if (fadeInt>505) {
    screenFading=false;
  }
  if (fadeInt>255) {
    fadeInt=255-(fadeInt-255);
    if (!doneChange) {
      switch(goalMethod) {
      case 0:
        gameMode=0;
        break;
      case 1:
        gameMode=1;
        dinoInit();
        break;
      case 2:
        gameMode=2;
        resetNapTime();
        break;
      }
      doneChange=true;
    }
  }
}

//MAP GENERATION FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------------------
void mapGenerate() {

  if (random(0, 1)>0.5)sofaPos=mapSize*(int)random(5, mapSize-5)+1;
  else sofaPos=mapSize*(int)random(5, mapSize-5)+mapSize-1;

  xPos=sofaPos%mapSize;
  if (xPos==mapSize-1) {
    xPos-=1;
    rotation=PI;
  }
  yPos=floor(sofaPos/mapSize)-0.75;

  for (int x=0; x<mapSize; x++) {
    mapPos[x]=1;
  }
  for (int x=0; x<mapSize; x++) {
    mapPos[mapSize*(mapSize-1)+x]=1;
  }
  for (int y=0; y<mapSize; y++) {
    mapPos[y*mapSize]=1;
  }
  for (int y=0; y<mapSize; y++) {
    mapPos[y*mapSize+mapSize-1]=1;
  }


  for (int i=0; i<60; i++) {
    int tileY=int(random(3, mapSize-3));
    int wallLength=int(random(5, 35));
    int x=int(random(3, mapSize-3)), y=0;

    if (mapPos[mapSize*tileY+x]==1 || mapPos[mapSize*tileY+x+1]==1 || mapPos[mapSize*tileY+x-1]==1 || mapPos[mapSize*(tileY+1)+x]==1 || mapPos[mapSize*(tileY-1)+x]==1 || mapPos[mapSize*(tileY-2)+x]==1 || mapPos[mapSize*(tileY+2)+x]==1 || mapPos[mapSize*(tileY)+x+2]==1 || mapPos[mapSize*(tileY)+x-2]==1) {
      tileY=int(random(3, mapSize-3));
      x=int(random(3, mapSize-3));
      if (mapPos[mapSize*tileY+x]==1 || mapPos[mapSize*tileY+x+1]==1 || mapPos[mapSize*tileY+x-1]==1 || mapPos[mapSize*(tileY+1)+x]==1 || mapPos[mapSize*(tileY-1)+x]==1 || mapPos[mapSize*(tileY-2)+x]==1 || mapPos[mapSize*(tileY+2)+x]==1 || mapPos[mapSize*(tileY)+x+2]==1 || mapPos[mapSize*(tileY)+x-2]==1) {
        tileY=int(random(3, mapSize-3));
        x=int(random(3, mapSize-3));
      }
    }

    if (mapPos[mapSize*tileY+x]==0) {
      mapPos[mapSize*tileY+x]=1;

      //Extend wall
      for (int a=0; a<wallLength; a++) {
        //Up and down
        if (random(0, 1)>0.5 && a>1) {
          if (random(0, 1)>0.5 && mapPos[(mapSize*(tileY+y-1))+x]==0 && mapPos[(mapSize*(tileY+y-2))+x]==0 && mapPos[(mapSize*(tileY+y-3))+x]==0 && mapPos[(mapSize*(tileY+y-2))+x+1]==0 && mapPos[mapSize*(tileY+y-3)+x+1]==0 && mapPos[mapSize*(tileY+y-2)+x-1]==0 && mapPos[mapSize*(tileY+y-3)+x-1]==0 && mapPos[mapSize*(tileY+y-2)+x-2]==0 && mapPos[mapSize*(tileY+y-2)+x+2]==0 && mapPos[mapSize*(tileY+y-3)+x+2]==0 && mapPos[mapSize*(tileY+y-3)+x-2]==0) {
            mapPos[mapSize*(tileY+y-1)+x]=1;
            y--;
          } else if (mapPos[(mapSize*(tileY+y+1))+x]==0 && mapPos[(mapSize*(tileY+y+2))+x]==0 && mapPos[(mapSize*(tileY+y+3))+x]==0 && mapPos[(mapSize*(tileY+y+2))+x+1]==0 && mapPos[mapSize*(tileY+y+3)+x+1]==0 && mapPos[mapSize*(tileY+y+2)+x-1]==0 && mapPos[mapSize*(tileY+y+3)+x-1]==0 && mapPos[mapSize*(tileY+y+2)+x-2]==0 && mapPos[mapSize*(tileY+y+2)+x+2]==0 && mapPos[mapSize*(tileY+y+3)+x+2]==0 && mapPos[mapSize*(tileY+y+3)+x-2]==0) {
            mapPos[mapSize*(tileY+y+1)+x]=1;
            y++;
          } else {
            if (x+1<mapSize-3 && random(0, 1)>0.5 && mapPos[mapSize*(tileY+y)+x+1]==0 && mapPos[mapSize*(tileY+y)+x+2]==0 && mapPos[mapSize*(tileY+y)+x+3]==0 && mapPos[mapSize*(tileY+y-1)+x+2]==0 && mapPos[mapSize*(tileY+y-1)+x+3]==0 && mapPos[mapSize*(tileY+y+1)+x+2]==0 && mapPos[mapSize*(tileY+y+1)+x+3]==0 && mapPos[mapSize*(tileY+y+2)+x+2]==0 && mapPos[mapSize*(tileY+y-2)+x+2]==0 && mapPos[mapSize*(tileY+y-2)+x+3]==0 && mapPos[mapSize*(tileY+y+2)+x+3]==0) {
              mapPos[mapSize*(tileY+y)+x+1]=1;
              x++;
            }
          }
          //Right and left
        } else if (x+1<mapSize-3 && random(0, 1)>0.5 && mapPos[mapSize*(tileY+y)+x+1]==0 && mapPos[mapSize*(tileY+y)+x+2]==0 && mapPos[mapSize*(tileY+y)+x+3]==0 && mapPos[mapSize*(tileY+y-1)+x+2]==0 && mapPos[mapSize*(tileY+y-1)+x+3]==0 && mapPos[mapSize*(tileY+y+1)+x+2]==0 && mapPos[mapSize*(tileY+y+1)+x+3]==0 && mapPos[mapSize*(tileY+y+2)+x+2]==0 && mapPos[mapSize*(tileY+y-2)+x+2]==0 && mapPos[mapSize*(tileY+y-2)+x+3]==0 && mapPos[mapSize*(tileY+y+2)+x+3]==0) {
          mapPos[mapSize*(tileY+y)+x+1]=1;
          x++;
        } else if (x-1>3 && mapPos[mapSize*(tileY+y)+x-1]==0 && mapPos[mapSize*(tileY+y)+x-2]==0 && mapPos[mapSize*(tileY+y)+x-3]==0 && mapPos[mapSize*(tileY+y+1)+x-2]==0 && mapPos[mapSize*(tileY+y+1)+x-3]==0 && mapPos[mapSize*(tileY+y-1)+x-2]==0 && mapPos[mapSize*(tileY+y-1)+x-3]==0 && mapPos[mapSize*(tileY+y-2)+x-2]==0 && mapPos[mapSize*(tileY+y+2)+x-2]==0 && mapPos[mapSize*(tileY+y+2)+x-3]==0 && mapPos[mapSize*(tileY+y-2)+x-3]==0) {
          mapPos[mapSize*(tileY+y)+x-1]=1;
          x--;
        }
      }
    }
  }

  for (int i = 0; i<objs.length; i++)objs[i] = new pickupObject();
  for (int i = 0; i<objs.length; i++)objs[i].reset();

  score = 0;
  inventory = null;
  inventory = new int[3];
  timer = millis();
}



//PICKUP OBJECT CLASSES ------------------------------------------------------------------------------------------------------------------------------------------------------------
public class pickupObject {
  int position, type;
  float pixelX, pixelY;
  boolean closest, pickedUp;
  void reset() {
    position = int(random(0, mapSize*mapSize));
    type = (int)random(-0.49, 3.49);
    if (type==0)type=1;
    if (type!=3) {
      while (mapPos[position]!=0) {
        position = int(random(0, mapSize*mapSize));
      }
    } else {
      while (mapPos[position]!=0 || mapPos[position-1]!=0) {
        position = int(random(0, mapSize*mapSize));
      }
    }
    mapPos[position]=2;
  }

  void drawObject() {
    if (!pickedUp) {
      if (type!=3)pixelX=width/2+tileSize*((position%mapSize)-xPos);
      else pixelX=(width/2+tileSize*((position%mapSize)-xPos))-tileSize/2;
      pixelY=tileSize*((position-(position%mapSize))/mapSize-yPos+round(height/tileSize)/2);

      switch(type) {
      case 1:
        image(good1, pixelX, pixelY, tileSize, tileSize);
        break;
      case 2:
        image(good2, pixelX, pixelY, tileSize, tileSize);
        break;
      case 3:
        image(good3, pixelX, pixelY, tileSize*1.85, tileSize);
        break;
      }
      if (closest && dist(width/2, height/2, pixelX, pixelY)<200) {
        closestObjDist=dist(width/2, height/2, pixelX, pixelY);
        if (mousePressed && (inventory[0]==0 || inventory[1]==0 || inventory[2]==0)) {
          pickedUp=true;
          pixelX=width*1.5;
          pixelY=0;
          closestObjDist=200;
          //Add to inventory
          if (inventory[0]==0)inventory[0]=type;
          else if (inventory[1]==0)inventory[1]=type;
          else inventory[2]=type;
        }
      }
    }
  }
}

//Tenshi scooter
public class overlapObject {
  int xPosObj, yPosObj=totYOG+height/55;
  boolean coin, got;

  overlapObject(int a) {
    xPosObj = a;
  }

  void drawObject() {
    if (xPosObj>-20)xPosObj-=speed;
    else if (xPosObj<-48)xPosObj+=1;

    if (coin && !got)image(patata, xPosObj, yPosObj);
    else if (!got) image(boost, xPosObj, yPosObj);

    if (xPosObj-width/50<width/5+width/20 && xPosObj+width/50>width/5-width/30 && totY+width/26>yPosObj-height/22 && !got) {
      if (coin) {
        saveData[3]=str(int(saveData[3])+1);
        score++;
        got=true;
      } else {
        got=true;
        boosting=true;
        boostingTime=millis();
        speed+=15;
      }
    }

    if (xPosObj<-10 && xPosObj>-50 && millis()-timeLastSushi>500 && millis()-timeLastSushi<1800 && millis()-timeLastPickup>600) {
      reset();
    }
  }

  void reset() {
    xPosObj=width+20;
    got=false;
    timeLastPickup=millis();
    if (random(0, 1)>0.15)coin=true;
    else coin=false;
  }
}
