FloatTable data;
float dataMin, dataMax;

float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;

int rowCount;
int columnCount;
int currentColumn = 0;

int yearMin, yearMax;
int[] years;

int yearInterval = 5;
int volumeInterval = 10000;
int volumeIntervalMinor = 2500;

float[] tabLeft, tabRight;
float tabTop, tabBottom;
float tabPad = 10;

Integrator[] interpolators;

PFont plotFont; 


void setup() {
  size(770, 500);
  
  data = new FloatTable("death3.tsv");
  rowCount = data.getRowCount();
  columnCount = data.getColumnCount();
  
  years = int(data.getRowNames());
  yearMin = years[0];
  yearMax = years[years.length - 1];
  
  dataMin = 0;
  dataMax = ceil(data.getTableMax() / volumeInterval) * volumeInterval;

  interpolators = new Integrator[rowCount];
  for (int row = 0; row < rowCount; row++) {
    float initialValue = data.getFloat(row, 0);
    interpolators[row] = new Integrator(initialValue);
    interpolators[row].attraction = 0.1;  // Set lower than the default
  }

  plotX1 = 120; 
  plotX2 = width - 80;
  labelX = 50;
  plotY1 = 150;
  plotY2 = height - 70;
  labelY = height - 25;
  
  plotFont = createFont("SansSerif", 15);
  textFont(plotFont);

  smooth();
}


void draw() {
  background(224);
  
  // Show the plot area as a white box  
  fill(255);
  rectMode(CORNERS);
  noStroke();
  rect(plotX1-10, plotY1, plotX2+10, plotY2);

  drawTitleTabs();
  drawAxisLabels();

   for (int row = 0; row < rowCount; row++) {
    interpolators[row].update();
  }

  drawYearLabels();
  drawVolumeLabels();

  noStroke();
  fill(#5679C1);
  if (currentColumn==0){
  drawDataArea(currentColumn);}
  else if (currentColumn==1){
    drawDataBars(currentColumn);}
    else if (currentColumn==2){
      drawDataLine(currentColumn);}
      else if (currentColumn==3){
      drawDataPoints(currentColumn);}
}


void drawTitleTabs() {
  rectMode(CORNERS);
  noStroke();
  textSize(15);
  textAlign(LEFT);

  // On first use of this method, allocate space for an array
  // to store the values for the left and right edges of the tabs
  if (tabLeft == null) {
    tabLeft = new float[columnCount];
    tabRight = new float[columnCount];
  }
  
  float runningX = plotX1; 
  tabTop = plotY1 - textAscent() - 15;
  tabBottom = plotY1;
  
  for (int col = 0; col < columnCount; col++) {
    textSize(15);
    String title = data.getColumnName(col);
    tabLeft[col] = runningX; 
    float titleWidth = textWidth(title);
    tabRight[col] = tabLeft[col] + tabPad + titleWidth + tabPad;
    
    // If the current tab, set its background white, otherwise use pale gray
    fill(col == currentColumn ? 255 : 224);
    rect(tabLeft[col]-10, tabTop, tabRight[col], tabBottom);
    
    // If the current tab, use black for the text, otherwise use dark gray
    textSize(15);
    fill(col == currentColumn ? 0 : 64);
    text(title, runningX + tabPad-10, plotY1 - 10);
    
   
   
     
    //textAlign(CENTER,CENTER);
    //fill(col == currentColumn ? 0 : 224);
    if (col==currentColumn){
     fill(0);
     String plot_title = "Deaths Caused by " + title; 
     textSize(20);
     float plot_titleWidth = textWidth(plot_title);
     text(plot_title, (plotX1+plotX2)/2-plot_titleWidth/2, 60);
    }
     runningX = tabRight[col];
  }
}


void mousePressed() {
  if (mouseY > tabTop && mouseY < tabBottom) {
    for (int col = 0; col < columnCount; col++) {
      if (mouseX > tabLeft[col] && mouseX < tabRight[col]) {
        setCurrent(col);
        
      }
    }
  }
}


void setCurrent(int col) {
  currentColumn = col;
  
  for (int row = 0; row < rowCount; row++) {
    interpolators[row].target(data.getFloat(row, col));
  }
}


void drawAxisLabels() {
  fill(0);
  //textSize(20);
  //textLeading(15);
  
  //textAlign(CENTER);
  //text("Deaths Caused by ", (plotX1+plotX2)/2-20, 50);
  textSize(15);
  textAlign(CENTER, CENTER);
  text("Number \nof \nPeople \n(Thousands)", labelX-5, (plotY1+plotY2)/2);
  textAlign(CENTER);
  text("Year", (plotX1+plotX2)/2, labelY);
}


void drawYearLabels() {
  fill(0);
  textSize(10);
  textAlign(CENTER);
  
  // Use thin, gray lines to draw the grid
  stroke(224);
  strokeWeight(1);
  
  for (int row = 0; row < rowCount; row++) {
    if (years[row] % yearInterval == 0) {
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      text(years[row], x, plotY2 + textAscent() + 10);
      stroke(0);
      line(x, plotY2, x, plotY2+8);
    } else { 
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      line(x, plotY2, x, plotY2+4);
    }
  }
}


void drawVolumeLabels() {
  fill(0);
  textSize(10);
  textAlign(RIGHT);
  
  stroke(128);
  strokeWeight(1);

  for (float v = dataMin; v <= dataMax; v += volumeIntervalMinor) {
    if (v % volumeIntervalMinor == 0) {     // If a tick mark
      float y = map(v, dataMin, dataMax, plotY2, plotY1); 
      if (v % volumeInterval == 0) {        // If a major tick mark
        float textOffset = textAscent()/2;  // Center vertically
        if (v == dataMin) {
          textOffset = 0;                   // Align by the bottom
        } else if (v == dataMax) {
          textOffset = textAscent()/2;        // Align by the top
        }
        text(floor(v)/1000, plotX1 - 17, y + textOffset);
        line(plotX1 - 14, y, plotX1-10, y);     // Draw major tick
      } else {
        stroke(0); 
        line(plotX1 - 12, y, plotX1-10, y);   // Draw minor tick
      }
    }
  }
}
float barWidth = 8;  

void drawDataBars(int col) {
  stroke(#5679C1);
  //noStroke();
  rectMode(CORNERS);
  
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = interpolators[row].value;
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      rect(x-barWidth/2, y, x+barWidth/2, plotY2);
      if (x-barWidth/2 < mouseX & mouseX < x+barWidth/2){
        textAlign(LEFT);
        textSize(10);
        text(int(data.getFloat(row, col))+"\n"+ years[row],x, y-30);} 
    }
  }
}

