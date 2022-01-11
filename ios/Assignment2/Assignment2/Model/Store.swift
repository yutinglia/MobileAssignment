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
}

struct AddStoreResult: Codable{
    var status: Int;
    var msg: String;
}

func addStore(lat: Double,
              long: Double,
              name: String,
              intro: String,
              address: String,
              handler: @escaping (AddStoreResult) -> () ){
    let body = "lat=\(lat)&long=\(long)&name=\(name)&intro=\(intro)&address=\(address)";
    apiPostWithToken(apiName: "user/store", body: body, callback: {
        (result:AddStoreResult?) in
        guard let result = result else {
            print("???");
            handler(AddStoreResult(status: 1, msg: "Unknow Error"));
            return;
        }
        handler(result);
    })
}
