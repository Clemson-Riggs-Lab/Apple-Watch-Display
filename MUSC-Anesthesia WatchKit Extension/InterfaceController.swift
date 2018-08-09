//
//  InterfaceController.swift
//  MUSC-Anesthesia WatchKit Extension
//
//  Created by Nicolas Threatt on 6/19/18.
//  Copyright © 2018 Riggs Lab. All rights reserved.
//

import WatchKit
import Foundation

var fileRecieve = String()

class InterfaceController: WKInterfaceController {

    // Display Labels
    @IBOutlet var NameRoom: WKInterfaceLabel!
    @IBOutlet var MedicalIssue: WKInterfaceLabel!
    @IBOutlet var Data: WKInterfaceLabel!
    @IBOutlet var Et: WKInterfaceLabel!
    @IBOutlet var DirectionArrow: WKInterfaceLabel!
    @IBOutlet var underline: WKInterfaceSeparator!

    // Variables used to store data from Txt/CSV file
    var patientNameRoom = [String](), patientIssue = [String](), patientData = [String](), arrowTxt = [String]()
    var currentPatientIssue = String()
    var fileName = String()
    let numCols = 6

    // Iterate through data
    var time = [Int]()
    var rows = Int()
    var i = 0
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)

        // Format interface
        formatDisplay()

        // Find correct file
        switch(fileRecieve) {
            case "File 1":
                fileName = "patients1"
            case "File 2":
                fileName = "patients2"
            case "File 3":
                fileName = "patients3"
            default:
                print(fileName)
        }

        // Read txt file and store its data
        let data = readTXTIntoArray(file: fileName)

        // Assign Labels proper data
        assignLables(txtData: data)
        
        // Asynchronously show display
        delay(seconds: Double(i))
    }
    
    func delay(seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
            self.enableDisplay()
        })
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

            // Calculate rows
            rows = contentsFiltered.count / numCols

            return contentsFiltered
        } catch {
            return nil
        }
    }

    func assignLables(txtData: [String]?) {
        // CSV-TXT Column Data
        let nameCol = 0, roomCol = 1, issueCol = 2, dataCol = 3, arrowCol = 4, delayCol = 5

        var index = 0
        while(index < (txtData?.count)!) {
            patientNameRoom.append((txtData?[index + nameCol])! + " - " + (txtData?[index + roomCol])!)
            patientIssue.append((txtData?[index + issueCol])!)
            patientData.append((txtData?[index + dataCol])!)
            arrowTxt.append((txtData?[index + arrowCol])!)
            time.append(Int((txtData?[index + delayCol])!)!)

            index += numCols
        }
    }

    func formatDisplay() {
        let bold = NSMutableAttributedString(string: "Arial Bold (Code)")
        if let arialBoldFont = UIFont(name: "Arial-Bold", size: 35) {
            bold.addAttribute(NSAttributedStringKey.font,value: arialBoldFont, range: NSMakeRange(0, 21))
        }
        
        NameRoom.setTextColor(UIColor.black)
        
        underline.setColor(UIColor.black)
        
        MedicalIssue.setTextColor(UIColor.black)
        MedicalIssue.setAttributedText(bold)
        
        Data.setTextColor(UIColor.black)
        Data.setAttributedText(bold)
        
        Et.setTextColor(UIColor.black)
        Et.setAttributedText(bold)
        
        DirectionArrow.setTextColor(UIColor.black)
        DirectionArrow.setAttributedText(bold)
    }


    func enableDisplay() {
        var NBPData = [String](), SpO2Data = [String](), CO2Data = [String]()
        var color = UIColor()

        currentPatientIssue = patientIssue[i]
        switch(currentPatientIssue) {
            case "NBP":
                NBPData.append(patientData[i])
                color = UIColor.magenta
            case "SpO2":
                SpO2Data.append(patientData[i])
                color = UIColor.cyan
            case "CO2":
                CO2Data.append(patientData[i])
                color = UIColor.white
            default:
                print(patientIssue[i])
        }

        displayInterface(interfaceColor: color)

        checkIterator()
    }

    func displayInterface(interfaceColor: UIColor) {
        NameRoom.setTextColor(interfaceColor)
        NameRoom.setText(patientNameRoom[i])

        underline.setColor(interfaceColor)

        MedicalIssue.setTextColor(interfaceColor)
        if(currentPatientIssue == "CO2") {
            MedicalIssue.setText("CO2 mm Hg")

            Et.setTextColor(interfaceColor)
            Et.setText("Et")
        } else {
            MedicalIssue.setText(patientIssue[i])
            Et.setTextColor(UIColor.black)
        }

        Data.setTextColor(interfaceColor)
        Data.setText(patientData[i])

        DirectionArrow.setTextColor(interfaceColor)
        DirectionArrow.setText(String(UnicodeScalar(Int(arrowTxt[i], radix: 16)!)!))

        vibrationEffect()
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
                print(arrowTxt[i])
        }
    }

    func checkIterator() {
        // Update iterator
        i += 1
        
        if(i >= rows) {
            // Black out screen
            formatDisplay()
            
            // Change Interface
            let rootControllerIdentifier = "StartView"
            WKInterfaceController.reloadRootControllers(withNamesAndContexts: [(name: rootControllerIdentifier, context: [:] as AnyObject)])
        } else {
            // Asynchronously show display
            let duration = Double(time[i]) - Double(time[i - 1])
            delay(seconds: duration)
        }
    }

}
