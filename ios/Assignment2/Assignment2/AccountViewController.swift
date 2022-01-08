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
        let keychain = KeychainHelper();
        if(!keychain.isAccessTokenExist()){
            // login
            getLoginInfo(account: account, password: password, handler: loginInfoHandler);
        }else{
            verifyTokenAndRefreshToken(handler: {
                (result:LoginInfo) in
                if(result.token == "0"){
                    showOkAlert(view: self, title: "Expired", msg: "Login has expird, please login again.", callback: {
                        self.navigationController?.popViewController(animated: true);
                    });
                }
            })
        }
    }
    
    func loginInfoHandler(result:LoginInfo){
        if(result.token == "0"){
            // login fail
            DispatchQueue.main.async{
                showOkAlert(view: self, title: "Login Error", msg: "Login Fail", callback: {
                    self.navigationController?.popViewController(animated: true);
                });
            }
        }else{
            // login ok
            let keychain = KeychainHelper();
            if(keychain.saveAccessToken(loginInfo: result)){
                // let token = keychain.retrieveAccessToken(account: result.account);
                // guard let token = token else {print("retrieve token fail"); return;}
                // print(token);
                DispatchQueue.main.async{
                    self.navigationItem.setHidesBackButton(true, animated: true);
                }
            }else{
                print("stored token fail");
                DispatchQueue.main.async{
                    showOkAlert(view: self, title: "Login Error", msg: "Stored Access Token Fail", callback: {
                        self.logout();
                        self.navigationController?.popViewController(animated: true);
                    });
                }
            }
        }
    }
    
    @IBAction func btnLogoutClick(_ sender: Any) {
        logout();
        self.navigationController?.popViewController(animated: true);
    }
    
    func logout(){
        let keychain = KeychainHelper();
        keychain.clearAccessToken();
    }
    
    
}
