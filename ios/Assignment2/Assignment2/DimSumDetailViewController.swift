//
//  DimSumDetailViewController.swift
//  Assignment2
//
//  Created by YuTing Lai on 11/1/2022.
//

import UIKit
import WebKit
import AVFoundation

class DimSumDetailViewController: UIViewController {
    
    var dimSum: DimSum? = nil;
    
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
        guard let dimSum = dimSum else {
            print("no dim sum obj");
            return;
        }
        lblDimSum.text = dimSum.name;
        tvInfo.text = dimSum.info;
        tvHist.text = dimSum.history;
        tvIngr.text = dimSum.ingredients;
        imgView.downloadDimSumImgFromBackend(name: "\(dimSum.name)_\(dimSum.uploader)");
        guard let url = URL(string: "https://www.youtube.com/embed/\(dimSum.tutorial)") else {
            print("not url");
            return;
        }
        let req = URLRequest(url: url);
        webkitView.load(req);
    }
    
    // text to speak
    func speak(_ string: String, language: String = "en-US"){
        let utterance = AVSpeechUtterance(string: string);
        utterance.voice = AVSpeechSynthesisVoice(language: language);
        utterance.rate = 0.5;
        let synthesizer = AVSpeechSynthesizer();
        synthesizer.speak(utterance);
    }
    
    @IBAction func btnInfoSpeakClick(_ sender: Any) {
        speak(tvInfo.text!);
    }
    
    @IBAction func btnHistSpeakClick(_ sender: Any) {
        speak(tvHist.text!);
    }

}
