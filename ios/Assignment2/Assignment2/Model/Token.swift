//
//  AccessToken.swift
//  Assignment2
//
//  Created by YuTing Lai on 5/1/2022.
//

import Foundation

struct LoginInfo : Codable{
    var account: String;
    var token: String;
}

class LoginManager{
    
    public static func login(
        account:String,
        password:String,
        handler: @escaping (LoginInfo) -> () ){
            
        // salt
        var hash = "LOL" + account + "HAHA" + password;
        hash = hash.sha256;
        let body = "ac=\(account)&pwd=\(hash)";
        ApiHelper.apiPost(path: "auth", body: body, callback: {
            (result:LoginInfo?) in
            guard let result = result else {
                print("???");
                handler(LoginInfo(account: "0", token: "0"));
                return;
            }
            handler(result);
        });
    }

    // check token and get new token ( token will expired after 1 day )
    public static func verifyAndRefreshToken(handler: @escaping (LoginInfo) -> () ){
        ApiHelper.apiGetWithToken(path: "auth", callback: {
            (result:LoginInfo?) in
            guard let result = result else {
                print("???");
                handler(LoginInfo(account: "0", token: "0"));
                return;
            }
            // update token
            _ = KeychainHelper.saveAccessToken(loginInfo: result);
            handler(result);
        })
    }
    
}
