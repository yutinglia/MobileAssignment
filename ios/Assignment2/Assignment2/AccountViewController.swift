//
//  AccountViewController.swift
//  Assignment2
//
//  Created by YuTing Lai on 5/1/2022.
//

import UIKit

class AccountViewController: UIViewController {
    
    var account : String = "";
    var password : String = "";

    override func viewDidLoad() {
        super.viewDidLoad()
        getAndCheckAccessToken();
    }
    
    // login
    func getAndCheckAccessToken(){
        let body = "ac=\(account)&pwd=\(password)";
        apiPost(apiName: "auth", body: body, callback: {
            (result:LoginInfo?) in
            guard let result = result else { print("???"); return; }
            if(result.token == "0"){
                // login fail
                DispatchQueue.main.async{
                    showOkAlert(view: self, title: "Login Error", msg: "Login Fail", callback: {
                        self.navigationController?.popViewController(animated: true);
                    });
                }
            }else{
                // login ok
                print(result);
            }
        });
    }
    
}
