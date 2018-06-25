//
//  readingCSV.hpp
//  MUSC-Anesthesia WatchKit Extension
//
//  Created by Nicolas Threatt on 6/25/18.
//  Copyright © 2018 Riggs Lab. All rights reserved.
//

#ifndef readingCSV_hpp
#define readingCSV_hpp

using namespace std;

// Path to CSV file
string filepath = "/Users/nicolasthreatt/Desktop/MUSC-Apple-Watch-Display/patients.csv";

// Count number of rows in CSV file
int countRows();

// Get data from CSV file
string *readData(int csvRows);

#endif /* readingCSV_hpp */
