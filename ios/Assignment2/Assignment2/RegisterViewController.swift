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
        let pwd = tfPassword.text!;
        let cpwd = tfConfPassword.text!;
        if(pwd != cpwd){
            showOkAlert(view: self, title: "Oops", msg: "Confirm password is incorrect", callback: nil);
            return;
        }
        let result = createAccount(ac: ac, pwd: pwd, email: email, phone: phone)
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
    } // end btnRegClick
    
    
}
