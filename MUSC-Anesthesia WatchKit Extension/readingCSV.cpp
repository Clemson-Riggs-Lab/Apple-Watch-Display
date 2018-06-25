//
//  readingCSV.cpp
//  MUSC-Anesthesia WatchKit Extension
//
//  Created by Nicolas Threatt on 6/25/18.
//  Copyright © 2018 Riggs Lab. All rights reserved.
//

#include <iostream>
#include <fstream>
#include "readingCSV.hpp"

using namespace std;

int main()
{
    int numRows = countRows();
    readData(numRows);
    
    return(0);
}

int countRows()
{
    int numLines = 0;
    
    ifstream csvFile;
    
    csvFile.open(filepath);
    while(csvFile.good()) {
        numLines++;
    }
    csvFile.close();
    
    return(numLines);
}

string *readData(int csvRows)
{
    int i = 0;
    
    string *csvContent;
    string line;
    
    ifstream csvFile;
    
    csvContent = new string[csvRows];
    
    csvFile.open(filepath);
    while(csvFile.good()) {
        getline(csvFile, line, ',');
        csvContent[i] = line;
        i++;
        
    }
    csvFile.close();
    
    return(csvContent);
}

