//
//  ApiHelper.swift
//  Assignment2
//
//  Created by YuTing Lai on 7/1/2022.
//

import Foundation

class ApiHelper{
    
    private static func makeURL(path: String) -> URL{
        // addingPercentEncoding for chinese url
        let str = "\(Configs.BACKEND_SERVER_URL)/api/\(path)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
        if let url = URL(string: str!){
            return url;
        }else{
            print("make url fail");
            return URL(string: "")!;
        }
    }
    
    // try to decode server result to struct
    private static func apiResultHandler<T: Decodable>(_ resultData: Data?, _ res: URLResponse?, _ err: Error?, _ cb: @escaping (T?) -> () ){
        
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
    }

    // get req and pass backend result
    public static func apiGet<T: Decodable>(path: String, callback cb: @escaping (T?)->()){
        
        var urlReq = URLRequest(url: makeURL(path: path));
        urlReq.httpMethod = "GET";
        let task = URLSession.shared.dataTask(with: urlReq, completionHandler: {
            resultData, res, err in
            apiResultHandler(resultData, res, err, cb);
        });
        task.resume();
    } // end apiPost

    // post req and pass backend result
    public static func apiPost<T: Decodable>(path: String, body bodyStr: String, callback cb: @escaping (T?)->()){
        
        var urlReq = URLRequest(url: makeURL(path: path))
        urlReq.httpMethod = "POST";
        let body = bodyStr;
        guard let data = body.data(using: .utf8) else {
            return;
        }
        let task = URLSession.shared.uploadTask(with: urlReq, from: data, completionHandler: {
            resultData, res, err in
            apiResultHandler(resultData, res, err, cb);
        });
        task.resume();
    } // end apiPost

    // get req with token and pass backend result
    public static func apiGetWithToken<T: Decodable>(path: String, callback cb: @escaping (T?)->()){
        
        var urlReq = URLRequest(url: makeURL(path: path))
        urlReq.httpMethod = "GET";
        // set token to header
        let token = KeychainHelper.retrieveAccessToken();
        guard let token = token else {
            print("unauth");
            return;
        }
        urlReq.setValue(token, forHTTPHeaderField: "Authorization");
        let task = URLSession.shared.dataTask(with: urlReq, completionHandler: {
            resultData, res, err in
            apiResultHandler(resultData, res, err, cb);
        });
        task.resume();
    } // end apiPostWithToken

    // req with body, token and pass backend result
    private static func apiBodyReqWithToken<T: Decodable>(
        path: String,
        method: String,
        type: String = "application/x-www-form-urlencoded",
        body bodyStr: String,
        callback cb: @escaping (T?)->() ){
            
        var urlReq = URLRequest(url: makeURL(path: path))
        urlReq.httpMethod = method;
        let body = bodyStr;
        guard let data = body.data(using: .utf8) else {
            return;
        }
        // set token to header
        let token = KeychainHelper.retrieveAccessToken();
        guard let token = token else {
            print("unauth");
            return;
        }
        urlReq.setValue(token, forHTTPHeaderField: "Authorization");
        urlReq.setValue(type, forHTTPHeaderField: "Content-Type");
        let task = URLSession.shared.uploadTask(with: urlReq, from: data, completionHandler: {
            resultData, res, err in
            apiResultHandler(resultData, res, err, cb);
        });
        task.resume();
    } // end apiPostWithToken

    // post req with token and pass backend result
    public static func apiPostWithToken<T: Decodable>(
        path: String,
        body bodyStr: String,
        callback cb: @escaping (T?)->() ){
            
        apiBodyReqWithToken(path: path, method: "POST", body: bodyStr, callback: cb);
    } // end apiPostWithToken

    // post req with token and pass backend result
    public static func apiPutWithToken<T: Decodable>(
        path: String,
        body bodyStr: String,
        callback cb: @escaping (T?)->()){
            
        apiBodyReqWithToken(path: path, method: "PUT", body: bodyStr, callback: cb);
    } // end apiPostWithToken

    // post multipard/form-data req with token and pass backend result
    public static func apiPostFormDataWithToken<T: Decodable>(
        path: String,
        parameters: [String: String],
        data: [String: Data],
        callback cb: @escaping (T?)->()){
            
        var urlReq = URLRequest(url: makeURL(path: path))
        urlReq.httpMethod = "POST";
        let boundary = "Boundary+\(arc4random())\(arc4random())";
        var body = Data();
        
        // make form data
        urlReq.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type");
        
        // add all para in body
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n");
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n");
            body.appendString(string: "\(value)\r\n");
        }
        
        // add all data in body
        for (key, value) in data {
            body.appendString(string: "--\(boundary)\r\n");
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(arc4random())\"\r\n");
            body.appendString(string: "Content-Type: image/jpeg\r\n\r\n");
            body.append(value);
            body.appendString(string: "\r\n");
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        // set token to header
        let token = KeychainHelper.retrieveAccessToken();
        guard let token = token else {
            print("unauth");
            return;
        }
        urlReq.setValue(token, forHTTPHeaderField: "Authorization");
        // send req
        let task = URLSession.shared.uploadTask(with: urlReq, from: body, completionHandler: {
            resultData, res, err in
            apiResultHandler(resultData, res, err, cb);
        });
        task.resume();
    } // end apiPostFormDataWithToken

    // get req and pass backend result without decode ( for download image )
    public static func apiGetData(path: String, callback cb: @escaping (Data)->()){
        var urlReq = URLRequest(url: makeURL(path: path))
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
    } // end apiPost

}
