//
//  TabBar.swift
//  SampleApp
//
//  Created by Budhabhooshan Patil on 06/02/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit
import CometChatPro

class TabBar: UITabBarController {

    var logoutBarBtnItem : UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutBarBtnItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutBarBtnItmClicked(_:)))
        self.navigationItem.leftBarButtonItems = [logoutBarBtnItem!]
    }
    
    @objc func logoutBarBtnItmClicked(_ sender : UIBarButtonItem) {
        
        CometChat.logout(onSuccess: { [weak self](isSuccess) in
            
            guard let strongSelf = self
            else
            {
                return
            }
            
            strongSelf.navigationController?.popViewController(animated: true)
            UserDefaults.standard.removeObject(forKey: "isLoggedIn")
            
            print("logged out successfully")
            
        }) { (error) in
            
            print("logout error : \(error.errorDescription)")
        }
    }
}
