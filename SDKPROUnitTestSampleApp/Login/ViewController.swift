//
//  ViewController.swift
//  SampleApp
//
//  Created by Budhabhooshan Patil on 06/02/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit
import CometChatPro

class ViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let isLoggedIn = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool, isLoggedIn {
            
            print("loggedInUserDetails : \(CometChat.getLoggedInUser()?.stringValue())")
            
            pushToNext()
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
    
        CometChat.login(UID: userTextField.text!, apiKey: AppConstant.API_KEY, onSuccess: { [weak self](logged_in_user) in
            
            guard let strongSelf = self else { return }
            
            print(logged_in_user);
            
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            strongSelf.pushToNext();

        }) { (error) in
            
            print("error in login... \(error.errorDescription)")
        }
    }
    
    private func pushToNext(){
        
        DispatchQueue.main.async {
            
            if let tabScreen = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? TabBar {
                 self.navigationController?.pushViewController(tabScreen, animated: true)
            }
        }
    }
}

extension ViewController  : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

