//
//  EditAccountViewController.swift
//  Assignment2
//
//  Created by YuTing Lai on 11/1/2022.
//

import UIKit

class EditAccountViewController: UIViewController {
    
    var preEmail = "";
    var prePhone = "";
    var account = "";
    
    @IBOutlet weak var tfAccount: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfAccount.text = account;
        tfEmail.text = preEmail;
        tfPhone.text = prePhone;
    }

    
    @IBAction func btnConfirmClick(_ sender: Any) {
        editAccount(email: tfEmail.text!, phone: tfPhone.text!, handler: {
            result in
            if(result.status == 0){
                DispatchQueue.main.async{
                    showOkAlert(view: self, title: "Success", msg: result.msg, callback: {
                        self.dismiss(animated: true, completion: nil);
                    });
                }
            }else{
                DispatchQueue.main.async{
                    showOkAlert(view: self, title: "Fail", msg: result.msg, callback: nil);
                }
            }
        })
    }
    
}
