//
//  TPLinkSmartHomeProtocol.swift
//  HS100-iOS
//
//  Created by Col Harris on 23/02/2017.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import Foundation

class TPLinkSmartHomeProtocol {
    
    static let INITIALIZATION_VECTOR = UInt8(171)
    
    class func encrypt(content: String) -> Data {
        let contentLength = content.lengthOfBytes(using: String.Encoding.ascii)
        let length = UInt32(exactly: contentLength)!
        var bytes = [UInt8](repeating: 0, count: 4)
        for i in 0...3 {
            bytes[i] = UInt8(0x0000ff & length >> UInt32((3 - i) * 8))
        }
        
        let contentBytes = [UInt8](content.data(using: String.Encoding.utf8)!)
        var key = INITIALIZATION_VECTOR
        for byte in contentBytes {
            let cipher: UInt8 = key ^ byte
            bytes.append(cipher)
            key = cipher
        }                
        
        return Data(bytes: bytes)
    }
    
    class func decrypt(data: Data) -> String {
        let bytes = [UInt8](data)
        let contentBytes = bytes.dropFirst(4)
        var buffer = [UInt8]()
        
        var key = INITIALIZATION_VECTOR
        for byte in contentBytes {
            let plain = key ^ byte
            key = byte
            buffer.append(plain)
        }
        
        return String(data: Data(buffer), encoding: String.Encoding.isoLatin1)!
    }
    
    class func dataToHexString(data: Data) -> String {
        return bytesToHexString(bytes: [UInt8](data))
    }
    
    class func bytesToHexString(bytes: [UInt8]) -> String {
        let hexString = bytes.reduce("", { (acc, byte) -> String in
            return String(format:"%@ 0x%@", acc, String(byte, radix: 16).uppercased())
        })
        return hexString.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
