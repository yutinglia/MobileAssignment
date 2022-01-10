//
//  ApiHelper.swift
//  Assignment2
//
//  Created by YuTing Lai on 7/1/2022.
//

import Foundation

// get req and pass backend result
func apiGet<T: Decodable>(path: String, callback cb: @escaping (T?)->()){
    let str = "\(BACKEND_SERVER_URL)/api/\(path)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
    if let url = URL(string: str!){
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "GET";
        let task = URLSession.shared.dataTask(with: urlReq, completionHandler: {
            resultData, res, err in
            guard let resultData = resultData else{
                print("not result");
                return;
            }
            if let err = err {
                print(err);
            }
            // decode json
            let decoder = JSONDecoder();
            guard let result = try? decoder.decode(T.self, from: resultData) else {
                print("decode fail");
                return;
            }
            // pass result
            // print("decode \(String(data: resultData, encoding: .utf8) ?? "wtf")");
            cb(result);
        });
        task.resume();
    }
} // end apiPost

// post req and pass backend result
func apiPost<T: Decodable>(apiName: String, body bodyStr: String, callback cb: @escaping (T?)->()){
    let str = "\(BACKEND_SERVER_URL)/api/\(apiName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
    if let url = URL(string: str!){
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

// get req with token and pass backend result
func apiGetWithToken<T: Decodable>(path: String, callback cb: @escaping (T?)->()){
    let str = "\(BACKEND_SERVER_URL)/api/\(path)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
    if let url = URL(string: str!){
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "GET";
        // set token to header
        let keychain = KeychainHelper();
        let token = keychain.retrieveAccessToken();
        guard let token = token else {
            print("unauth");
            return;
        }
        urlReq.setValue(token, forHTTPHeaderField: "Authorization");
        let task = URLSession.shared.dataTask(with: urlReq, completionHandler: {
            resultData, res, err in
            guard let resultData = resultData else{
                print("no result");
                return;
            }
            if let err = err {
                print(err);
            }
            // decode json
            let decoder = JSONDecoder();
            guard let result = try? decoder.decode(T.self, from: resultData) else {
                print("decode fail \(String(data: resultData, encoding: .utf8) ?? "wtf")");
                return;
            }
            // pass result
            cb(result);
        });
        task.resume();
    }
} // end apiPostWithToken

// req with token and pass backend result
func apiBodyReqWithToken<T: Decodable>(apiName: String, method: String, body bodyStr: String, callback cb: @escaping (T?)->()){
    let str = "\(BACKEND_SERVER_URL)/api/\(apiName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
    if let url = URL(string: str!){
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = method;
        let body = bodyStr;
        guard let data = body.data(using: .utf8) else {
            return;
        }
        // set token to header
        let keychain = KeychainHelper();
        let token = keychain.retrieveAccessToken();
        guard let token = token else {
            print("unauth");
            return;
        }
        urlReq.setValue(token, forHTTPHeaderField: "Authorization");
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
} // end apiPostWithToken

// post req with token and pass backend result
func apiPostWithToken<T: Decodable>(apiName: String, body bodyStr: String, callback cb: @escaping (T?)->()){
    apiBodyReqWithToken(apiName: apiName, method: "POST", body: bodyStr, callback: cb);
} // end apiPostWithToken

// post req with token and pass backend result
func apiPutWithToken<T: Decodable>(apiName: String, body bodyStr: String, callback cb: @escaping (T?)->()){
    apiBodyReqWithToken(apiName: apiName, method: "PUT", body: bodyStr, callback: cb);
} // end apiPostWithToken

// post multipard/form-data req with token and pass backend result
func apiPostFormDataWithToken<T: Decodable>(apiName: String, parameters: [String: String], data: [String: Data], callback cb: @escaping (T?)->()){
    let str = "\(BACKEND_SERVER_URL)/api/\(apiName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
    if let url = URL(string: str!){
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "POST";
        let boundary = "Boundary+\(arc4random())\(arc4random())";
        var body = Data();
        
        // make form data
        urlReq.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type");
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n");
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n");
            body.appendString(string: "\(value)\r\n");
        }
        
        for (key, value) in data {
            body.appendString(string: "--\(boundary)\r\n");
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(arc4random())\"\r\n");
            body.appendString(string: "Content-Type: image/jpeg\r\n\r\n");
            body.append(value);
            body.appendString(string: "\r\n");
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        // set token to header
        let keychain = KeychainHelper();
        let token = keychain.retrieveAccessToken();
        guard let token = token else {
            print("unauth");
            return;
        }
        urlReq.setValue(token, forHTTPHeaderField: "Authorization");
        let task = URLSession.shared.uploadTask(with: urlReq, from: body, completionHandler: {
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
} // end apiPostFormDataWithToken

// get req and pass backend result
func apiGetData(path: String, callback cb: @escaping (Data)->()){
    let str = "\(BACKEND_SERVER_URL)/api/\(path)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
    if let url = URL(string: str!){
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
            // pass result
            cb(resultData);
        });
        task.resume();
    }
} // end apiPost
