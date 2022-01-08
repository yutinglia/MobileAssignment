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

func getLoginInfo(account:String, password:String,
                  handler: @escaping (LoginInfo) -> () ){
    var hash = "LOL" + account + "HAHA" + password;
    hash = hash.sha256;
    let body = "ac=\(account)&pwd=\(hash)";
    apiPost(apiName: "auth", body: body, callback: {
        (result:LoginInfo?) in
        guard let result = result else {
            print("???");
            handler(LoginInfo(account: "0", token: "0"));
            return;
        }
        handler(result);
    });
}

func verifyTokenAndRefreshToken(){
    
}
