//
//  AccountViewController.swift
//  Assignment2
//
//  Created by YuTing Lai on 5/1/2022.
//

import UIKit

class AccountViewController: UIViewController {
    
    var account : String = "";
    var password : String = "";

    override func viewDidLoad() {
        super.viewDidLoad()
        getAndCheckAccessToken();
    }
    
    // login
    func getAndCheckAccessToken(){
        if let url = URL(string:"http://localhost:3000/api/auth"){
            var urlReq = URLRequest(url: url)
            urlReq.httpMethod = "POST";
            let body = "ac=\(account)&pwd=\(password)";
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
                let decoder = JSONDecoder();
                guard let result = try? decoder.decode(LoginInfo.self, from: resultData) else {
                    return;
                }
                if(result.token == "0"){
                    // login fail
                    let alert = UIAlertController(title: "Login Error", message: "Login Fail", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: {
                        _ in
                        self.navigationController?.popViewController(animated: true);
                    })
                    alert.addAction(alertAction);
                    self.present(alert, animated: true, completion: nil)
                }else{
                    // login ok
                    print(result);
                }
            });
            task.resume();
        }
    }
    
}
