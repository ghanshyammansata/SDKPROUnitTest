//
//  Users.swift
//  SampleApp
//
//  Created by Budhabhooshan Patil on 06/02/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit
import CometChatPro

class Users: UIViewController {
    
    var usersTable = UITableView();
    let cellReuseIdentifier = "cell"
    let userListRefreshControl = UIRefreshControl()
    let userRequest = UsersRequest.UsersRequestBuilder(limit: 2).build();
    
    var userList:[User]  = [] {
        
        didSet{
            DispatchQueue.main.async { [weak self] in
                
                guard let strongref = self  else {
                    return
                }
                strongref.userListRefreshControl.endRefreshing()
                strongref.usersTable.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTable();
        self.loadUserList();
    }
    
    func configureTable() -> Void {
        
        self.usersTable = UITableView(frame: self.view.frame, style: .plain);
        self.usersTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.usersTable.dataSource = self;
        self.usersTable.delegate = self;
        
        self.usersTable.refreshControl = userListRefreshControl
        
        userListRefreshControl.addTarget(self, action: #selector(loadUserList), for: .valueChanged)
        
        self.view.addSubview(self.usersTable);
        
    }
    
    @objc func loadUserList() -> Void {
        
        userRequest.fetchNext(onSuccess: { (users_received) in
            
            if self.userList.count == 0 {
                self.userList = users_received;
            }
            else {
                self.userList.append(contentsOf: users_received);
            }
            
        }) { [weak self](error) in
            
            guard let strongSelf = self
            else
            {
                return
            }
            
            DispatchQueue.main.async {
                
                strongSelf.userListRefreshControl.endRefreshing()
                
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

extension Users:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row);
        pushToNext(appEntity: userList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
}

extension Users:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.usersTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath);
        cell.textLabel?.text = userList[indexPath.row].uid;
        return cell;
    }
}
