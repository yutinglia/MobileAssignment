//
//  DimSumContact.swift
//  Assignment2
//
//  Created by YuTing Lai on 4/1/2022.
//

import Foundation

struct DimSum : Codable{
    var name: String;
    var info: String;
    var history: String;
    var ingredients: String;
    var uploader: String;
    var tutorial: String;
}

struct AddDimSumResult: Codable{
    var status: Int;
    var msg: String;
}

func getAllDimSum(handler: @escaping ([DimSum]) -> () ){
    apiGet(path: "dimsum", callback: {
        (result:[DimSum]?) in
        guard let result = result else {
            print("???");
            handler([DimSum]());
            return;
        }
        handler(result);
    })
}

func addDimSum(name: String,
               info:String,
               history:String,
               ingredients:String,
               tutorial: String,
               img: Data,
               handler: @escaping (AddDimSumResult) -> () ){
    apiPostFormDataWithToken(apiName: "user/dimsum",
                             parameters: ["name":name,
                                          "info":info,
                                          "history":history,
                                          "tutorial":tutorial,
                                          "ingredients":ingredients],
                             data: ["img": img],
                             callback: {
        (result:AddDimSumResult?) in
        guard let result = result else {
            print("???");
            handler(AddDimSumResult(status: 1, msg: "Unknow Error"));
            return;
        }
        handler(result);
    })
}
