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
    
    func query(request: [String: Any]) throws -> [String: Any] {
        try socket?.write(from: TPLinkSmartHomeProtocol.encrypt(content: toJsonData(request)!))
        
        var response = Data()
        let _ = try socket?.read(into: &response)
        
        return toJsonObject(TPLinkSmartHomeProtocol.decrypt(data: response))! 
    }
    
    func sysInfo() -> [String: Any] {
        do
        {
            let request = ["system": ["get_sysinfo": []]]
            return try query(request: request)
        } catch {
            print("Exception: \(error.localizedDescription)")
            return ["Error": "error"]
        }
    }
    
    func toJsonData(_ content: [String: Any]) -> String? {
        do
        {
            let jsonData = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
            return String(data: jsonData, encoding: String.Encoding.ascii)
        } catch {
            print("Json Encode Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func toJsonObject(_ content: String) -> [String: Any]? {
        do
        {
            let jsonData = try JSONSerialization.jsonObject(with: content.data(using: String.Encoding.ascii)!, options: .allowFragments)
            return jsonData as? [String: Any]
        } catch {
            print("Json Decode Error: \(error.localizedDescription)")
            return nil
        }
    }
    
}
