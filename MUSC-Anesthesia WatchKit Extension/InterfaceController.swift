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
    
    var displayColor = Int()
    var someData: UnsafeMutablePointer<Int8> = EventType()
    

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)
        
//        someData = EventType()
        let str = String(cString: someData)
        
        NameRoom.setTextColor(UIColor.magenta)
        NameRoom.setText("Smith - OR 1")
        
        MedicalIssue.setTextColor(UIColor.magenta)
        MedicalIssue.setText(str)
        
        Data.setTextColor(UIColor.magenta)
        Data.setText("100/60")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        displayColor = 1;
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
