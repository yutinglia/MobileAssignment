//
//  RegisterViewController.swift
//  Assignment2
//
//  Created by YuTing Lai on 7/1/2022.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfPassword: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnRegClick(_ sender: Any) {
        let ac = tfUserName.text!;
        let email = tfEmail.text!;
        let phone = tfPhone.text!;
        var pwd = tfPassword.text!;
        var cpwd = tfConfPassword.text!;
        if(pwd != cpwd){
            showOkAlert(view: self, title: "Oops", msg: "Confirm password is incorrect", callback: nil);
            return;
        }
        var hash = "LOL" + ac + "HAHA" + pwd;
        hash = hash.sha256;
        pwd = "";
        cpwd = "";
        let body = "ac=\(ac)&pwd=\(hash)&email=\(email)&phone=\(phone)";
        apiPost(apiName: "account", body: body, callback: {
            (result:RegisterResult?) in
            guard let result = result else { print("???"); return; }
            if(result.status == 0){
                // register success
                DispatchQueue.main.async{
                    showOkAlert(view: self, title: "Success", msg: result.msg, callback: {
                        self.navigationController?.popViewController(animated: true);
                    });
                }
            }else{
                // fail
                DispatchQueue.main.async{
                    showOkAlert(view: self, title: "Oops", msg: result.msg, callback: nil);
                }
            }
        });
    } // end btnRegClick
    
    
}
