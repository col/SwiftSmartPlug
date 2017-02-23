//
//  ViewController.swift
//  HS100-iOS
//
//  Created by Col Harris on 23/02/2017.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import UIKit
import Socket

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction
    func buttonPressed() {
        print("buttonPressed")
        do {
            let smartPlug = SmartPlug(host: "192.168.0.162")
            try smartPlug.connect()
            let sysInfo = smartPlug.sysInfo()
            print("SysInfo: \(sysInfo)")
        } catch {
            print("Exception \(error.localizedDescription)")
        }
    }
    
}

