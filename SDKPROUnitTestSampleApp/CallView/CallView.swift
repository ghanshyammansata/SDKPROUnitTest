//
//  CallView.swift
//  SampleApp
//
//  Created by Inscripts11 on 08/02/19.
//  Copyright © 2019 Inscripts.com. All rights reserved.
//

import UIKit
import CometChatPro

class CallView: UIViewController {
    
    @IBOutlet weak var callEndBtn: UIButton!
    
    @IBOutlet weak var callAnswerBtn: UIButton!
    
    @IBOutlet weak var callTimerLbl: UILabel!
    
    @IBOutlet weak var calleeNameLbl: UILabel!
    
    var timer = Timer()
    
    var seconds = 0
    
    var receivedCall : Call?
    
    init(receivedCall : Call) {
        super.init(nibName: nil, bundle: nil)
        self.receivedCall = receivedCall
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func runTimer() {
        
        DispatchQueue.main.async {[weak self] in
            
            guard let strongSelf = self else {return}
            
            strongSelf.timer = Timer.scheduledTimer(timeInterval: 1, target: strongSelf, selector: #selector(strongSelf.updateTimer), userInfo: nil, repeats: true)
            strongSelf.callTimerLbl?.isHidden = false
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    @objc func updateTimer() {
        seconds += 1
        callTimerLbl.text = timeString(time: TimeInterval(seconds))
    }
    
    @IBAction func callEndBtnClicked(_ sender: Any) {
        
        if let sesssionId = receivedCall?.sessionID {
            
            CometChat.rejectCall(sessionID: sesssionId, status: .rejected, onSuccess: { [weak self](call) in
                
                guard let strongSelf = self
                    else
                {
                    return
                }
                
                if let _ = call {
                    
                    DispatchQueue.main.async {

                        strongSelf.timer.invalidate()
                        strongSelf.callTimerLbl.text = "call ended"
                        strongSelf.callTimerLbl.isHidden = true
                        strongSelf.dismiss(animated: true, completion: nil)
                    }
                }
                
            }) { (error) in
                
                print("Error on ending call : \(String(describing: error?.errorDescription))")
            }
        }
    }
    
    @IBAction func callAnswerBtnClicked(_ sender: Any) {
        
        if let sessionId = receivedCall?.sessionID {
            
            CometChat.acceptCall(sessionID: sessionId, onSuccess: { [weak self](call) in
                
                guard let strongSelf = self
                    else
                {
                    return
                }
                
                if let _ = call {
                    
                    strongSelf.runTimer()
                    
                    CometChat.startCall(sessionID: sessionId, inView: strongSelf.view, userJoined: { (user_joined) in
                        
                        print("user joined : \(user_joined)")
                        
                    }, userLeft: { (user_left) in
                        
                        print("user left \(user_left)")
                        
                    }, onError: { (exception) in
                        
                        print("exception : \(exception)")
                        
                    }, callEnded: { [weak self](call_ended) in
                        
                        guard let strongSelf = self
                        else
                        {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            
                            strongSelf.dismiss(animated: true, completion: nil)

                        }
                                            
                        print("call ended : \(call_ended)")
                    })
                }
                
                }, onError: { (error) in
                    
                    print("Error in accepting call : \(error?.errorDescription)")
            })
        }
    }
}
