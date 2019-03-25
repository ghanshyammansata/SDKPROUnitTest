//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Budhabhooshan Patil on 06/02/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit
import CometChatPro

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        CometChat(appId: AppConstant.APP_ID, onSuccess: { (isSuccess) in
            
            print(isSuccess);
            
            CometChat.calldelegate = self;
            CometChat.messagedelegate = self;
            CometChat.userdelegate = self;
            CometChat.groupdelegate = self;
            
        }) { (error) in
            
            
            print(error.errorDescription as Any);
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


extension AppDelegate : CometChatCallDelegate {
    
    func onIncomingCallReceived (incomingCall:Call?,error:CometChatException?) {
        
        if let _incomingCall = incomingCall {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            if let callView = storyBoard.instantiateViewController(withIdentifier: "CallView") as? CallView {
                
                callView.receivedCall = _incomingCall
                
                UIApplication.shared.keyWindow?.rootViewController?.present(callView, animated: true, completion: { () in
                    
                    if _incomingCall.receiverType == .group {
                        
                        if let callInitiator = (_incomingCall.callReceiver as? Group) {
                            
                            callView.calleeNameLbl?.text = callInitiator.name
                        }
                    }
                    else
                    {
                        if let callInitiator = (_incomingCall.callInitiator as? User) {

                            callView.calleeNameLbl?.text = callInitiator.name
                        }
                    }
                })
            }
        }
    }
    
    func onOutgoingCallAccepted (acceptedCall:Call?,error:CometChatException?) {
        
        guard let sessionID = acceptedCall?.sessionID else {
            return;
        }
        
        DispatchQueue.main.async {
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil);
            
            if let callView = storyBoard.instantiateViewController(withIdentifier: "CallView") as? CallView {
                
                UIApplication.shared.keyWindow?.rootViewController?.navigationController?.present(callView, animated: true, completion: { () in
                    
                    CometChat.startCall(sessionID: sessionID, inView: callView.view, userJoined: { (someone_joined) in
                        
                        print(someone_joined as Any)
                        
                    }, userLeft: { (some_one_left) in
                        
                        print(some_one_left as Any)
                        
                    }, onError: { (error) in
                        
                        print(error as Any)
                        
                    }) { (ended_call) in
                        
                        DispatchQueue.main.async {
                            
                            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                            
                        }
                    }
                });
            }
        }
    }
    
    func onOutgoingCallRejected (rejectedCall:Call?,error:CometChatException?) {
        
        print("outgoingcall rejected : \(rejectedCall?.stringValue() as Any)")
        
    }
    
    func onIncomingCallCancelled (canceledCall:Call?,error:CometChatException?) {
        
        print("incoming call cancelled : \(canceledCall?.stringValue() as Any)")
        
        DispatchQueue.main.async {
            
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
            
        }
    }
}

extension AppDelegate : CometChatMessageDelegate {
    
    func onMessageDelivered(receipt : MessageReceipt) {
       
        print("onMessageDelivered as \(receipt as Any)")
        
        print("receipt receiver : \(receipt.receiverId)")
        print("receipt receiver type : \(receipt.receiverType == .group ? "group" : "user")")
        print("message Id : \(receipt.messageId)")
        print("sender : \(receipt.sender)")
        print("receiptType : \(receipt.receiptType)")
        print("timeStamp : \(receipt.timeStamp)")
    }
    
    func onMessageRead(receipt : MessageReceipt) {
        
        print("onMessageRead as \(receipt as Any)")
        
        print("receipt receiver : \(receipt.receiverId)")
        print("receipt receiver type : \(receipt.receiverType == .group ? "group" : "user")")
        print("message Id : \(receipt.messageId)")
        print("sender : \(receipt.sender)")
        print("sender uid : \(receipt.sender?.uid)")
        print("receiptType : \(receipt.receiptType)")
        print("timeStamp : \(receipt.timeStamp)")
    }

    func onTextMessageReceived(textMessage: TextMessage?, error: CometChatException?) {
        
        if error == nil {
            
            CometChat.markMessageAsRead(message: textMessage!)
            
            print("Message Received on AppDelegate : \(textMessage?.stringValue())")
        }
        else {
            print("Message received error : \(error)")
        }
    }
    
    func onMediaMessageReceived(mediaMessage: MediaMessage?, error: CometChatException?) {
        
        if error == nil {
            print("Media Message Received on AppDelegate : \(mediaMessage?.stringValue())")
        }
        else {
            print("Media Message received error : \(error)")
        }
    }
    
    func onCustomMessageReceived(customMessage: CustomMessage?, error: CometChatException?) {
        
        if error == nil {
            print("Custom Message Received on AppDelegate : \(customMessage?.stringValue())")
        }
        else {
            print("Custom Message received error : \(error)")
        }
    }
    
    func onTypingStarted(_ typingDetails: TypingIndicator) {
        
        print("Typing Started on AppDelegate : \(typingDetails as Any)")
    }
    
    func onTypingEnded(_ typingDetails: TypingIndicator) {
        
        print("Typing Stopped on AppDelegate : \(typingDetails as Any)")
    }
}

extension AppDelegate : CometChatUserDelegate {
    
    func onUserOnline(user: User) {
        
        print("user online : \(user.stringValue())")
    }
    
    func onUserOffline(user: User) {
        
        print("user offline : \(user.stringValue())")
    }
}

extension AppDelegate : CometChatGroupDelegate {
    
    func onGroupMemberJoined(action: ActionMessage, joinedUser: User, joinedGroup: Group) {
        print("message : \(action.stringValue()) \(joinedUser.name) joined \(joinedGroup.name) group")
    }
    
    func onGroupMemberLeft(action: ActionMessage, leftUser: User, leftGroup: Group) {
        print("message : \(action.stringValue()) \(leftUser.name) left \(leftGroup.name) group")
    }
    
    func onGroupMemberKicked(action: ActionMessage, kickedUser: User, kickedBy: User, kickedFrom: Group) {
        print("message : \(action.stringValue()) \(kickedUser.name) kicked by \(kickedBy.name) from \(kickedFrom.name) group")
    }
    
    func onGroupMemberBanned(action: ActionMessage, bannedUser: User, bannedBy: User, bannedFrom: Group) {
        print("message : \(action.stringValue()) \(bannedUser.name) banned by \(bannedBy.name) from \(bannedFrom.name) group")
    }
    
    func onGroupMemberUnbanned(action: ActionMessage, unbannedUser: User, unbannedBy: User, unbannedFrom: Group) {
        print("message : \(action.stringValue()) \(unbannedUser.name) banned by \(unbannedBy.name) from \(unbannedFrom.name) group")
    }
    
    func onGroupMemberScopeChanged(action: ActionMessage, user: User, scopeChangedTo: String, scopeChangedFrom: String, group: Group) {
        print("message : \(action.stringValue()) \(user.name) scope changed to \(scopeChangedTo) from \(scopeChangedFrom) in \(group.name) group")
    }
}
