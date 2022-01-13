//
//  LoginViewController.swift
//  Assignment2
//
//  Created by YuTing Lai on 5/1/2022.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tfUserName.text = "";
        tfPwd.text = "";
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (KeychainHelper.isAccessTokenExist()){
            print("logined");
            DispatchQueue.main.async{
                let sb = UIStoryboard(name: "Main", bundle: nil);
                let vc = sb.instantiateViewController(withIdentifier: "AccountVC");
                self.navigationController?.show(vc, sender: self);
            }
        }
    }

    // try login
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let des = segue.destination as? AccountViewController {
            print("login prepare");
            des.account = tfUserName.text!;
            des.password = tfPwd.text!;
        }
    }

}
