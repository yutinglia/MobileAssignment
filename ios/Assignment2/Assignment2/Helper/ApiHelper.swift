//
//  ApiHelper.swift
//  Assignment2
//
//  Created by YuTing Lai on 7/1/2022.
//

import Foundation

// get req and pass backend result
func apiGet<T: Decodable>(path: String, callback cb: @escaping (T?)->()){
    if let url = URL(string:"\(BACKEND_SERVER_URL)/api/\(path)"){
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "GET";
        let task = URLSession.shared.dataTask(with: urlReq, completionHandler: {
            resultData, res, err in
            guard let resultData = resultData else{
                return;
            }
            if let err = err {
                print(err);
            }
            // decode json
            let decoder = JSONDecoder();
            guard let result = try? decoder.decode(T.self, from: resultData) else {
                return;
            }
            // pass result
            cb(result);
        });
        task.resume();
    }
} // end apiPost



// post req and pass backend result
func apiPost<T: Decodable>(apiName: String, body bodyStr: String, callback cb: @escaping (T?)->()){
    if let url = URL(string:"\(BACKEND_SERVER_URL)/api/\(apiName)"){
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "POST";
        let body = bodyStr;
        guard let data = body.data(using: .utf8) else {
            return;
        }
        let task = URLSession.shared.uploadTask(with: urlReq, from: data, completionHandler: {
            resultData, res, err in
            guard let resultData = resultData else{
                return;
            }
            if let err = err {
                print(err);
            }
            // decode json
            let decoder = JSONDecoder();
            guard let result = try? decoder.decode(T.self, from: resultData) else {
                return;
            }
            // pass result
            cb(result);
        });
        task.resume();
    }
} // end apiPost


