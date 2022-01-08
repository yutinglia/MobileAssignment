//
//  AccessToken.swift
//  Assignment2
//
//  Created by YuTing Lai on 5/1/2022.
//

import Foundation

struct LoginInfo : Codable{
    var account: String;
    var email: String;
    var phone: String;
    var token: String;
}

func getLoginInfo(account:String, password:String) -> LoginInfo{
    var hash = "LOL" + account + "HAHA" + password;
    hash = hash.sha256;
    let body = "ac=\(account)&pwd=\(hash)";
    var loginInfo: LoginInfo = LoginInfo(account: "0", email: "0", phone: "0", token: "0");
    apiPost(apiName: "auth", body: body, callback: {
        (result:LoginInfo?) in
        guard let result = result else { print("???"); return; }
        loginInfo = result;
    });
    return loginInfo;
}
