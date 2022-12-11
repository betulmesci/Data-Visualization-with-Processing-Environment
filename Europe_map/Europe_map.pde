PImage mapImage;
Table locationTable;
Table nameTable;
int rowCount;

Table dataTable;
float dataMin = -10;
float dataMax = 10;
int num_pressed = 0;
Integrator[] interpolators;


void setup() {
  size(640, 600);
  //Load Europe map
  mapImage = loadImage("data/map.png");
  //Load x, y coordinates that coincide with country capitals
  locationTable = new Table("data/locations.tsv");
  //Load the name of the countries
  nameTable = new Table("data/countries.tsv");
  rowCount = locationTable.getRowCount();  
  //Load the statistical data 
  dataTable = new Table("data/data.tsv");
  //Initialize the integrator
  interpolators = new Integrator[rowCount];
  for (int row = 0; row < rowCount; row++) {
    float initialValue = dataTable.getFloat(row, 3);
    interpolators[row] = new Integrator(initialValue);
   
  }
  
  PFont font = loadFont("Univers-Bold-12.vlw");
  textFont(font);

  smooth();
  noStroke();  
  frameRate(40);
}

float closestDist;
String closestText;
float closestTextX;
float closestTextY;


void draw() {
  background(255);
  
  image(mapImage, 0, 0);
  //Print the title
  textSize(16);
  textAlign(CENTER);
  fill(#333366);
  text("Economic Measures of the European", 145, 25);
  text("Countries in 2022-Q2", 140, 45);
  
  
  for (int row = 0; row < rowCount; row++) {
    interpolators[row].update();
    
  }
  closestDist = width*height;  // abritrarily high
  
  for (int row = 0; row < rowCount; row++) {
    String abbrev = dataTable.getRowName(row);
    float x = locationTable.getFloat(abbrev, 1);
    float y = locationTable.getFloat(abbrev, 2);
   //Print subtitle identifying current statistics depending on the number of key strokes
    
    if (num_pressed % 3 == 0){
      fill(#ec5166);
      textSize(15) ;
      textAlign(CENTER);
      
      text("Current Account % of GDP", 140, 75);
      }
    if (num_pressed % 3 == 1){
      textAlign(CENTER);
      textSize(15);
      fill(#ec5166);
      text("Consumer Prices - Annual Inflation", 145, 75);
      }
  if (num_pressed % 3 == 2){
      textAlign(CENTER);
      textSize(15);
      fill(#ec5166);
      text("Monthly Unemployment Rate", 145, 75);
      }
  
 
 
   drawData(x, y, abbrev);
  }
  //Print country name and statistical data if mouse in bubble
  if (closestDist != width*height) {
    fill(30);
    textAlign(CENTER);
    text(closestText, closestTextX, closestTextY);
  }
  
}


void drawData(float x, float y, String abbrev) {
  
  
  // Figure out what row this is
  int row = dataTable.getRowIndex(abbrev);
  // Get the current value
  float value = interpolators[row].value;
  //Draw bubbles with sizes corresponding to the data
  float radius = 0;
  if (value >= 0) {
    radius = map(value, 0, dataMax, 1.5, 15);
    fill(#333366);  // blue
  } else {
    radius = map(value, 0, dataMin, 1.5, 15);
    fill(#ec5166);  // red
  }
  ellipseMode(RADIUS);
  ellipse(x, y, radius, radius);
  //If mouse in the the bubble, save country name and data
  float d = dist(x, y, mouseX, mouseY);
  if ((d < radius + 2) && (d < closestDist)) {
    closestDist = d;
    String name = nameTable.getString(abbrev, 1);
    String val = nfp(interpolators[row].target, 0, 2);
    closestText = name + " " + val;
    closestTextX = x+20;
    closestTextY = y-radius-4;
  }
}


void keyPressed() {
  
  if (key == ' ') {
    //Count number of key strokes
    num_pressed += 1;
    //if the key pressed, update current table
    updateTable(num_pressed);
  }
}


void updateTable(int num_pressed) {  
  //Update current table depending on the number key strokes
  if (num_pressed % 3 == 0){
  for (int row = 0; row < rowCount; row++) {
    float newValue = dataTable.getFloat(row, 3);
    interpolators[row].target(newValue);
  }
 
 
}
  else if (num_pressed % 3 == 1){
  for (int row = 0; row < rowCount; row++) {
    float newValue = dataTable.getFloat(row, 4);
    interpolators[row].target(newValue);
  }
  
}
  else if (num_pressed % 3 == 2){
  for (int row = 0; row < rowCount; row++) {
    float newValue = dataTable.getFloat(row, 5);
    interpolators[row].target(newValue);
  }
  
}
  
}
