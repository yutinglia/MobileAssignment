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
        // check user input
        if(ac == "" || email == "" || phone == "" || pwd == "" || cpwd == ""){
            AlertHelper.showOkAlert(view: self, title: "Oops", msg: "Please enter all info", onOkClick: nil);
            return;
        }
        if(pwd != cpwd){
            AlertHelper.showOkAlert(view: self, title: "Oops", msg: "Confirm password is incorrect", onOkClick: nil);
            return;
        }
        Accounts.createAccount(ac: ac, pwd: pwd, email: email, phone: phone, handler: registerResultHandler);
    }
    
    func registerResultHandler(result: RegisterResult){
        if(result.status == 0){
            // register success
            DispatchQueue.main.async{
                AlertHelper.showOkAlert(view: self, title: "Success", msg: result.msg, onOkClick: {
                    self.navigationController?.popViewController(animated: true);
                });
            }
        }else{
            // fail
            DispatchQueue.main.async{
                AlertHelper.showOkAlert(view: self, title: "Oops", msg: result.msg, onOkClick: nil);
            }
        }
    }
    
}
