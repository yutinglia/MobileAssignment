//
//  AppendString.swift
//  Assignment2
//
//  Created by YuTing Lai on 10/1/2022.
//

import Foundation

extension Data{
    mutating func appendString(string: String){
        let data = string.data(using: .utf8, allowLossyConversion: true);
        append(data!);
    }
}
