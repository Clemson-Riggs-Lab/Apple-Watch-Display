//
//  InterfaceController.swift
//  MUSC-Anesthesia WatchKit Extension
//
//  Created by Nicolas Threatt on 6/19/18.
//  Copyright © 2018 Riggs Lab. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    @IBOutlet var NameRoom: WKInterfaceLabel!
    @IBOutlet var MedicalIssue: WKInterfaceLabel!
    @IBOutlet var Data: WKInterfaceLabel!
    @IBOutlet var Et: WKInterfaceLabel!
    
    var txtData: [String]?
    var patientNameRoom = [String]()
    var patientIssue = [String]()
    var patientData = [String]()
    
    var rows = Int()
    var i = 0
    
    let fileName: String = "patients"
    
    let nameCol = 0
    let roomCol = 1
    let issueCol = 2
    let dataCol = 3
    let numCols = 4
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)

        NameRoom.setTextColor(UIColor.black)
        MedicalIssue.setTextColor(UIColor.black)
        Data.setTextColor(UIColor.black)
        Et.setTextColor(UIColor.black)
        
        txtData = readTXTIntoArray(file: fileName)
        assignLables()
        
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(enableDisplay), userInfo: nil, repeats: true)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func readTXTIntoArray(file: String) -> [String]? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") else {
            return nil
        }
            
        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            
            // Filter array
            var contentsFiltered = content.components(separatedBy: ["\n", ",", "\t", "\r"])
            contentsFiltered = contentsFiltered.filter({$0 != ""})
            
            for _ in 0..<numCols  {
                contentsFiltered.removeFirst()
            }
            
            rows = contentsFiltered.count / numCols
            
            return contentsFiltered
        } catch {
            return nil
        }
    }
    
    func assignLables() {
        var index = 0
        while(index < (txtData?.count)!){
            patientNameRoom.append((txtData?[index + nameCol])! + " - " + (txtData?[index + roomCol])!)
            patientIssue.append((txtData?[index + issueCol])!)
            patientData.append((txtData?[index + dataCol])!)
            
            index += numCols
        }
    }
    
    @objc func enableDisplay() {
        Et.setTextColor(UIColor.black)
        
        switch(patientIssue[i]) {
        case "NBP":
            displayBP()
        case "SpO2":
            displaySP02()
        case "CO2":
            displayCO2()
        default:
            print(patientIssue[i])
        }
        
        i += 1
        checkIterator()
    }
   
    func displayBP() {
        NameRoom.setTextColor(UIColor.magenta)
        NameRoom.setText(patientNameRoom[i])
        
        MedicalIssue.setTextColor(UIColor.magenta)
        MedicalIssue.setText(patientIssue[i])
        
        Data.setTextColor(UIColor.magenta)
        Data.setText(patientData[i])
    }
    
    func displaySP02() {
        NameRoom.setTextColor(UIColor.cyan)
        NameRoom.setText(patientNameRoom[i])
        
        MedicalIssue.setTextColor(UIColor.cyan)
        MedicalIssue.setText(patientIssue[i])
        
        Data.setTextColor(UIColor.cyan)
        Data.setText(patientData[i])
    }
    
    func displayCO2() {
        NameRoom.setTextColor(UIColor.white)
        NameRoom.setText(patientNameRoom[i])
        
        MedicalIssue.setTextColor(UIColor.white)
        MedicalIssue.setText("CO2 mm Hg")
        Et.setTextColor(UIColor.white)
        
        Data.setTextColor(UIColor.white)
        Data.setText(patientData[i])
        
    }
    
    func checkIterator() {
        if(i >= rows) {
            i = 0
        }
    }
}
