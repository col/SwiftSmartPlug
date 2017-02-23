//
//  TPLinkSmartHomeProtocolTests.swift
//  HS100-iOS
//
//  Created by Col Harris on 23/02/2017.
//  Copyright © 2017 ThoughtWorks. All rights reserved.
//

import XCTest
@testable import HS100_iOS

class TPLinkSmartHomeProtocolTests: XCTestCase {
    
    func testEncrypt() {
        let encryptedData = TPLinkSmartHomeProtocol.encrypt(content: "abc")
        let bytes = [UInt8](encryptedData)
        XCTAssert(bytes == [0x00, 0x00, 0x00, 0x03, 0xCA, 0xA8, 0xCB])
    }
    
    func testDecrypt() {
        let data = Data(bytes: [0x00, 0x00, 0x00, 0x03, 0xCA, 0xA8, 0xCB])
        let result = TPLinkSmartHomeProtocol.decrypt(data: data)
        XCTAssert(result == "abc")
    }
    
    func testBytesToHexString() {
        let bytes: [UInt8] = [0x00, 0x00, 0x00, 0x03, 0xCA, 0xA8, 0xCB]
        let result = TPLinkSmartHomeProtocol.bytesToHexString(bytes: bytes)
        XCTAssert(result == "0x0 0x0 0x0 0x3 0xCA 0xA8 0xCB")
    }
    
    func testDataToHexString() {
        let data: Data = Data(bytes: [0x00, 0x00, 0x00, 0x03, 0xCA, 0xA8, 0xCB])
        let result = TPLinkSmartHomeProtocol.dataToHexString(data: data)
        XCTAssert(result == "0x0 0x0 0x0 0x3 0xCA 0xA8 0xCB")
    }
}
