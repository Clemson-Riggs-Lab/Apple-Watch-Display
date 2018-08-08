//
//  StartView.swift
//  MUSC-Anesthesia WatchKit Extension
//
//  Created by Nicolas Threatt on 7/25/18.
//  Copyright © 2018 Riggs Lab. All rights reserved.
//

import WatchKit
import Foundation

var start = 0

class StartView: WKInterfaceController {

    @IBOutlet var pickerView: WKInterfacePicker!
    
    let inputFiles = ["File 1", "File 2", "File 3"]

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        let pickerItems: [WKPickerItem] = inputFiles.map { file in
            let item = WKPickerItem()
            item.title = file
            item.caption = file

            return item
        }
        pickerView.setItems(pickerItems)
    }
    
    @IBAction func pickerSelectedItemChanged(_ value: Int) {
        fileRecieve = inputFiles[value]
    }
    
    @IBAction func Start() {
        start = 1
    }
}
