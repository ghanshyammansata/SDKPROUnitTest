//
//  CometChatInitializeTests.swift
//  CometChatProTests
//
//  Created by Inscripts11 on 18/03/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import XCTest
@testable import CometChatPro

class CometChat1InitializeTests: XCTestCase {

    func testCometChat1InitWithoutAPPID() {
        
        //Creating an Expectation
        let expectation = self.expectation(description: "Testing Init of SDK with out APPID")
       
        var isInitializeSuccessful = false
        
        CometChat.init(appId: "", onSuccess: { (success) in
        
            isInitializeSuccessful = success
            
            print("SDK initialization successful.")
            
        }) { (error) in
            
            print("SDK initialization failed..")
            
            XCTAssertFalse(isInitializeSuccessful)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCometChat2InitWithAPPID() {
        
        //Creating an Expectation
        let expectation = self.expectation(description: "Testing Init of SDK with APPID")
        
        var isInitializeSuccessful = false
        
        CometChat.init(appId: TestConstants.appId, onSuccess: { (success) in
            
            isInitializeSuccessful = success
            
            XCTAssertTrue(isInitializeSuccessful)

            print("SDK initialization successful.")
            
            expectation.fulfill()
            
        }) { (error) in
            
            print("SDK initialization failed..")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
