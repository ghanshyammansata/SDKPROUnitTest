//
//  CometChat5GroupsTests.swift
//  CometChatProTests
//
//  Created by Inscripts11 on 21/03/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import XCTest
@testable import CometChatPro

class CometChat5GroupsTests: XCTestCase {

    func testGetJoinedPublicGroupInfo() {
        
        let expectation = self.expectation(description: "Get Joined Public Group Info")
        
        CometChat.getGroup(GUID: TestConstants.grpPublic1, onSuccess: { (group) in
            
            print("group info : \(String(describing: group.stringValue()))")
            
            XCTAssertNotNil(group)
            
            expectation.fulfill()
            
        }) { (error) in
            
            print("error in fetching group information : \(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetUnjoinedPublicGroupInfo() {
        
        let expectation = self.expectation(description: "Get Unjoined Public Group Info")
        
        CometChat.getGroup(GUID: TestConstants.grpPublic2, onSuccess: { (group) in
            
            print("group info : \(String(describing: group.stringValue()))")
        
        }) { (error) in
            
            print("error in fetching group information : \(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetJoinedPasswordGroupInfo() {
        
        let expectation = self.expectation(description: "Get Joined Password Group Info")
        
        CometChat.getGroup(GUID: TestConstants.grpPwd5, onSuccess: { (group) in
            
            print("group info : \(String(describing: group.stringValue()))")
            
            XCTAssertTrue(group.hasJoined)
            
            expectation.fulfill()
            
        }) { (error) in
            
            print("error in fetching group information : \(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetUnjoinedPasswordGroupInfo() {
        
        let expectation = self.expectation(description: "Get Unjoined Password Group Info")
        
        CometChat.getGroup(GUID: TestConstants.grpPwd6, onSuccess: { (group) in
            
            print("group info : \(String(describing: group.stringValue()))")
            
        }) { (error) in
            
            print("error in fetching group information : \(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetJoinedPrivateGroupInfo() {
        
        let expectation = self.expectation(description: "Get Joined Private Group Info")
        
        CometChat.getGroup(GUID: TestConstants.grpPrivate3, onSuccess: { (group) in
            
            print("group info : \(String(describing: group.stringValue()))")
            
        }) { (error) in
            
            print("error in fetching group information : \(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetUnjoinedPrivateGroupInfo() {
        
        let expectation = self.expectation(description: "Get Unjoined Private Group Info")
        
        CometChat.getGroup(GUID: TestConstants.grpPrivate3, onSuccess: { (group) in
            
            print("group info : \(String(describing: group.stringValue()))")
            
        }) { (error) in
            
            print("error in fetching group information : \(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetGroupListWithValidLimit() {
        
        let expectation = self.expectation(description: "Get Group List with valid Limit")
        
        let groupListRequest = GroupsRequest.GroupsRequestBuilder(limit: 30).build()
        
        groupListRequest.fetchNext(onSuccess: { (groups) in
            
            print("group List fetched successfully")
            
            XCTAssertNotNil(groups)
            
            expectation.fulfill()
            
        }) { (error) in
            
            print("error in fetching group List : \(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testGetGroupListWithInvalidLimit() {
        
        let expectation = self.expectation(description: "Get Group List with Invalid Limit")
        
        let groupListRequest = GroupsRequest.GroupsRequestBuilder(limit: 500).build()
        
        groupListRequest.fetchNext(onSuccess: { (groups) in
            
            print("group List fetched successfully")
            
        }) { (error) in
            
            print("error in fetching group List : \(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testJoinPublicGroup() {
        
        let expectation = self.expectation(description: "Join the public Group")
        
        CometChat.joinGroup(GUID: TestConstants.grpPublic2, groupType: .public, password: nil, onSuccess: { (group) in
            
            print("public joined successfully.")
            
            XCTAssertTrue(group.hasJoined)
            
            expectation.fulfill()
            
            CometChat.leaveGroup(GUID: TestConstants.grpPublic2, onSuccess: { (isSuccess) in
                
            }, onError: { (error) in
                
                print("error in leaving the group : \(String(describing: error?.errorDescription))")
            })
            
        }) { (error) in
            
            print("error in joining the group : \(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testJoinGroupAlreadyJoined() {
        
        let expectation = self.expectation(description: "Join the public Group")
        
        CometChat.joinGroup(GUID: TestConstants.grpPublic1, groupType: .public, password: nil, onSuccess: { (group) in
            
            print("public joined successfully.")
            
        }) { (error) in
            
            print("error in joining the group : \(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testJoinPasswordGroupWithValidPassword() {
        
        let expectation = self.expectation(description: "Join the password group with valid password")
        
        CometChat.joinGroup(GUID: TestConstants.grpPwd6, groupType: .password, password: "pwd123", onSuccess: { (group) in
            
            print("joined password group successfully")
            
            XCTAssertTrue(group.hasJoined)
            
            expectation.fulfill()
            
            CometChat.leaveGroup(GUID: TestConstants.grpPwd6, onSuccess: { (isSuccess) in
                
            }, onError: { (error) in
                
                print("error in leaving the group : \(String(describing: error?.errorDescription))")
            })
            
        }, onError: { (error) in
            
            print("error in joining the password group : \(String(describing: error?.errorDescription))")
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testJoinPasswordGroupWithInvalidPassword() {
        
        let expectation = self.expectation(description: "Join the password group with Invalid password")
        
        CometChat.joinGroup(GUID: TestConstants.grpPwd6, groupType: .password, password: "invalidpwd", onSuccess: { (group) in
            
            print("joined password group successfully")
            
        }, onError: { (error) in
            
            print("error in joining the password group : \(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testJoinGroupWithAlreadyJoinedWithValidPassword() {
        
        let expectation = self.expectation(description: "Join the group with already joined group with valid password")
        
        CometChat.joinGroup(GUID: TestConstants.grpPwd5, groupType: .password, password: "pwd123", onSuccess: { (group) in
            
            print("joined password group successfully")
            
        }, onError: { (error) in
            
            print("error in joining the password group : \(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCreatePublicGroup() {
        
        let expectation = self.expectation(description: "Create a public group")
        
        let newGroup = Group(guid: "group_\(Int(Date().timeIntervalSince1970 * 100))", name: "test group created", groupType: .public, password: nil)
        
        CometChat.createGroup(group: newGroup, onSuccess: { (group) in
            
            print("group is created successfully.")
            
            XCTAssertTrue(newGroup.hasJoined)
            
            expectation.fulfill()
            
            CometChat.deleteGroup(GUID: newGroup.guid, onSuccess: { (success) in
                
                print("group \(newGroup.guid) deleted successfully.")
                
            }, onError: { (error) in
                
                print("error in deleting the group \(newGroup.guid) : \(error?.errorDescription)")
            })
            
        }) { (error) in
            
            print("error in creating public group : \(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCreatePrivateGroup() {
        
        let expectation = self.expectation(description: "Create a private group")
        
        let newGroup = Group(guid: "group_\(Int(Date().timeIntervalSince1970 * 100))", name: "test group created", groupType: .private, password: nil)
        
        CometChat.createGroup(group: newGroup, onSuccess: { (group) in
            
            print("private group is created successfully.")
            
            XCTAssertTrue(newGroup.hasJoined)
            
            expectation.fulfill()
            
            CometChat.deleteGroup(GUID: newGroup.guid, onSuccess: { (success) in
                
                print("group \(newGroup.guid) deleted successfully.")
                
            }, onError: { (error) in
                
                print("error in deleting the group \(newGroup.guid) : \(error?.errorDescription)")
            })
            
        }) { (error) in
            
            print("error in creating private group : \(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCreatePasswordGroup() {
        
        let expectation = self.expectation(description: "Create a password group")
        
        let guidTimeStamp = Int(Date().timeIntervalSince1970 * 100)
        
        let newGroup = Group(guid: "group_\(guidTimeStamp)", name: "test group created", groupType: .password, password: "pwd123")
        
        CometChat.createGroup(group: newGroup, onSuccess: { (group) in
            
            print("group is created successfully.")
            
            XCTAssertTrue(newGroup.hasJoined)
            
            expectation.fulfill()
            
            CometChat.deleteGroup(GUID: "group_\(guidTimeStamp)", onSuccess: { (isSuccess) in
                
                print("group deleted successfully ..")
                
            }, onError: { (error) in
                
                print("error in deleting group : \(error?.errorDescription)")
            })
            
        }) { (error) in
            
            print("error in creating pwd group : \(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCreatePublicGroupAlreadyExist() {
        
        let expectation = self.expectation(description: "Create a public group already exist")
        
        let newGroup = Group(guid: TestConstants.grpPublic1, name: "test group created", groupType: .public, password: nil)
        
        CometChat.createGroup(group: newGroup, onSuccess: { (group) in
            
            print("group is created public group successfully already exist.")
            
        }) { (error) in
            
            print("error in creating public group already exist : \(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCreatePrivateGroupAlreadyExist() {
        
        let expectation = self.expectation(description: "Create a private group already exist")
        
        let newGroup = Group(guid: TestConstants.grpPrivate3, name: "test group created", groupType: .public, password: nil)
        
        CometChat.createGroup(group: newGroup, onSuccess: { (group) in
            
            print("group is created private group successfully already exist.")
            
        }) { (error) in
            
            print("error in creating private group already exist: \(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCreatePasswordGroupAlreadyExist() {
        
        let expectation = self.expectation(description: "Create a password group already exist")
        
        let newGroup = Group(guid: TestConstants.grpPwd5, name: "test group created", groupType: .public, password: nil)
        
        CometChat.createGroup(group: newGroup, onSuccess: { (group) in
            
            print("group is creating password successfully already exist.")
            
        }) { (error) in
            
            print("error in creating password group which already exist : \(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testUpdateExistingGroupWithValidUserScope() {
        
        let expectation = self.expectation(description: "Update existing group with valid user scope")
        
        let newGroup = Group(guid: TestConstants.grpPwd5, name: "Pwd Group iOS 5", groupType: .password, password: "pwd123")
        
        CometChat.updateGroup(group: newGroup, onSuccess: { (group) in
            
            print("group is updated successfully with valid scope.")
            
            XCTAssertNotNil(group)
            
            expectation.fulfill()
            
        }) { (error) in
            
            print("error in updating group with valid scope : \(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testUpdateExistingGroupWithInvalidUserScope() {
        
        let expectation = self.expectation(description: "Update existing group with valid user scope")
        
        let newGroup = Group(guid: TestConstants.grpPublic2, name: "test group created", groupType: .public, password: nil)
        
        CometChat.updateGroup(group: newGroup, onSuccess: { (group) in
            
            print("group is updated successfully.")
            
        }) { (error) in
            
            print("error in updating with invalid scope group : \(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
