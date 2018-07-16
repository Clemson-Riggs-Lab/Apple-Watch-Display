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
    
    // Display Labels
    @IBOutlet var NameRoom: WKInterfaceLabel!
    @IBOutlet var MedicalIssue: WKInterfaceLabel!
    @IBOutlet var Data: WKInterfaceLabel!
    @IBOutlet var Et: WKInterfaceLabel!
    @IBOutlet var DirectionArrow: WKInterfaceLabel!
    @IBOutlet var underline: WKInterfaceSeparator!
    
    // Variables used to store data from Txt/CSV file
    var txtData: [String]?
    var patientNameRoom = [String]()
    var patientIssue = [String]()
    var patientData = [String]()
    var arrowTxt = [String]()
    var NBPData = [String]()
    var SpO2Data = [String]()
    var CO2Data = [String]()

    
    // Variables used to temporarily hold data that should be compared
    var currentPatientIssue = String()
    var currentData = String()
//    var prevData = String()

    // Iterate through data
    var rows = Int()
    var i = 0
    
    // File Info
    let fileName: String = "patients"
    let numCols = 5
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)

        // Format interface
        formatDisplay()
        setFontToBold()
        
        // Read txt file
        txtData = readTXTIntoArray(file: fileName)
        
        // Assign Labels proper data
        assignLables()

        // Start Timer
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
        // CSV-TXT Column Data
        let nameCol = 0
        let roomCol = 1
        let issueCol = 2
        let dataCol = 3
        let arrowCol = 4
        
        var index = 0
        while(index < (txtData?.count)!){
            patientNameRoom.append((txtData?[index + nameCol])! + " - " + (txtData?[index + roomCol])!)
            patientIssue.append((txtData?[index + issueCol])!)
            patientData.append((txtData?[index + dataCol])!)
            arrowTxt.append((txtData?[index + arrowCol])!)
            
            index += numCols
        }
    }
    
    func formatDisplay() {
        // Black out display labels
        NameRoom.setTextColor(UIColor.black)
        underline.setColor(UIColor.black)
        MedicalIssue.setTextColor(UIColor.black)
        Data.setTextColor(UIColor.black)
        Et.setTextColor(UIColor.black)
        DirectionArrow.setTextColor(UIColor.black)
    }
    
    func setFontToBold() {
        // Configure bold font
        let bold = NSMutableAttributedString(string: "Arial Bold (Code)")
        if let arialBoldFont = UIFont(name: "Arial-Bold", size: 35) {
            bold.addAttribute(NSAttributedStringKey.font,value: arialBoldFont, range: NSMakeRange(0, 21))
        }
        
        // Add bold font to labels
        MedicalIssue.setAttributedText(bold)
        Et.setAttributedText(bold)
        Data.setAttributedText(bold)
    }
    
    @objc func enableDisplay() {
        // Variable to store data strings as integers
//        var currentDataInt = Int()
        
//        Et.setTextColor(UIColor.black)
//        DirectionArrow.setTextColor(UIColor.black)
        
        currentPatientIssue = patientIssue[i]
        currentData = patientData[i]
        
        switch(currentPatientIssue) {
        case "NBP":
            NBPData.append(patientData[i])
            displayBP()
        case "SpO2":
            SpO2Data.append(patientData[i])
        
            // Get rid of % sign
            currentData = currentData.replacingOccurrences(of: "%", with: "")
//            currentDataInt = Int(currentData)!
            
            displaySP02()
        case "CO2":
            CO2Data.append(patientData[i])
//            currentDataInt = Int(currentData)!
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
        DirectionArrow.setText(String(UnicodeScalar(Int(arrowTxt[i], radix: 16)!)!))
        vibrationEffect()
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
        DirectionArrow.setText(String(UnicodeScalar(Int(arrowTxt[i], radix: 16)!)!))
        vibrationEffect()
        
/*      let standardSpO2 = 95
        let smalldrop = 5
        let slightdrop = 10
        let majordrop = 15
         
        if(standardSpO2 > currentDataInt) {
            if(standardSpO2 - currentDataInt >= majordrop) {
                // 45 Double Down Arrow
                DirectionArrow.setText("\u{21CA}")
                WKInterfaceDevice.current().play(.notification)
            }
            else if(standardSpO2 - currentDataInt >= slightdrop) {
                // 45 Single Down Arow
                DirectionArrow.setText("\u{2198}")
                WKInterfaceDevice.current().play(.stop)
            }
            else if(standardSpO2 - currentDataInt >= smalldrop) {
                // Vertical Down Arrow
                DirectionArrow.setText("\u{2193}")
                WKInterfaceDevice.current().play(.directionDown)
            }
        }
        else if(standardSpO2 < currentDataInt) {
            // Vertical Up Arrow
            DirectionArrow.setText("\u{2191}")
        }
        else {
            DirectionArrow.setText(" ")
        }
*/
    }
    
    func displayCO2() {
        NameRoom.setTextColor(UIColor.white)
        NameRoom.setText(patientNameRoom[i])
        
        underline.setColor(UIColor.white)
        
        MedicalIssue.setTextColor(UIColor.white)
        MedicalIssue.setText("CO2 mm Hg")
        
        Et.setTextColor(UIColor.white)
        Et.setText("Et")
        
        Data.setTextColor(UIColor.white)
        Data.setText(patientData[i])
        
        DirectionArrow.setTextColor(UIColor.white)
        DirectionArrow.setText(String(UnicodeScalar(Int(arrowTxt[i], radix: 16)!)!))
        vibrationEffect()
/*
        let standardEtCO2 = 35
        let smalldrop = 5
        let slightdrop = 10
        let majordrop = 15
         
        if(standardEtCO2 > currentDataInt) {
            if(standardEtCO2 - currentDataInt >= majordrop) {
                // 45 Double Down Arrow
                DirectionArrow.setText("\u{21CA}")
                WKInterfaceDevice.current().play(.notification)
            }
            else if(standardEtCO2 - currentDataInt >= slightdrop) {
                // 45 Single Down Arow
                DirectionArrow.setText("\u{2198}")
                WKInterfaceDevice.current().play(.stop)
            }
            else if(standardEtCO2 - currentDataInt >= smalldrop) {
                // Vertical Down Arrow
                DirectionArrow.setText("\u{2193}")
                WKInterfaceDevice.current().play(.directionDown)
            }
        }
        else if(standardEtCO2 < currentDataInt) {
            // Vertical Up Arrow
            DirectionArrow.setText("\u{2191}")
        }
        else {
            DirectionArrow.setText(" ")
        }
 */
    }
    
    func vibrationEffect() {
        switch(arrowTxt[i]) {
        case "2193":
            WKInterfaceDevice.current().play(.directionDown)
        case "2198":
            WKInterfaceDevice.current().play(.stop)
        case "21CA":
            WKInterfaceDevice.current().play(.notification)
        default:
            // FIXME: DONT FORGET TO CHANGE
            print("Error in arrowTXT")
        }
    }

    func checkIterator() {
        if(i >= rows) {
            i = 0
        }
    }
    
}
