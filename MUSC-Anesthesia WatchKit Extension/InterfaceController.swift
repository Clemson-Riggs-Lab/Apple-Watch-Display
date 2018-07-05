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
    
    @IBOutlet var underline: WKInterfaceSeparator!

    @IBOutlet var DirectionArrow: WKInterfaceImage!
    
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
        underline.setColor(UIColor.black)
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
        _ = UIBezierPath.arrow(from: CGPoint(x: 5, y: 10), to: CGPoint(x: 20, y: 5), tailWidth: 5, headWidth: 13, headLength: 20)
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
        
        underline.setColor(UIColor.magenta)
        
        MedicalIssue.setTextColor(UIColor.magenta)
        MedicalIssue.setText(patientIssue[i])
        
        Data.setTextColor(UIColor.magenta)
        Data.setText(patientData[i])
    }
    
    func displaySP02() {
        NameRoom.setTextColor(UIColor.cyan)
        NameRoom.setText(patientNameRoom[i])
        
        underline.setColor(UIColor.cyan)
        
        MedicalIssue.setTextColor(UIColor.cyan)
        MedicalIssue.setText(patientIssue[i])
        
        Data.setTextColor(UIColor.cyan)
        Data.setText(patientData[i])
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
    }
    
    func checkPatient() {
        
        if(i > 0) {
            let prevPatientData:Int? = Int(patientData[i - 1])
            let currentPatientData:Int? = Int(patientData[i])
            
            if (prevPatientData == currentPatientData) {
                // Display nothing

            }
            else if (prevPatientData! > currentPatientData!) {
                // Display down
                
                
            }
            else if (prevPatientData! < currentPatientData!) {
                // Display up
                
                
            }
        }
    }
    
    func checkIterator() {
        if(i >= rows) {
            i = 0
        }
    }
}

extension UIBezierPath {
    
    static func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> UIBezierPath {
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(0, tailWidth / 2),
            p(tailLength, tailWidth / 2),
            p(tailLength, headWidth / 2),
            p(length, 0),
            p(tailLength, -headWidth / 2),
            p(tailLength, -tailWidth / 2),
            p(0, -tailWidth / 2)
        ]
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        
        let path = CGMutablePath()
        path.addLines(between: points, transform: transform)
        path.closeSubpath()
        
        return self.init(cgPath: path)
    }
    
}
