//
//  CometChatAuthenticationTests.swift
//  CometChatProTests
//
//  Created by Inscripts11 on 18/03/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import XCTest
@testable import CometChatPro

class CometChat2AuthenticationTests: XCTestCase {

    func test1Logout() {
        
        let expectation = self.expectation(description: "Testing  Logout")
        
        CometChat.logout(onSuccess: { (isSuccess) in
            
            print("Logout successful")
            
            XCTAssertEqual(isSuccess, "User logged out successfully.", "Logged out successful")
            
            expectation.fulfill()
            
        }) { (error) in
            
            print("error in Logout : \(String(describing: error.errorDescription))")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test2LoginWithoutUIDAndAPIKey() {
        
        //Creating an Expectation
        let expectation = self.expectation(description: "Testing Login without UID and APIKey")
        
        var _user : User?
        
        CometChat.login(UID: "", apiKey: "", onSuccess: { (user) in
     
            _user = user
            print("login successful.")
            
        }) { (error) in
            
            print("login failed : \(error.errorDescription)")

            XCTAssertNil(_user)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test3LoginWithUIDAndEmptyAPIKey() {
        
        //Creating an Expectation
        let expectation = self.expectation(description: "Testing Login with UID and empty APIKey")
        
        var _user : User?
        
        CometChat.login(UID: TestConstants.user1, apiKey: "", onSuccess: { (user) in
            
            _user = user
            print("login successful.")
            
        }) { (error) in
            
            print("login failed : \(error.errorDescription)")

            XCTAssertNil(_user)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func test4LoginWithEmptyUIDAndValidAPIKey() {
        
        //Creating an Expectation
        let expectation = self.expectation(description: "Testing Login with empty UID and valid APIKey")
        
        var _user : User?
        
        CometChat.login(UID: "", apiKey: TestConstants.apiKey, onSuccess: { (user) in
            
            _user = user
            
            print("login successful.")
            
        }) { (error) in
            
            print("login failed : \(error.errorDescription)")

            XCTAssertNil(_user)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test5LoginWithInvalidUIDAndValidAPIKey() {
        
        //Creating an Expectation
        let expectation = self.expectation(description: "Testing Login with invalid UID and valid APIKey")
        
        var _user : User?
        
        CometChat.login(UID: "InvalidUID", apiKey: TestConstants.apiKey, onSuccess: { (user) in
            
            _user = user
            print("login successful.")
            
        }) { (error) in
            
            print("login failed : \(error.errorDescription)")

            XCTAssertNil(_user)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test6LoginWithValidUIDAndInvalidAPIKey() {
        
        //Creating an Expectation
        let expectation = self.expectation(description: "Testing Login with valid UID and invalid APIKey")
        
        var _user : User?
        
        CometChat.login(UID: TestConstants.user1, apiKey: "Invalid API Key", onSuccess: { (user) in
            
            _user = user
            print("login successful.")
            
        }) { (error) in
            
            print("login failed : \(error.errorDescription)")

            XCTAssertNil(_user)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test7LoginInvalidUIDAndInvalidAPIKey() {
        
        //Creating an Expectation
        let expectation = self.expectation(description: "Testing Login with invalid UID and invalid APIKey")
        
        var _user : User?
        
        CometChat.login(UID: "Invalid UID", apiKey: "Invalid API Key", onSuccess: { (user) in
            
            _user = user
            print("login successful.")
            
        }) { (error) in
            
            print("login failed : \(error.errorDescription)")

            XCTAssertNil(_user)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoginWithValidUIDAndValidAPIKey() {
        
        //Creating an Expectation
        let expectation = self.expectation(description: "Testing Login with valid UID and valid APIKey")
        
        var _user : User?
        
        CometChat.login(UID: TestConstants.user1, apiKey: TestConstants.apiKey, onSuccess: { (user) in
            
            _user = user
            
            print("login successful.")
            
            XCTAssertNotNil(_user)
            
            expectation.fulfill()
            
        }) { (error) in
            
            print("login failed : \(error.errorDescription)")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test8LoginWithEmptyAuthtoken() {
        
        //Creating an Expectation
        let expectation = self.expectation(description: "Testing Login with empty Authtoken")
        
        var _user : User?
        
        CometChat.login(authToken: "", onSuccess: { (user) in
            
            _user = user
            print("Login Successful...")
            
        }) { (error) in
        
            print("Login failed : \(error.errorDescription)")
            
            XCTAssertNil(_user)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test9LoginWithInvalidAuthtoken() {
        
        //Creating an Expectation
        let expectation = self.expectation(description: "Testing Login with invalid Authtoken")
        
        var _user : User?
        
        CometChat.login(authToken: "23423424dsfsadfsfsdfsdf", onSuccess: { (user) in
            
            _user = user
            print("Login Successful...")
            
        }) { (error) in
            
            print("Login failed : \(error.errorDescription)")
            
            XCTAssertNil(_user)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func testLoginWithValidAuthtoken() {
        
        //Creating an Expectation
        let expectation = self.expectation(description: "Testing Login with valid Authtoken")
        
        var _user : User?
        
        CometChat.login(authToken: TestConstants.authtokenUser1, onSuccess: { (user) in
            
            _user = user
            
            print("Login Successful...")
            
            XCTAssertNotNil(_user)

            expectation.fulfill()
            
        }) { (error) in
            
            print("Login failed : \(error.errorDescription)")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
