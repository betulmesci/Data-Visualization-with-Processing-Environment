import FloatTable
import FloatTable
#from FloatTable import Column
from FloatTable import Coord
import math

floatTable = FloatTable.FloatTable("suicide.tsv",["Integer","Float"])
rowCount = floatTable.getNumRows()
#floatTable.printFile()
header = floatTable.getHeader()
yearInterval = 10
barWidth = 15
index = 1
integerList = floatTable.getColumn(0)
dataList = floatTable.getColumn(1)
interval = 1000
dataMax = ceil(max(dataList)/interval)*interval
dataMin = floor(min(dataList)/interval)*interval

def setup():
    size(Coord.Screen[0], Coord.Screen[1])
    

    #X1,Y1
    Coord.DrawWindow = [100,60,width-80,height-70]
    # I PUT THE COORDINATES OF THE LEFT LABEL HERE, YOU PUT THE REST
    
    #LEFT 
    Coord.Label[0] = 50
    Coord.Label[1] = (Coord.DrawWindow[1] + Coord.DrawWindow[3])/ 2

    
    #CENTER
    Coord.Label[2] = (Coord.DrawWindow[0] + Coord.DrawWindow[2]) / 2
    Coord.Label[3] = height - 35
    
      #LEFT 
    Coord.Label[4] = 370
    Coord.Label[5] = 30
    
    #CENTER
    Coord.Label[6] = 680
    Coord.Label[7] = 250
    plotFont = createFont("TimesNewRoman", 20)
    textFont(plotFont)
    smooth(2)
    
   
    
def draw():
    createDrawingWindow()
    drawXTickMarks()
    drawYTickMarks()
    drawDataBars()
    drawGraphLabels()
    mouseMove()

   
    
def drawDataBars() :
    global rowCount
    global barWidth
    global dataMin
    global dataMax
    global index
    
    # Disable drawing the outline
    noStroke()
    
    # THE HEXADECIMAL COLOR
    fill(125)
    
    # SPECIFY X1,Y!, X2,Y2 ( Upper left, lower right)
    rectMode(CORNERS)

    for row in range(rowCount) :
        value = floatTable.getData(row,index)
       
        x = map(integerList[row], integerList[0], integerList[-1], Coord.DrawWindow[0], Coord.DrawWindow[2]) 
       
    
        y = map(value, dataMin, dataMax, Coord.DrawWindow[3], Coord.DrawWindow[1]) 
       
        
        rect(x-barWidth/2, y, x+barWidth/2, Coord.DrawWindow[3])
        
def mouseMove():            
     for row in range(rowCount) :

             
        value = floatTable.getData(row,index)
        
        x = map(integerList[row], integerList[0], integerList[-1], Coord.DrawWindow[0], Coord.DrawWindow[2]) 
      
    
        y = map(value, dataMin, dataMax, Coord.DrawWindow[3], Coord.DrawWindow[1]) 
        
        if mouseX > x-barWidth/2 and mouseX < x+barWidth/2:
            textSize(13)
            fill("#580804")
            
            if row == 0:
                text(int(dataList[row]), x+13, y-15)
                text(integerList[row], x+13, y-5)
            elif row == range(rowCount)[-1]:
                text(int(dataList[row]), x-12, y-15)
                text(integerList[row], x-12, y-5)
            else:
                text(int(dataList[row]), x, y-15)  
                text(integerList[row], x, y-5)              
 
        
        
def drawGraphLabels() :
    fill(50)
    textSize(15)
    textAlign(CENTER,CENTER)
    text("Year", Coord.Label[2], Coord.Label[3])
    text("Suicide\nNumbers", Coord.Label[0]-10,  Coord.Label[1])
    text("Suicide Numbers per Year in the US", Coord.Label[4],  Coord.Label[5])
    text("x1000",Coord.Label[6],  Coord.Label[7] )
    
def drawXTickMarks() :
  
    fill(50)
    textSize(10)
    textAlign(CENTER)
     
    
    # Use thin, gray lines to draw the grid.
    stroke(224)
    strokeWeight(1)
     

    #print(range(rowCount))    
    for row in range(rowCount) :
        
        if integerList[row]%5==0:
            x = map(integerList[row], integerList[0], integerList[-1], Coord.DrawWindow[0], Coord.DrawWindow[2])
            text(integerList[row], x, Coord.DrawWindow[3] +textAscent() + 10)
      
            #Long verticle line over each year interval
            line(x, Coord.DrawWindow[1], x, Coord.DrawWindow[3])
    
def drawYTickMarks():
    fill(50)
    textSize(10)
    textAlign(RIGHT)
    stroke(224)
    strokeWeight(1)
    
    for i in range(33000,48000, 1000):
        y=map(i, dataMin, dataMax, Coord.DrawWindow[3], Coord.DrawWindow[1])    
        text(i//1000, Coord.DrawWindow[1] +textAscent()+17, y)
        line(Coord.DrawWindow[0]-5, y, Coord.DrawWindow[2]+5,y)
        
    


def createDrawingWindow() :
    fill(255)
    rectMode(CORNERS)
    rect(Coord.DrawWindow[0]-7,Coord.DrawWindow[1]-7,Coord.DrawWindow[2]+7,Coord.DrawWindow[3])
    
