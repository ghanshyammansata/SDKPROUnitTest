//
//  CometChat3UsersTests.swift
//  CometChatProTests
//
//  Created by Inscripts11 on 19/03/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import XCTest
@testable import CometChatPro

class CometChat3UsersTests: XCTestCase {
        
    func testGetLoggedInUserDetails() {

        let expectation = self.expectation(description: "Getting Logged in user's details")

        let user = CometChat.getLoggedInUser()
 
        if user != nil {
            
            XCTAssertNotNil(user)

            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetUsersListWithInvalidLimit() {
        
        let expectation = self.expectation(description: "Get list of users with invalid limit.")
        
        let _userListRequest = UsersRequest.UsersRequestBuilder(limit: 1000).build()
        
        _userListRequest.fetchNext(onSuccess: { (userList) in
            
            print("user list fetch successfully.")

        }) { (error) in
            
            print("error in fetching user list : \(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetUsersListWithValidLimit() {
        
        let expectation = self.expectation(description: "Get list of users with valid limit.")
        
        var _userList : [User]?
        
        let _userListRequest = UsersRequest.UsersRequestBuilder(limit: 30).build()
        
        _userListRequest.fetchNext(onSuccess: { (userList) in
            
            _userList = userList
            
            print("user list fetch successfully.")
            
            XCTAssertNotNil(_userList)

            expectation.fulfill()
            
        }) { (error) in
            
            print("error in fetching user list : \(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetUsersListWithoutLimit() {
        
        let expectation = self.expectation(description: "Get list of users with valid limit.")
        
        var _userList : [User]?
        
        let _userListRequest = UsersRequest.UsersRequestBuilder().build()
        
        _userListRequest.fetchNext(onSuccess: { (userList) in
            
            _userList = userList
            
            print("user list fetch successfully.")
            
            XCTAssertNotNil(_userList)
            
            expectation.fulfill()
            
        }) { (error) in
            
            print("error in fetching user list : \(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetUsersInformation() {
        
        let expectation = self.expectation(description: "Get User's Information")
        
        var _user : User?
        
        CometChat.getUser(UID: "SUPERHERO1", onSuccess: { (user) in
            
            _user = user
            
            print("user : \(String(describing: user?.stringValue()))")
            
            XCTAssertNotNil(_user)
            
            expectation.fulfill()
            
        }) { (error) in
            
            print("error in fetching user's information : \(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetUsersInformationWithInvalidUID() {
        
        let expectation = self.expectation(description: "Get User's Information with invalid UID")
        
        CometChat.getUser(UID: "InvalidUID", onSuccess: { (user) in
            
            print("user : \(String(describing: user?.stringValue()))")
            
        }) { (error) in
            
            print("error in fetching user's information : \(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetUsersInformationWithEmptyUID() {
        
        let expectation = self.expectation(description: "Get User's Information with empty UID")
        
        CometChat.getUser(UID: "", onSuccess: { (user) in
            
            print("user : \(String(describing: user?.stringValue()))")
            
        }) { (error) in
            
            print("error in fetching user's information : \(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
