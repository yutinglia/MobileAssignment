//
//  AlertHelper.swift
//  Assignment2
//
//  Created by YuTing Lai on 7/1/2022.
//

import Foundation
import UIKit

class AlertHelper{
    public static func showOkAlert(view: UIViewController, title: String, msg: String, onOkClick cb: (() -> Void)?){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        if let cb = cb{
            let alertAction = UIAlertAction(title: "OK", style: .default, handler:{
                _ in
                cb();
            })
            alert.addAction(alertAction);
        }else{
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil);
            alert.addAction(alertAction);
            // view.navigationController?.popViewController(animated: true);
        }
        view.present(alert, animated: true, completion: nil);
    }
}
