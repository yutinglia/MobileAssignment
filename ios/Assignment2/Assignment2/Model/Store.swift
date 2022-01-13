//
//  Store.swift
//  Assignment2
//
//  Created by YuTing Lai on 12/1/2022.
//

import Foundation

struct Store : Codable{
    var lat: Double;
    var long: Double;
    var name: String;
    var intro: String;
    var address: String;
}

struct AddStoreResult: Codable{
    var status: Int;
    var msg: String;
}

class Stores{
    
    public static func addStore(
        lat: Double,
        long: Double,
        name: String,
        intro: String,
        address: String,
        handler: @escaping (AddStoreResult) -> () ){
            
        let body = "lat=\(lat)&long=\(long)&name=\(name)&intro=\(intro)&address=\(address)";
        ApiHelper.apiPostWithToken(path: "user/store", body: body, callback: {
            (result:AddStoreResult?) in
            guard let result = result else {
                print("???");
                handler(AddStoreResult(status: 1, msg: "Unknow Error"));
                return;
            }
            handler(result);
        })
    }

    public static func getAllStore(handler: @escaping ([Store]) -> () ){
        ApiHelper.apiGet(path: "store", callback: {
            (result:[Store]?) in
            guard let result = result else {
                print("???");
                handler([Store]());
                return;
            }
            handler(result);
        })
    }

}
