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
    @IBOutlet var DirectionArrow: WKInterfaceLabel!
    @IBOutlet var underline: WKInterfaceSeparator!
    
    var txtData: [String]?
    var patientNameRoom = [String]()
    var patientIssue = [String]()
    var patientData = [String]()
    
    var NBPData = [String]()
    var SpO2Data = [String]()
    var CO2Data = [String]()
    
    var currentPatientIssue = String()
    var specifiedIssue = String()
    var currentData = String()
    var prevData = String()
    
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
        underline.setColor(UIColor.black)
        MedicalIssue.setTextColor(UIColor.black)
        Data.setTextColor(UIColor.black)
        Et.setTextColor(UIColor.black)
        DirectionArrow.setTextColor(UIColor.black)

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
        DirectionArrow.setTextColor(UIColor.black)
        
        currentPatientIssue = patientIssue[i]
        currentData = patientData[i]
        
        switch(currentPatientIssue) {
        case "NBP":
            specifiedIssue = patientIssue[i]
            
            NBPData.append(patientData[i])
            if(NBPData.count >= 2) {
                prevData = NBPData[NBPData.count - 2]
            }
            else {
                prevData = currentData
            }
            
            displayBP()
        case "SpO2":
            specifiedIssue = patientIssue[i]
            
            SpO2Data.append(patientData[i])
            if(SpO2Data.count >= 2) {
                prevData = SpO2Data[SpO2Data.count - 2]
            }
            else {
                prevData = currentData
            }
            
            prevData = prevData.replacingOccurrences(of: "%", with: "")
            currentData = currentData.replacingOccurrences(of: "%", with: "")
            
            displaySP02()
        case "CO2":
            specifiedIssue = patientIssue[i]
            
            CO2Data.append(patientData[i])
            if(CO2Data.count >= 2) {
                
                prevData = CO2Data[CO2Data.count - 2]
            }
            else {
                prevData = currentData
            }
            
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
        
        underline.setColor(UIColor.magenta)
        
        MedicalIssue.setTextColor(UIColor.magenta)
        MedicalIssue.setText(patientIssue[i])
        
        Data.setTextColor(UIColor.magenta)
        Data.setText(patientData[i])
        
        DirectionArrow.setTextColor(UIColor.magenta)
    }
    
    func displaySP02() {
        NameRoom.setTextColor(UIColor.cyan)
        NameRoom.setText(patientNameRoom[i])
        
        underline.setColor(UIColor.cyan)
        
        MedicalIssue.setTextColor(UIColor.cyan)
        MedicalIssue.setText(patientIssue[i])
        
        Data.setTextColor(UIColor.cyan)
        Data.setText(patientData[i])
        
        DirectionArrow.setTextColor(UIColor.cyan)
        checkPatient()
    }
    
    func displayCO2() {
        NameRoom.setTextColor(UIColor.white)
        NameRoom.setText(patientNameRoom[i])
        
        underline.setColor(UIColor.white)
        
        MedicalIssue.setTextColor(UIColor.white)
        MedicalIssue.setText("CO2 mm Hg")
        Et.setTextColor(UIColor.white)
        
        Data.setTextColor(UIColor.white)
        Data.setText(patientData[i])
        
        DirectionArrow.setTextColor(UIColor.white)
//        checkPatient()
    }
    
    func checkPatient() {
        let slightdrop = 10
        let majordrop = 15
        
        if(i > 0) {
            if ( currentPatientIssue == specifiedIssue ) {

                let prevDataInt:Int? = Int(prevData)
                let currentDataInt:Int? = Int(currentData)
                
                if (prevDataInt == currentDataInt) {
                    // Display nothing
                    DirectionArrow.setText(" ")
                }
                else if (prevDataInt! > currentDataInt!) {
                    
                    if( (prevDataInt! - currentDataInt!) >= slightdrop) {
                        // 45 Single Down Arow
                        DirectionArrow.setText("\u{2198}")
                        if( (prevDataInt! - currentDataInt!) >= majordrop) {
                            // 45 Double Down Arrow
                            DirectionArrow.setText("\u{21D8}")
                        }
                    }
                    else {
                        // Vertical Down Arrow
                        DirectionArrow.setText("\u{2193}")
                    }
                }
                else if (prevDataInt! < currentDataInt!) {
                    
                    if( (prevDataInt! - currentDataInt!) <= slightdrop) {
                        // 45 Single Up Arow
                        DirectionArrow.setText("\u{2196}")
                        if( (prevDataInt! - currentDataInt!) <= majordrop) {
                            // 45 Double Up Arrow
                            DirectionArrow.setText("\u{21D7}")
                        }
                    }
                    else {
                        // Display Up Arrow
                        DirectionArrow.setText("\u{2191}")
                    }
                }
            }
        }
    }
    
    func checkIterator() {
        if(i >= rows) {
            i = 0
        }
    }
    
}
