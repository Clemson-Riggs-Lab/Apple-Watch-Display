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

    // File Info
    let fileName: String = "patients"
    let numCols = 5

    // Variables used to store data from Txt/CSV file
    var currentPatientIssue = String()
    var patientNameRoom = [String]()
    var patientIssue = [String]()
    var patientData = [String]()
    var arrowTxt = [String]()

    // Iterate through data
    var rows = Int()
    var i = 0

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)

        // Format interface
        formatDisplay()

        // Read txt file and store its data
        var data: [String]?
        data = readTXTIntoArray(file: fileName)

        // Assign Labels proper data
        assignLables(txtData: data)

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

            // Calculate rows
            rows = contentsFiltered.count / numCols

            return contentsFiltered
        } catch {
            return nil
        }
    }

    func assignLables(txtData: [String]?) {
        // CSV-TXT Column Data
        let nameCol = 0
        let roomCol = 1
        let issueCol = 2
        let dataCol = 3
        let arrowCol = 4

        var index = 0
        while(index < (txtData?.count)!) {
            patientNameRoom.append((txtData?[index + nameCol])! + " - " + (txtData?[index + roomCol])!)
            patientIssue.append((txtData?[index + issueCol])!)
            patientData.append((txtData?[index + dataCol])!)
            arrowTxt.append((txtData?[index + arrowCol])!)

            index += numCols
        }
    }

    func formatDisplay() {
        NameRoom.setTextColor(UIColor.black)
        underline.setColor(UIColor.black)
        MedicalIssue.setTextColor(UIColor.black)
        Data.setTextColor(UIColor.black)
        Et.setTextColor(UIColor.black)
        DirectionArrow.setTextColor(UIColor.black)

        setFontToBold()
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
        DirectionArrow.setAttributedText(bold)
    }

    @objc func enableDisplay() {
        var NBPData = [String]()
        var SpO2Data = [String]()
        var CO2Data = [String]()
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

        i += 1
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
