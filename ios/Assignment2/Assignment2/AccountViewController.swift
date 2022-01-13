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
    
    var accountObj : Account? = nil;
    
    @IBOutlet weak var lblAc: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!KeychainHelper.isAccessTokenExist()){
            // login
            LoginManager.login(account: account, password: password, handler: loginInfoHandler);
        }else{
            LoginManager.verifyAndRefreshToken(handler: {
                (result:LoginInfo) in
                if(result.token == "0"){
                    AlertHelper.showOkAlert(view: self, title: "Expired", msg: "Login has expird, please login again.", onOkClick: {
                        self.navigationController?.popViewController(animated: true);
                    });
                }else{
                    self.password = "";
                    Accounts.getCurrentAccountInfo(handler: self.accountInfoHandler);
                }
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Accounts.getCurrentAccountInfo(handler: self.accountInfoHandler);
    }
    
    func accountInfoHandler(result:Account){
        DispatchQueue.main.async{
            self.lblAc.text = "Account: \(result.account)";
            self.lblEmail.text = "Email: \(result.email)";
            self.lblPhone.text = "Phone: \(result.phone)";
            self.accountObj = result;
        }
    }
    
    func loginInfoHandler(result:LoginInfo){
        if(result.token == "0"){
            // login fail
            DispatchQueue.main.async{
                AlertHelper.showOkAlert(view: self, title: "Login Error", msg: "Login Fail", onOkClick: {
                    self.navigationController?.popViewController(animated: true);
                });
            }
        }else{
            // login ok
            self.password = "";
            if(KeychainHelper.saveAccessToken(loginInfo: result)){
                DispatchQueue.main.async{
                    self.navigationItem.setHidesBackButton(true, animated: true);
                }
            }else{
                print("stored token fail");
                DispatchQueue.main.async{
                    AlertHelper.showOkAlert(view: self, title: "Login Error", msg: "Stored Access Token Fail", onOkClick: {
                        self.logout();
                        self.navigationController?.popViewController(animated: true);
                    });
                }
            }
            Accounts.getCurrentAccountInfo(handler: self.accountInfoHandler);
        }
    }
    
    @IBAction func btnLogoutClick(_ sender: Any) {
        logout();
        self.navigationController?.popViewController(animated: true);
    }
    
    func logout(){
        KeychainHelper.clearAccessToken();
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let ac = accountObj else {
            return;
        }
        if let des = segue.destination as? EditAccountViewController {
            des.prePhone = ac.phone;
            des.preEmail = ac.email;
            des.account = ac.account;
        }else if let des = segue.destination as? ResetPasswordViewController {
            des.account = ac.account;
        }
    }
    
    
}
