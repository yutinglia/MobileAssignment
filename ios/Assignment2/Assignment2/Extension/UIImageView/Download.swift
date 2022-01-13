//
//  Download.swift
//  Assignment2
//
//  Created by YuTing Lai on 11/1/2022.
//

import Foundation
import UIKit

extension UIImageView{
    func downloadDimSumImgFromBackend(name: String, handler: @escaping () -> () = {} ){
        apiGetData(path: "dimsum/\(name)/img", callback: {
            data in
            guard let image = UIImage(data: data) else { return; }
            DispatchQueue.main.async {
                [weak self] in
                self?.image = image;
                handler();
            }
        });
    }
}
