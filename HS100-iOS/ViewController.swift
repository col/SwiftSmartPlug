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
    
    @IBOutlet var modelField: UITextField!
    @IBOutlet var aliasField: UITextField!
    @IBOutlet var macField: UITextField!
    @IBOutlet var stateSwitch: UISwitch!
    @IBOutlet var ledStateSwitch: UISwitch!
    @IBOutlet var hardwareInfo: UITextView!
    
    var smartPlug: SmartPlug!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        smartPlug = SmartPlug(host: "192.168.0.162")        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        modelField.text = smartPlug.model
        aliasField.text = smartPlug.alias
        macField.text = smartPlug.mac
        hardwareInfo.text = SmartPlugJSON.toJson(smartPlug.hardwareInfo ?? [:])
        stateSwitch.setOn(smartPlug.state ?? false, animated: false)
        ledStateSwitch.setOn(smartPlug.ledState ?? false, animated: false)
        print("Device Date = \(smartPlug.getTime())")
        print("Device TimeZone = \(smartPlug.getTimeZone())")
        
    }
    
    @IBAction
    func stateSwitchChanged() {
        print("stateSwitchChanged")
        smartPlug.setState(state: stateSwitch.isOn)
    }
    
    @IBAction
    func ledStateSwitchChanged() {
        print("ledStateSwitchChanged")
        smartPlug.setLedState(state: ledStateSwitch.isOn)
    }
}

