//
//  InterfaceController.swift
//  MUSC-Anesthesia WatchKit Extension
//
//  Created by Nicolas Threatt on 6/19/18.
//  Copyright © 2018 Riggs Lab. All rights reserved.
//

import WatchKit
import Foundation
import CSV

class InterfaceController: WKInterfaceController {
    @IBOutlet var NameRoom: WKInterfaceLabel!
    @IBOutlet var MedicalIssue: WKInterfaceLabel!
    @IBOutlet var Data: WKInterfaceLabel!
    
    var rows = [[String]]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        NameRoom.setTextColor(UIColor.magenta)
        NameRoom.setText("Smith - OR 1")
//        NameRoom.setText(rows[0][0])
        
        MedicalIssue.setTextColor(UIColor.magenta)
        MedicalIssue.setText("NBP")
        
        Data.setTextColor(UIColor.magenta)
        Data.setText("100/60")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
 //       readCSV()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func readCSV() {
        let stream = InputStream(fileAtPath: "/Users/nicolasthreatt/Desktop/MUSC-Apple-Watch-Display/patients.csv")!
        let csv = try! CSVReader(stream: stream)
        while let CSVrow = csv.next() {
            rows.append(CSVrow)
        }
    }
    
}
