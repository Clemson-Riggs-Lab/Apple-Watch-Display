//
//  StartView.swift
//  
//
//  Created by Nicolas Threatt on 7/25/18.
//

import Foundation
import WatchKit
import UIKit

class StartView: WKInterfaceController {
    
    @IBOutlet var pickerView: WKInterfacePicker!
    
    let inputFiles = ["File 1", "File 2", "File 3"]
    var fileSelected = String()
    var start = 0
    
    func numberOfComponents(in pickerView: WKInterfacePicker) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: WKInterfacePicker, numberOfRowsInComponent component: Int) -> Int {
        return inputFiles.count
    }
    
    func pickerView(_ pickerView: WKInterfacePicker, titleForRow row: Int, forComponent component: Int) -> String? {
        return inputFiles[row]
    }
    
    func pickerView(_ pickerView: WKInterfacePicker, didSelectRow row: Int, forComponent component: Int) {
        fileSelected = inputFiles[row]
        
        start = 1
    }
    
    @IBAction func Start() {
        if(start == 0) {
            fileSelected = inputFiles[Int(arc4random_uniform(3))]
        }
    }
    
}
