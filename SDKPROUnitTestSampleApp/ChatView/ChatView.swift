//
//  ChatView.swift
//  SampleApp
//
//  Created by Budhabhooshan Patil on 06/02/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit
import CometChatPro
class ChatView: UIViewController {
    
    var messagesTable = UITableView();
    let msgsRefreshControl = UIRefreshControl()
    let cellReuseIdentifier = "cell"
    var receiverUID = "";
    var receiverType:CometChat.ReceiverType?;
    var appEntity:AppEntity! = nil
    var sendMesaage : UIBarButtonItem?
    
    var messageRequest:MessagesRequest?;
    var groupMemberRequest : GroupMembersRequest?
    var bannedGroupMemberRequest : BannedGroupMembersRequest?
    
    var messageList:[BaseMessage]  = [] {
        
        didSet{
            DispatchQueue.main.async { [weak self] in
                
                guard let strongref = self  else {
                    return
                }
                strongref.messagesTable.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTable();
        
        messagesTable.refreshControl = msgsRefreshControl
        msgsRefreshControl.addTarget(self, action: #selector(loadEarlierMessages), for: .valueChanged)
        
        if let uid = (self.appEntity as? User)?.uid, self.appEntity.isKind(of: User.self) {
            
            receiverUID = uid;
            receiverType = .user;
            
            messageRequest = MessagesRequest.MessageRequestBuilder().set(UID: receiverUID).set(limit: 30).build();
            CometChat.startTyping(indicator: TypingIndicator(receiverID: receiverUID, receiverType: .user))
            CometChat.endTyping(indicator: TypingIndicator(receiverID: receiverUID, receiverType: .user))
            CometChat.startTyping(indicator: TypingIndicator(receiverID: receiverUID, receiverType: .user))
            CometChat.startTyping(indicator: TypingIndicator(receiverID: receiverUID, receiverType: .user))
            
            CometChat.getUser(UID: receiverUID, onSuccess: { (user) in
                
                if let _user = user {
                    print("get user : \(_user.stringValue())")
                }
                
            }) { (error) in
                
                print("error in gettaing user : \(error?.errorDescription)")
            }
                
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
                
                guard let strongSelf = self
                    else
                {
                    return
                }
                
                CometChat.startTyping(indicator: TypingIndicator(receiverID: strongSelf.receiverUID, receiverType: .user))
            }
            
        }else if self.appEntity.isKind(of: Group.self){
            
            receiverUID = (self.appEntity as! Group).guid;
            receiverType = .group;
            
            messageRequest = MessagesRequest.MessageRequestBuilder().set(GUID: receiverUID).set(limit: 30).build();
            
            let bannedUserList = BannedGroupMembersRequest.BannedGroupMembersRequestBuilder(guid: receiverUID).setLimit(limit: 30).build()
            
            bannedUserList.fetchNext(onSuccess: { (groupMembers) in
                
                groupMembers.forEach({ (groupMember) in
                    
                    print("groupMember : \(groupMember.stringValue())")
                    
                })
                
            }) { (error) in
                
                print("error : \(error?.errorDescription)")
            }
            
            groupMemberRequest = GroupMembersRequest.GroupMembersRequestBuilder(guid: receiverUID).setLimit(limit: 30).build()
            bannedGroupMemberRequest = BannedGroupMembersRequest.BannedGroupMembersRequestBuilder(guid: receiverUID).setLimit(limit: 30).build()

            CometChat.endTyping(indicator: TypingIndicator(receiverID: receiverUID, receiverType: .user))
            
            let typingIndicator = TypingIndicator(receiverID: receiverUID, receiverType: .group)
            typingIndicator.metadata = ["customKey": 123]
            
            CometChat.startTyping(indicator: typingIndicator)
        }
        
        sendMesaage = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(sendMessage))
        self.navigationItem.setRightBarButton(sendMesaage!, animated: true);
        
        self.loadEarlierMessages();
        
    }
    
    func configureTable() -> Void {
        
        self.messagesTable = UITableView(frame: self.view.frame, style: .plain);
        self.messagesTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.messagesTable.dataSource = self;
        self.messagesTable.delegate = self;
        self.messagesTable.autoresizingMask = [.flexibleWidth , .flexibleHeight];
        self.view.addSubview(self.messagesTable);
    }
    
    @objc func loadEarlierMessages() -> Void {
        
        messageRequest?.fetchPrevious(onSuccess: { [weak self](messages_received) in
            
            guard let strongSelf = self
                else
            {
                return
            }
            
            if strongSelf.messageList.count <= 0 {
                strongSelf.messageList = messages_received!;
            }
            else {
                strongSelf.messageList.insert(contentsOf: messages_received!, at: 0)
            }
            
            DispatchQueue.main.async {
                strongSelf.msgsRefreshControl.endRefreshing()
            }
            
        }) { [weak self](error) in
            
            guard let strongSelf = self
                else
            {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.msgsRefreshControl.endRefreshing()
            }
            
            print(error?.errorDescription);
            
        }
    }
    
    @objc func loadNextMessages() -> Void {
        
        messageRequest?.fetchNext(onSuccess: { (messages_received) in
            
            print("fetch Next meesgaes received...")
            
        }, onError: { (error) in
            
            print("fetch next error : \(error?.errorDescription)")
        })
    }
    
    @objc func sendMessage() -> Void {
        
        let newAction = UIAlertController(title: "Send Message", message: nil, preferredStyle: .actionSheet);
        
        if let popoverController = newAction.popoverPresentationController {
            popoverController.barButtonItem = self.navigationItem.rightBarButtonItem // you can set this as per your requirement.
            popoverController.permittedArrowDirections = .up //to hide the arrow of any particular direction
        }
        
        let textMessage = UIAlertAction(title: "Text Message", style: .default) { [weak self](action) in
            
            guard let strongSelf = self
            else
            {
                return
            }
            
            CometChat.sendTextMessage(message: TextMessage(receiverUid: strongSelf.receiverUID, text: "this_is_ios_default_\(Int.random(in: 1...10))", messageType: .text, receiverType: strongSelf.receiverType!), onSuccess: { [weak self](messages_received) in
                
                guard let strongSelf = self
                else
                {
                    return
                }
                
                if strongSelf.messageList.count == 0 {
                    strongSelf.messageList = [messages_received];
                }
                else {
                    strongSelf.messageList.append(messages_received);
                }
                
            }, onError: { (error) in
                
                print("error in sending text Message \(error?.errorDescription)")
            });
        }
        
        let mediaMessage = UIAlertAction(title: "Media Message", style: .default) { (action ) in
            
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.allowsEditing = true
            vc.delegate = self;
            self.present(vc, animated: true)
        }
        
        let callMessage = UIAlertAction(title: "Call", style: .default) { [weak self](action) in
            
            guard let strongSelf = self
            else
            {
                return
            }
            
            CometChat.initiateCall(call: Call(receiverId: strongSelf.receiverUID, callType: .video, receiverType: strongSelf.receiverType!), onSuccess: { (ongoing_call) in
                
                print(ongoing_call!.stringValue())
                
            }, onError: { (error) in
                
                print("error in sending call Message \(error?.errorDescription)")
            });
            
        }
        
        let customMessage = UIAlertAction(title: "Custom Message", style: .default) { [weak self](action) in
            
            guard let strongSelf = self
            else
            {
                return
            }
            
            let customMessage = CustomMessage(receiverUid: strongSelf.receiverUID, receiverType: strongSelf.receiverType!, customData: ["customdata" : 12345])
            customMessage.metaData = ["metakey" : "meta data"]
            customMessage.subType = "myType"
            
            CometChat.sendCustomMessage(message: customMessage, onSuccess: { (customMessage) in
                
                print(customMessage.stringValue())

            }, onError: { (error) in
                
                print("error in sending custom Message \(error?.errorDescription)")
            })
        }
    
        newAction.addAction(textMessage);
        newAction.addAction(mediaMessage);
        newAction.addAction(callMessage);
        newAction.addAction(customMessage);
        
        if let group = appEntity as? Group {
           
            if !group.hasJoined {
                
                let joinGroup = UIAlertAction(title: "Join Group", style: .default) { (action) in
                    
                    CometChat.joinGroup(GUID: group.guid, groupType: group.groupType, password: group.password, onSuccess: { (successString) in
                       
                        print("group joined successfully. \(successString.stringValue())")
                        
                    }, onError: { (error) in
                        
                        print("error in joining the group \(error?.errorDescription)")
                    })
                }
                
                newAction.addAction(joinGroup);
            }
            else
            {
                
                let getGroupMembersAction = UIAlertAction(title: "Get Group Members", style: .default) { [weak self](action) in
                    
                    guard let strongSelf = self
                        else
                    {
                        return
                    }
                    
                    strongSelf.groupMemberRequest?.fetchNext(onSuccess: { (groupMembers) in
                        
                        groupMembers.forEach({ (groupMember) in
                            print("group Member: \(groupMember.stringValue())")
                        })
                        
                    }, onError: {(error) in
                        
                        print("error in fetch group Members : \(error?.errorDescription)")
                    })
                }
                
                newAction.addAction(getGroupMembersAction)
                
                let addGroupMembersAction = UIAlertAction(title: "Add Group members", style: .default) { [weak self](action) in
                    
                    guard let strongSelf = self
                    else
                    {
                        return
                    }
                    
                    let participantMember = GroupMember(UID: "superhero1", groupMemberScope: CometChat.GroupMemberScopeType.participant)
                    let adminMember = GroupMember(UID: "superhero2", groupMemberScope: .admin)
                    let moderator = GroupMember(UID: "superhero3", groupMemberScope: .moderator)
                    let groupMembers : [GroupMember] = [participantMember, adminMember]
                    let bannedMembers : [String] = []
                    
//                    CometChat.addGroupMembersToGroup(guid: strongSelf.receiverUID, groupMembers: groupMembers, bannedUIDs: bannedMembers, onSuccess: { (addMemberResponse) in
//                        
//                        print("add member response : \(addMemberResponse)")
//                        
//                    }, onError: { (error) in
//                        
//                        print("error in add members to group \(error?.errorDescription)")
//                        
//                    })
                }
                
                newAction.addAction(addGroupMembersAction)

                let getBannedGroupMembers = UIAlertAction(title: "Get Banned Members", style: .default) { [weak self](action) in
                    
                    guard let strongSelf = self
                    else
                    {
                        return
                    }
                    
                    strongSelf.bannedGroupMemberRequest?.fetchNext(onSuccess: { (groupMembers) in
                        
                        groupMembers.forEach({ (groupMember) in
                            print("Banned Group Member : \(groupMember.stringValue())")
                        })
                        
                    }, onError: { (error) in
                        
                        print("error in fetching banned group member : \(error?.errorDescription)")
                    })
                }
                
                newAction.addAction(getBannedGroupMembers)
                
                let leaveGroup = UIAlertAction(title: "Leave group", style: .default) { (action) in
                 
                    CometChat.leaveGroup(GUID: group.guid, onSuccess: { (successString) in
                        
                        print("group left successfully.")
                        
                    }, onError: { (error) in
                        
                        print("error in leaving the group \(error?.errorDescription)")
                    })
                }
                
                newAction.addAction(leaveGroup);
            }
        }
        
        self.present(newAction, animated: true, completion: nil);
    }
}

extension ChatView:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if #available(iOS 11.0, *) {
            