void drawDataArea(int col) {
  stroke(#5679C1);
  beginShape();
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = interpolators[row].value;
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      vertex(x, y);
      if (x-barWidth/2 < mouseX & mouseX < x+barWidth/2){
        textAlign(LEFT);
        textSize(10);
        text(int(data.getFloat(row, col))+"\n"+ years[row],x, y-30);} 
    
    }  
  }
  vertex(plotX2, plotY2);
  vertex(plotX1, plotY2);
  endShape(CLOSE);
}
void drawDataLine(int col) {
  stroke(#5679C1);
  strokeWeight(5);
  noFill();
  beginShape();
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      float value = interpolators[row].value;
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);   
      vertex(x, y);
      if (x-barWidth/2 < mouseX & mouseX < x+barWidth/2){
        textAlign(LEFT);
        textSize(10);
        text(int(data.getFloat(row, col))+"\n"+ years[row],x, y-30);}
    }
  }
  
  endShape();
}

// Draw the data as a series of points 
void drawDataPoints(int col) { 
  
  stroke(#5679C1);
  strokeWeight(5);
  noFill();
  for (int row = 0; row < rowCount; row++) { 
    if (data.isValid(row, col)) { 
      float value = interpolators[row].value;
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2); 
      float y = map(value, dataMin, dataMax, plotY2, plotY1); 
      point(x, y); 
      if (x-barWidth/2 < mouseX & mouseX < x+barWidth/2){
        textAlign(LEFT);
        textSize(10);
        text(int(data.getFloat(row, col))+"\n"+ years[row],x, y-30);}
    } 
  } 
} 
