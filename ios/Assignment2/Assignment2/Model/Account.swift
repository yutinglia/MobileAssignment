//
//  Account.swift
//  Assignment2
//
//  Created by YuTing Lai on 5/1/2022.
//

import Foundation

struct Account : Codable{
    var account: String;
    var password: String;
    var email: String;
    var phone: String;
}

struct RegisterResult : Codable{
    var status: Int;
    var msg: String;
}

func getCurrentAccountInfo(handler: @escaping (Account) -> () ){
    apiGetWithToken(path: "user/account", callback: {
        (result:Account?) in
        guard let result = result else {
            print("???");
            handler(Account(account: "", password: "", email: "", phone: ""));
            return;
        }
        handler(result);
    })
}

func createAccount(ac:String,
                   pwd:String,
                   email:String,
                   phone:String,
                   handler: @escaping (RegisterResult) -> () ){
    var hash = "LOL" + ac + "HAHA" + pwd;
    hash = hash.sha256;
    let body = "ac=\(ac)&pwd=\(hash)&email=\(email)&phone=\(phone)";
    apiPost(apiName: "account", body: body, callback: {
        (result:RegisterResult?) in
        guard let result = result else {
            print("???");
            handler(RegisterResult(status: 1, msg: "Unknow Error"));
            return;
        }
        handler(result);
    });
}
