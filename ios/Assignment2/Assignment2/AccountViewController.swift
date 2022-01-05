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
        
        if(account == "1" && password == "1"){
            print("ok");
        }else{
            // login fail
            print("not ok");
            let alert = UIAlertController(title: "Login Error", message: "Login Fail", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: {
                _ in
                self.navigationController?.popViewController(animated: true);
            })
            alert.addAction(alertAction);
            present(alert, animated: true, completion: nil)
        }

    }
    
}