            if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL
            {
                do
                {
                    let imgName = imgUrl.lastPathComponent
                    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                    let localPath = documentDirectory?.appending("/"+imgName)
                    
                    let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                    let data = image.jpegData(compressionQuality: 0.8)! as NSData
                    data.write(toFile: localPath!, atomically: true)

                    let photoURL = URL(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
                    print(photoURL)
                    picker.dismiss(animated: true, completion: nil)
                    
                    let imageFromPath = UIImage(data: try Data(contentsOf: photoURL))
                    print("image : \(imageFromPath)")
                    
                    CometChat.sendMediaMessage(message: MediaMessage(receiverUid: self.receiverUID, fileurl: photoURL.absoluteString, messageType: .image, receiverType: appEntity.isKind(of: Group.self) ? .group : .user), onSuccess: { (messages_received) in
                        
                        if self.messageList.count == 0 {
                            self.messageList = [messages_received];
                        }
                        else {
                            self.messageList.append(messages_received);
                        }
                        
                    }, onError: { (error) in
                        
                        print("error in sending message : \(error?.errorDescription)")
                    });
                }
                catch
                {
                    print("error : \(error.localizedDescription)")
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ChatView:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row);
    }
}

extension ChatView:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.messagesTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath);
        
        if messageList[indexPath.row].isKind(of: TextMessage.self) {
            cell.textLabel?.text = (messageList[indexPath.row] as! TextMessage).text
        }else if messageList[indexPath.row].isKind(of: MediaMessage.self){
            cell.textLabel?.text = (messageList[indexPath.row] as! MediaMessage).url
        }else if messageList[indexPath.row].isKind(of: ActionMessage.self){
            cell.textLabel?.text = (messageList[indexPath.row] as! ActionMessage).message
        }else if messageList[indexPath.row].isKind(of: Call.self){
            cell.textLabel?.text = "call ID : \((messageList[indexPath.row] as! Call).id) & call Status : \((messageList[indexPath.row] as! Call).callStatus)"
        }
        else if messageList[indexPath.row].isKind(of: CustomMessage.self) {
            cell.textLabel?.text  = "Custom Message \n\(String(describing: (messageList[indexPath.row] as? CustomMessage)?.customData))"
        }
        
        if appEntity.isKind(of: User.self) {
            cell.textLabel?.textAlignment = (messageList[indexPath.row].senderUid == (appEntity as! User).uid ? .right : .left)
        }
        else if appEntity.isKind(of: Group.self) {
            cell.textLabel?.textAlignment = (messageList[indexPath.row].receiverUid == (appEntity as! Group).guid ? .left : .right)
        }
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == messageList.count - 1 {
            loadNextMessages()
        }
    }
}
