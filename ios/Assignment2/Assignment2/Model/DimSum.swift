//
//  DimSumContact.swift
//  Assignment2
//
//  Created by YuTing Lai on 4/1/2022.
//

import Foundation

struct DimSum : Codable{
    var name: String;
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
