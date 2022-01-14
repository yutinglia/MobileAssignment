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

struct EditResult : Codable{
    var status: Int;
    var msg: String;
}

struct ResetPasswordResult : Codable{
    var status: Int;
    var msg: String;
}

class Accounts{
    
    public static func getCurrentAccountInfo(handler: @escaping (Account) -> () ){
        ApiHelper.apiGetWithToken(path: "user/account", callback: {
            (result:Account?) in
            guard let result = result else {
                print("???");
                handler(Account(account: "", password: "", email: "", phone: ""));
                return;
            }
            handler(result);
        })
    }

    public static func createAccount(
        ac:String,
        pwd:String,
        email:String,
        phone:String,
        handler: @escaping (RegisterResult) -> () ){
            
        // add some salt and hashed
        var hash = "LOL" + ac + "HAHA" + pwd;
        hash = hash.sha256;
        let body = "ac=\(ac)&pwd=\(hash)&email=\(email)&phone=\(phone)";
        ApiHelper.apiPost(path: "account", body: body, callback: {
            (result:RegisterResult?) in
            guard let result = result else {
                print("???");
                handler(RegisterResult(status: 1, msg: "Unknow Error"));
                return;
            }
            handler(result);
        });
    }

    public static func editAccount(
        email:String,
        phone:String,
        handler: @escaping (EditResult) -> () ){
            
        let body = "email=\(email)&phone=\(phone)";
        ApiHelper.apiPutWithToken(path: "user/account/info", body: body, callback: {
            (result:EditResult?) in
            guard let result = result else {
                print("???");
                handler(EditResult(status: 1, msg: "Unknow Error"));
                return;
            }
            handler(result);
        });
    }

    public static func resetPassword(
        ac:String,
        pwd:String,
        opwd:String,
        handler: @escaping (ResetPasswordResult) -> () ){
        
        // add some salt and hashed
        var hash = "LOL" + ac + "HAHA" + pwd;
        hash = hash.sha256;
        // add some salt and hashed
        var ohash = "LOL" + ac + "HAHA" + opwd;
        ohash = ohash.sha256;
        let body = "pwd=\(hash)&opwd=\(ohash)";
        ApiHelper.apiPutWithToken(path: "user/account/pwd", body: body, callback: {
            (result:ResetPasswordResult?) in
            guard let result = result else {
                print("???");
                handler(ResetPasswordResult(status: 1, msg: "Unknow Error"));
                return;
            }
            handler(result);
        });
    }

}
