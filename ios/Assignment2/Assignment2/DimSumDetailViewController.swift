//
//  DimSumDetailViewController.swift
//  Assignment2
//
//  Created by YuTing Lai on 11/1/2022.
//

import UIKit
import WebKit

class DimSumDetailViewController: UIViewController {
    
    var dimSim: DimSum? = nil;
    
    @IBOutlet weak var lblDimSum: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tvInfo: UITextView!
    @IBOutlet weak var tvHist: UITextView!
    @IBOutlet weak var tvIngr: UITextView!
    @IBOutlet weak var webkitView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let dimSim = dimSim else {
            print("gg");
            return;
        }
        lblDimSum.text = dimSim.name;
        tvInfo.text = dimSim.info;
        tvHist.text = dimSim.history;
        tvIngr.text = dimSim.ingredients;
        imgView.downloadDimSumImgFromBackend(name: "\(dimSim.name)_\(dimSim.uploader)");
        guard let url = URL(string: "https://www.youtube.com/embed/\(dimSim.tutorial)") else {
            print("not url");
            return;
        }
        let req = URLRequest(url: url);
        webkitView.load(req);
    }

}
