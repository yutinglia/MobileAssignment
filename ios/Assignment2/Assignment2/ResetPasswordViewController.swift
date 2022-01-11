//
//  ResetPasswordViewController.swift
//  Assignment2
//
//  Created by YuTing Lai on 11/1/2022.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    var account = "";

    @IBOutlet weak var tfOldPwd: UITextField!
    @IBOutlet weak var tfNewPwd: UITextField!
    @IBOutlet weak var tfConfNewPwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnConfirmClick(_ sender: Any) {
        if(tfNewPwd.text! != tfConfNewPwd.text!){
            showOkAlert(view: self, title: "Oops", msg: "Confirm password is incorrect", callback: nil);
            return;
        }
        resetPassword(ac: account, pwd: tfNewPwd.text!, opwd: tfOldPwd.text!, handler: {
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
