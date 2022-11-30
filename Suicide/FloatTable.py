import csv
class Coord :
    # X,Y
    Screen = [720,520]
    # X1,Y1, X2,Y2
    DrawWindow = [0,0,0,0]
    # Left, Bottom, Right, TOP
    Label = [0,0,0,0,0,0,0,0]
    
class Column :
    Year = 0
    #Self-harm = 1
    
    
    
class FloatTable :
    def __init__(self,fileName,columnTypes) :
        self.columnNames = []
        self.fileName = fileName
        self.columnNames = []
        self.columnTypes = columnTypes
        self.rows = []
        self.totalMin = None
        self.totalMax = None
        #print(self.fileName)
        with open(self.fileName,"r") as newFile :
            self.csvReader = csv.reader(newFile,delimiter="\t")
            for index,line in enumerate(self.csvReader) :
                if index == 0 :
                    self.columnNames = line
                    self.columnCount = len(self.columnNames)
                else :
                    newLine = self.transformType(line)
                    self.rows.append(newLine)
        newFile.close()

    def transformType(self,line) : 
        newType = []
        for i in range(len(line)) :
            if self.columnTypes[i] == "Integer" :
                newType.append(int(line[i]))
            elif self.columnTypes[i] == "Float" :
                v = float(line[i])
                if self.totalMin == None :
                    self.totalMin = v
                else :
                    if v < self.totalMin :
                        self.totalMin = v
                        
                if self.totalMax == None :
                    self.totalMax = v 
                else :
                    if v > self.totalMax :
                        self.totalMax = v
                newType.append(v)   
            elif self.columnTypes == "String" :
                newType.append(line[i])
        return newType
 
    def getData(self,row,col) :
        return self.rows[row][col]
    
    def getColumn(self,col) :
        colList = []
        for i in range(len(self.rows)) :
            colList.append(self.rows[i][col])
        return colList
       
    def getNumColumns(self) :
        return len(self.currentColumnList)
    
    def getNumRows(self) :
        return len(self.rows)
    
    def getMax(self) :
        return max(self.currentColumnList)
    
    def getMin(self) :
        return min(self.currentColumnList)
    
    def getTotalMax(self) :
        return self.totalMax
    
    def getTotalMin(self) : 
        return self.totalMin
        
    def printFile(self) :
        print(self.rows)
        
    def getFileName(self) :
        return [self.columnNames,self.columnCount]
    
    
    def getHeader(self) :
        return self.columnNames
