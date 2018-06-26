//
//  readingCSV.cpp
//  MUSC-Anesthesia WatchKit Extens∫ion
//
//  Created by Nicolas Threatt on 6/25/18.
//  Copyright © 2018 Riggs Lab. All rights reserved.
//

#include <iostream>
#include <fstream>
#include <string.h>
#include "readingCSV.h"

using namespace std;

// Path to CSV file
string filepath = "/Users/nicolasthreatt/Desktop/MUSC-Apple-Watch-Display/patients.csv";

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

char **readData()
{
    int i = 0;
    int csvRows = countRows();
    
    char **csvContent = nullptr;
    
    string line;
    
    ifstream csvFile;
    
    *csvContent = new char[csvRows];
    
    csvFile.open(filepath);
    while(csvFile.good()) {
        getline(csvFile, line, ',');
        
        csvContent[i] = new char[line.length() + 1];
        
        for(int j = 0; j < line.length(); j++)
        {
            csvContent[i][j] = line[j];
        }
        i++;
    }
    csvFile.close();
    
    return(csvContent);
}
