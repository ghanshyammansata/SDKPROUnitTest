//
//  Groups.swift
//  SampleApp
//
//  Created by Budhabhooshan Patil on 06/02/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit
import CometChatPro

class Groups: UIViewController {
    
    var groupsTable = UITableView();
    
    let cellReuseIdentifier = "cell"
    let msgsRefreshControl = UIRefreshControl()
    let groupRequest = GroupsRequest.GroupsRequestBuilder(limit: 2).build();
    
    var joinedGroupsArray = [Group]();
    var unjoinedGroups = [Group]();
    
    var groupList:[Group]  = [] {
        
        didSet{
            DispatchQueue.main.async { [weak self] in
                
                guard let strongref = self  else {
                    return
                }
                
                strongref.joinedGroupsArray.removeAll();
                strongref.unjoinedGroups.removeAll();
                
                for group in strongref.groupList {
                    
                    if group.hasJoined{
                        strongref.joinedGroupsArray.append(group);
                    }else{
                        strongref.unjoinedGroups.append(group);
                    }
                }
                
                strongref.msgsRefreshControl.endRefreshing()
                strongref.groupsTable.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureTable();
        loadGroupList()
    }
    
    func configureTable() -> Void {
        
        self.groupsTable = UITableView(frame: self.view.frame, style: .plain);
        self.groupsTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.groupsTable.dataSource = self;
        self.groupsTable.delegate = self;
        self.groupsTable.refreshControl = msgsRefreshControl
        
        msgsRefreshControl.addTarget(self, action: #selector(loadGroupList), for: .valueChanged)
        
        self.view.addSubview(self.groupsTable);
        
    }
    
    @objc func loadGroupList() -> Void {
        
        groupRequest.fetchNext(onSuccess: { [weak self](groups_received) in
            
            guard let strongSelf = self
            else
            {
                return
            }
            
            groups_received.forEach({ (group) in
                print("group : \(group.scope.rawValue)")
            })
            
            if strongSelf.groupList.count == 0 {
                strongSelf.groupList = groups_received;
            }
            else {
                strongSelf.groupList.append(contentsOf: groups_received);
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
            
            print(error?.errorDescription as Any);
        }
    }
    
    private func pushToNext(appEntity:AppEntity){
        
        DispatchQueue.main.async {
            
            if let chatScreen = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatView {
                chatScreen.appEntity = appEntity;
                self.navigationController?.pushViewController(chatScreen, animated: true)
            }
        }
    }
}
extension Groups:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.section {
            
        case 0:
            pushToNext(appEntity: joinedGroupsArray[indexPath.row]);
            break;
        case 1:
            pushToNext(appEntity: unjoinedGroups[indexPath.row]);
            break;
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.unjoinedGroups.count != 0 {
            return 2
        }
        return 1;
    }
}

extension Groups:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "joined"
        default:
            return "unjoined"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return self.joinedGroupsArray.count ;
        default:
            return self.unjoinedGroups.count ;
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.groupsTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath);
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = joinedGroupsArray[indexPath.row].guid;
        case 1:
            cell.textLabel?.text = unjoinedGroups[indexPath.row].guid;
        default:
             cell.textLabel?.text = "ERROR";
        }
        
        return cell;
    }
}

