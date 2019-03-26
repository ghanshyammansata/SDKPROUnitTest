//
//  CometChat4MessagesTests.swift
//  CometChatProTests
//
//  Created by Inscripts11 on 20/03/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import XCTest
@testable import CometChatPro

class CometChat4MessagesTests: XCTestCase {

    func testSendTextMessagesWithEmptyReceiverId() {
        
        let expectation = self.expectation(description: "Send a text message with empty Receiver Id")
        
        let _textMessage = TextMessage(receiverUid: "", text: "this is normal text", messageType: .text, receiverType: .user)
        _textMessage.metaData = ["metaKey" : "metaData"]
        
        CometChat.sendTextMessage(message: _textMessage, onSuccess: { (textMessage) in
            
            print("sending text message successfully..")
            
        }) { (error) in
            
            print("error in sending text message..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendTextMessagesWithValidReceiverIdAndText() {
        
        let expectation = self.expectation(description: "Send a text message with valid Receiver Id")
        
        let _textMessage = TextMessage(receiverUid: TestConstants.user2, text: "this is normal text", messageType: .text, receiverType: .user)
        _textMessage.metaData = ["metaKey" : "metaData"]
        
        _ = CometChat.sendTextMessage(message: _textMessage, onSuccess: { (textMessage) in
            
            print("sending text message successfully..")
            
            XCTAssertNotNil(textMessage)

            expectation.fulfill()
            
        }) { (error) in
            
            print("error in sending text message..\(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendTextMessagesWithInvalidReceiverId() {
        
        let expectation = self.expectation(description: "Send a text message with invalid Receiver Id")
        
        let _textMessage = TextMessage(receiverUid: "InvalidUID", text: "this is normal text", messageType: .text, receiverType: .user)
        _textMessage.metaData = ["metaKey" : "metaData"]
        
        CometChat.sendTextMessage(message: _textMessage, onSuccess: { (textMessage) in
            
            print("sending text message successfully..")
            
        }) { (error) in
            
            print("error in sending text message..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendTextMessageWithEmptyText() {
        
        let expectation = self.expectation(description: "Send a text message with empty text")
        
        let _textMessage = TextMessage(receiverUid: TestConstants.user2, text: "", messageType: .text, receiverType: .user)
        
        CometChat.sendTextMessage(message: _textMessage, onSuccess: { (textMessage) in
            
            print("sending text message successfully..")
            
        }) { (error) in
            
            print("error in sending text message..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendMediaMessagesWithEmptyReceiverId() {
        
        let expectation = self.expectation(description: "Send a media message with empty Receiver Id")
        let path = Bundle.main.path(forResource: "file", ofType: "jpg")
        
        XCTAssertNotNil(path)
        
        let _mediaMessage = MediaMessage(receiverUid: "", fileurl: path!, messageType: .image, receiverType: .user)
        
        CometChat.sendMediaMessage(message: _mediaMessage, onSuccess: { (textMessage) in
            
            print("sending media message successfully..")
            
        }) { (error) in
            
            print("error in sending media message..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendMediaMessagesWithValidReceiverIdAndMediaURL() {
        
        let expectation = self.expectation(description: "Send a media message with valid Receiver Id")
        let path = Bundle.main.path(forResource: "file", ofType: "jpg")
        
        XCTAssertNotNil(path)
        
        let _mediaMessage = MediaMessage(receiverUid: TestConstants.user2, fileurl: path!, messageType: .image, receiverType: .user)
        _mediaMessage.metaData = ["metaKey" : "metaData"]
        
        CometChat.sendMediaMessage(message: _mediaMessage, onSuccess: { (mediaMessage) in
            
            print("sending media message successfully..")
            
            XCTAssertNotNil(mediaMessage)

            expectation.fulfill()
            
        }) { (error) in
            
            print("error in sending media message..\(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendMediaMessagesWithInvalidReceiverId() {
        
        let expectation = self.expectation(description: "Send a media message with invalid Receiver Id")
        
        let _mediaMessage = MediaMessage(receiverUid: "InvalidId", fileurl: "file:///Users/inscripts11/Library/Developer/CoreSimulator/Devices/632CBE79-CE19-48E8-BB75-97B40765D25F/data/Containers/Data/Application/94C63396-7632-451B-A2ED-0A9BB0C93DCE/Documents/B79142BE-79D3-4546-9D39-F6FAF50EBD88.jpeg", messageType: .image, receiverType: .user)
        _mediaMessage.metaData = ["metaKey" : "metaData"]
        
        CometChat.sendMediaMessage(message: _mediaMessage, onSuccess: { (textMessage) in
            
            print("sending media message successfully..")
            
        }) { (error) in
            
            print("error in sending media message..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendMediaMesssageWithEmptyFileURL() {
        
        let expectation = self.expectation(description: "Send a media message with empty file url")
        
        let _mediaMessage = MediaMessage(receiverUid: TestConstants.user2, fileurl: "", messageType: .image, receiverType: .user)
        _mediaMessage.metaData = ["metaKey" : "metaData"]
        
        CometChat.sendMediaMessage(message: _mediaMessage, onSuccess: { (textMessage) in
            
            print("sending media message successfully..")
            
        }) { (error) in
            
            print("error in sending media message..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendCustomMessagesWithEmptyReceiverId() {
        
        let expectation = self.expectation(description: "Send a custom message with empty Receiver Id")
        
        let _customMessage = CustomMessage(receiverUid: "", receiverType: .user, customData : ["customKey": "customData"])
        
        CometChat.sendCustomMessage(message: _customMessage, onSuccess: { (textMessage) in
            
            print("sending custom message successfully..")
            
        }) { (error) in
            
            print("error in sending custom message..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendCustomMessagesWithValidReceiverId() {
        
        let expectation = self.expectation(description: "Send a custom message with valid Receiver Id")
        
        let _customMessage = CustomMessage(receiverUid: TestConstants.user2, receiverType: .user, customData : ["customKey": "customData"])
        
        CometChat.sendCustomMessage(message: _customMessage, onSuccess: { (customMessage) in
            
            print("sending custom message successfully..")
            
            XCTAssertNotNil(customMessage)
            
            expectation.fulfill()
            
        }) { (error) in
            
            print("error in sending custom message..\(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendCustomMessagesWithInvalidReceiverId() {
       
        let expectation = self.expectation(description: "Send a custom message with invalid Receiver Id")
        
        let _customMessage = CustomMessage(receiverUid: "InvalidID", receiverType: .user, customData : ["customKey": "customData"])
        
        CometChat.sendCustomMessage(message: _customMessage, onSuccess: { (textMessage) in
            
            print("sending custom message successfully..")
            
        }) { (error) in
            
            print("error in sending custom message..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendCustomMesssageWithEmptyCustomData() {
        
        let expectation = self.expectation(description: "Send a custom message with empty custom data")
        
        let _customMessage = CustomMessage(receiverUid: "", receiverType: .user, customData : [:])
        
        CometChat.sendCustomMessage(message: _customMessage, onSuccess: { (textMessage) in
            
            print("sending custom message successfully..")
            
        }) { (error) in
            
            print("error in sending custom message..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendTextMessagesToGroupWithEmptyReceiverId() {
        
        let expectation = self.expectation(description: "Send a text message to Group with empty Receiver Id")
        
        let _textMessage = TextMessage(receiverUid: "", text: "this is normal text", messageType: .text, receiverType: .group)
        _textMessage.metaData = ["metaKey" : "metaData"]
        
        CometChat.sendTextMessage(message: _textMessage, onSuccess: { (textMessage) in
            
            print("sending text message to group successfully..")
            
        }) { (error) in
            
            print("error in sending text message to group ..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendTextMessagesToGroupWithValidReceiverIdAndText() {
        
        let expectation = self.expectation(description: "Send a text message to group with valid Receiver Id")
        
        let _textMessage = TextMessage(receiverUid: TestConstants.grpPublic1, text: "this is normal text", messageType: .text, receiverType: .group)
        _textMessage.metaData = ["metaKey" : "metaData"]
        
        CometChat.sendTextMessage(message: _textMessage, onSuccess: { (textMessage) in
            
            print("sending text message to group successfully..")
            
            XCTAssertNotNil(textMessage)

            expectation.fulfill()
            
        }) { (error) in
            
            print("error in sending text message to group..\(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendTextMessagesToGroupWithInvalidReceiverId() {
        
        let expectation = self.expectation(description: "Send a text message to group with invalid Receiver Id")
        
        let _textMessage = TextMessage(receiverUid: "InvalidUID", text: "this is normal text", messageType: .text, receiverType: .group)
        _textMessage.metaData = ["metaKey" : "metaData"]
        
        CometChat.sendTextMessage(message: _textMessage, onSuccess: { (textMessage) in
            
            print("sending text message to group successfully..")
            
        }) { (error) in
            
            print("error in sending text message to group ..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendTextMessagesToGroupWithEmptyText() {
        
        let expectation = self.expectation(description: "Send a text message to group with empty text")
        
        let _textMessage = TextMessage(receiverUid: TestConstants.grpPublic1, text: "", messageType: .text, receiverType: .group)
        
        CometChat.sendTextMessage(message: _textMessage, onSuccess: { (textMessage) in
            
            print("sending text message to group successfully..")
            
        }) { (error) in
            
            print("error in sending text message to group ..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendMediaMessagesToGroupWithEmptyReceiverId() {
        
        let expectation = self.expectation(description: "Send a media message to group with empty Receiver Id")
        
        let _mediaMessage = MediaMessage(receiverUid: "", fileurl: "file:///Users/inscripts11/Library/Developer/CoreSimulator/Devices/632CBE79-CE19-48E8-BB75-97B40765D25F/data/Containers/Data/Application/94C63396-7632-451B-A2ED-0A9BB0C93DCE/Documents/B79142BE-79D3-4546-9D39-F6FAF50EBD88.jpeg", messageType: .image, receiverType: .group)
        
        CometChat.sendMediaMessage(message: _mediaMessage, onSuccess: { (textMessage) in
            
            print("sending media message to group successfully..")
            
        }) { (error) in
            
            print("error in sending media message to group ..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendMediaMessagesToGroupWithValidReceiverIdAndMediaURL() {
        
        let expectation = self.expectation(description: "Send a media message to group with valid Receiver Id")
        
        let _mediaMessage = MediaMessage(receiverUid: TestConstants.grpPublic1, fileurl: "file:///Users/inscripts11/Library/Developer/CoreSimulator/Devices/632CBE79-CE19-48E8-BB75-97B40765D25F/data/Containers/Data/Application/94C63396-7632-451B-A2ED-0A9BB0C93DCE/Documents/B79142BE-79D3-4546-9D39-F6FAF50EBD88.jpeg", messageType: .image, receiverType: .group)
        _mediaMessage.metaData = ["metaKey" : "metaData"]
        
        CometChat.sendMediaMessage(message: _mediaMessage, onSuccess: { (mediaMessage) in
            
            print("sending media message to group successfully..")
            
            XCTAssertNotNil(mediaMessage)

            expectation.fulfill()
            
        }) { (error) in
            
            print("error in sending media message to group..\(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendMediaMessagesToGroupWithInvalidReceiverId() {
        
        let expectation = self.expectation(description: "Send a media message to group with invalid Receiver Id")
        
        let _mediaMessage = MediaMessage(receiverUid: "InvalidId", fileurl: "file:///Users/inscripts11/Library/Developer/CoreSimulator/Devices/632CBE79-CE19-48E8-BB75-97B40765D25F/data/Containers/Data/Application/94C63396-7632-451B-A2ED-0A9BB0C93DCE/Documents/B79142BE-79D3-4546-9D39-F6FAF50EBD88.jpeg", messageType: .image, receiverType: .group)
        _mediaMessage.metaData = ["metaKey" : "metaData"]
        
        CometChat.sendMediaMessage(message: _mediaMessage, onSuccess: { (textMessage) in
            
            print("sending media message to group successfully..")
            
        }) { (error) in
            
            print("error in sending media message to group..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendMediaMesssageToGroupWithEmptyFileURL() {
        
        let expectation = self.expectation(description: "Send a media message to group with empty file URL")
        
        let _mediaMessage = MediaMessage(receiverUid: TestConstants.grpPublic1, fileurl: "", messageType: .image, receiverType: .group)
        _mediaMessage.metaData = ["metaKey" : "metaData"]
        
        CometChat.sendMediaMessage(message: _mediaMessage, onSuccess: { (textMessage) in
            
            print("sending media message to group successfully..")
            
        }) { (error) in
            
            print("error in sending media message..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendCustomMessagesToGroupWithEmptyReceiverId() {
        
        let expectation = self.expectation(description: "Send a custom message to group with empty Receiver Id")
        
        let _customMessage = CustomMessage(receiverUid: "", receiverType: .group, customData : ["customKey": "customData"])
        
        CometChat.sendCustomMessage(message: _customMessage, onSuccess: { (textMessage) in
            
            print("sending custom message to group successfully..")
            
        }) { (error) in
            
            print("error in sending custom message to group..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendCustomMessagesToGroupWithValidReceiverId() {
        
        let expectation = self.expectation(description: "Send a custom message to group with valid Receiver Id")
        
        let _customMessage = CustomMessage(receiverUid: TestConstants.grpPublic1, receiverType: .group, customData : ["customKey": "customData"])
        
        CometChat.sendCustomMessage(message: _customMessage, onSuccess: { (customMessage) in
            
            print("sending custom message to group successfully..")
            
            XCTAssertNotNil(customMessage)
            
            expectation.fulfill()
            
        }) { (error) in
            
            print("error in sending custom message to group..\(String(describing: error?.errorDescription))")
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendCustomMessagesToGroupWithInvalidReceiverId() {
        
        let expectation = self.expectation(description: "Send a custom message to group with invalid Receiver Id")
        
        let _customMessage = CustomMessage(receiverUid: "InvalidID", receiverType: .group, customData : ["customKey": "customData"])
        
        CometChat.sendCustomMessage(message: _customMessage, onSuccess: { (textMessage) in
            
            print("sending custom message to group successfully..")
            
        }) { (error) in
            
            print("error in sending custom message to group..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSendCustomMesssagesToGroupWithEmptyCustomData() {
        
        let expectation = self.expectation(description: "Send a Custom message with empty Custom data")
        
        let _customMessage = CustomMessage(receiverUid: "", receiverType: .group, customData : [:])
        
        CometChat.sendCustomMessage(message: _customMessage, onSuccess: { (textMessage) in
            
            print("sending custom message to group successfully..")
            
        }) { (error) in
            
            print("error in sending custom message to group ..\(String(describing: error?.errorDescription))")
            
            XCTAssertNotNil(error)

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
