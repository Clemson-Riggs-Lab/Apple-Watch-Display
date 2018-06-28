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
    
    var txtData: [String]?
    var patientNameRoom: String?
    var patientIssue: String?
    var patientData: String?
    
    let fileName: String = "patients"

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)
        
        txtData = readTXTIntoArray(file: fileName)
        displayBP()
        
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
            print(content.components(separatedBy: ["\n", ",", "\t", "\r"]))
            return content.components(separatedBy: " ")
        } catch {
            return nil
        }
        
    }
    
    func displayBP() {
        NameRoom.setTextColor(UIColor.magenta)
        NameRoom.setText("Smith - OR 1")
        
        MedicalIssue.setTextColor(UIColor.magenta)
        MedicalIssue.setText("NBP")
        
        Data.setTextColor(UIColor.magenta)
        Data.setText("100/60")
    }
    
    func displaySP02() {
        NameRoom.setTextColor(UIColor.cyan)
        NameRoom.setText("Smith - OR 1")
        
        MedicalIssue.setTextColor(UIColor.cyan)
        MedicalIssue.setText("SpO2")
        
        Data.setTextColor(UIColor.cyan)
        Data.setText("91%")
    }
}
