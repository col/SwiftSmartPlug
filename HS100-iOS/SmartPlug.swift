//
//  SmartPlug.swift
//  HS100-iOS
//
//  Created by Colin Harris on 23/2/17.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import Foundation
import Socket

class SmartPlug {
    
    let host: String
    let port: Int32
    
    var socket: Socket?
    
    init(host: String, port: Int32 = 9999) {
        self.host = host
        self.port = port
    }
    
    func connect() throws {
        self.socket = try Socket.create()
        try self.socket?.connect(to: host, port: port)
    }
    
    lazy var sysInfo: [String: Any]? = { [unowned self] in
        return self.getSysInfo()
    }()
    
    lazy var model: String? = { [unowned self] in
        return self.sysInfo?["model"] as? String
    }()
    
    lazy var alias: String? = { [unowned self] in
        return self.sysInfo?["alias"] as? String
    }()
    
    lazy var mac: String? = { [unowned self] in
        return self.sysInfo?["mac"] as? String
    }()
    
    lazy var relayState: Int? = { [unowned self] in
        return self.sysInfo?["relay_state"] as? Int
    }()
    
    lazy var state: Bool? = { [unowned self] in
        return self.relayState != nil && self.relayState == 1
    }()
    
    lazy var ledOff: Int? = { [unowned self] in
        return self.sysInfo?["led_off"] as? Int
    }()
    
    lazy var ledState: Bool? = { [unowned self] in
        return self.ledOff != nil && self.ledOff == 0
    }()
    
    lazy var hardwareInfo: [String: String]? = { [unowned self] in
        return [
            "sw_var": self.sysInfo?["sw_ver"] as! String,
            "hw_ver": self.sysInfo?["hw_ver"] as! String,
            "mac": self.sysInfo?["mac"] as! String,
            "hwId": self.sysInfo?["hwId"] as! String,
            "fwId": self.sysInfo?["fwId"] as! String,
            "oemId": self.sysInfo?["oemId"] as! String,
            "dev_name": self.sysInfo?["dev_name"] as! String
        ]
    }()
    
    func query(target: String, command: String, args: [String: Any] = [:]) -> [String: Any]? {
        do
        {
            try connect()
            let request = [target: [command: args]]
            let encryptedRequest = TPLinkSmartHomeProtocol.encrypt(content: SmartPlugJSON.toJson(request)!)
            try socket?.write(from: encryptedRequest)
            
            var data = Data()
            let _ = try socket?.read(into: &data)
            
            let response = SmartPlugJSON.fromJson(TPLinkSmartHomeProtocol.decrypt(data: data))
            let targetResponse = response?[target] as? [String: Any]
            let commandResponse = targetResponse?[command] as? [String: Any]
            return commandResponse
        } catch {
            print("Exception: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getSysInfo() -> [String: Any]? {
        return query(target: "system", command: "get_sysinfo")
    }
    
    func getTime() -> Date? {
        let response = query(target: "time", command: "get_time")
        print("get_time response = \(response)")
        let cal = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = response?["year"] as? Int
        components.month = response?["month"] as? Int
        components.day = response?["mday"] as? Int
        components.hour = response?["hour"] as? Int
        components.minute = response?["min"] as? Int
        components.second = response?["sec"] as? Int
        return cal.date(from: components)
    }
    
    func getTimeZone() -> String? {
        let response = query(target: "time", command: "get_timezone")
        print("get_timezone response = \(response)")
        return "unknown"
    }
    
    func setState(state: Bool) {
        let _ = query(target: "system", command: "set_relay_state", args: ["state": state ? 1 : 0])
    }
    
    func setLedState(state: Bool) {
        let _ = query(target: "system", command: "set_led_off", args: ["off": state ? 0 : 1])
    }
    
    func setNetwork(ssid: String, password: String, keyType: Int) {
        let response = query(target: "netif", command: "set_stainfo", args: ["ssid": ssid, "password": password, "key_type": 3])
        print("response = \(response)")
    }
    
}
