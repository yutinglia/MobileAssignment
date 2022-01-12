//
//  DimSumTableViewController.swift
//  Assignment2
//
//  Created by YuTing Lai on 4/1/2022.
//

import UIKit
import Speech

class DimSumTableViewController: UITableViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnSpeak: UIBarButtonItem!
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "zh_Hant_HK"));
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?;
    var recognitionTask: SFSpeechRecognitionTask?;
    let audioEngine = AVAudioEngine();
    
    var dimSums = [DimSum]();
    var filteredDimSums = [DimSum]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.refreshControl?.addTarget(self, action: #selector(self.refreshData(_:)), for: .valueChanged);
        refreshData(self);
        // listen textfield change
        tfSearch.addTarget(self, action: #selector(tfSearchDidChange(_:)), for: .editingChanged);
    }
    
    func initSpeak(){
        btnSpeak.isEnabled = false;
        speechRecognizer?.delegate = self;
        SFSpeechRecognizer.requestAuthorization({
            authStatus in
            if(authStatus == .authorized){
                DispatchQueue.main.async {
                    self.btnSpeak.isEnabled = true;
                }
            }
        })
    }
    
    @objc func refreshData(_ sender: AnyObject){
        getAllDimSum(handler: dimSumsHandler);
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDimSums.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DimSumCell", for: indexPath);
        let dimSum = self.filteredDimSums[indexPath.row];
        var cellContent = cell.defaultContentConfiguration();
        cellContent.text = dimSum.name;
        cell.contentConfiguration = cellContent;
        return cell;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let des = segue.destination as? DimSumDetailViewController {
            guard let index = self.tableView.indexPathForSelectedRow else{
                return;
            }
            des.dimSim = filteredDimSums[index.row];
        }
    }
    
    func dimSumsHandler(dimSims:[DimSum]){
        DispatchQueue.main.async {
            self.tfSearch.text = "";
            self.dimSums = dimSims;
            self.filteredDimSums = dimSims;
            self.tableView.reloadData();
            self.tableView.refreshControl?.endRefreshing();
        };
    }
    
    @objc func tfSearchDidChange(_ tf: UITextField){
        filteredDimSums = tfSearch.text == "" ? dimSums : dimSums.filter({
            dimSum in
            return dimSum.name.range(of: tfSearch.text!) != nil;
        })
        self.tableView.reloadData();
    }
    
    @IBAction func btnSpeakClick(_ sender: Any) {
        if(audioEngine.isRunning){
            audioEngine.stop();
            recognitionRequest?.endAudio();
            btnSpeak.title = "Speech to text";
            if(tfSearch.text == "Listening..."){
                tfSearch.text = "";
            }
            let audioSession = AVAudioSession.sharedInstance();
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback);
                try audioSession.setActive(false, options: .notifyOthersOnDeactivation);
            } catch {
                print("audio session error");
            }
        }else{
            startRecording();
            btnSpeak.title = "Stop";
        }
    }
    
    func startRecording(){
        if(recognitionTask != nil){
            recognitionTask?.cancel();
            recognitionTask = nil;
        }
        
        let audioSession = AVAudioSession.sharedInstance();
        do {
            try audioSession.setCategory(AVAudioSession.Category.record);
            try audioSession.setMode(AVAudioSession.Mode.measurement);
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation);
        } catch {
            print("audio error");
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest();
        
        let inputNode = audioEngine.inputNode;
        
        guard let recognitionRequest = recognitionRequest else {
            print("audio engine error");
            return
        }

        recognitionRequest.shouldReportPartialResults = true;
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: {
            (res, err) in
            var isFinal = false;
            
            if(res != nil){
                self.tfSearch.text = res?.bestTranscription.formattedString;
                self.tfSearchDidChange(self.tfSearch);
                isFinal = (res?.isFinal)!;
            }
            
            if(err != nil || isFinal){
                self.audioEngine.stop();
                inputNode.removeTap(onBus: 0);
                
                self.recognitionRequest = nil;
                self.recognitionTask = nil;
                
                self.btnSpeak.isEnabled = true;
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0);
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: {
            (buf, when) in
            self.recognitionRequest?.append(buf);
        })
        
        audioEngine.prepare();
        
        do{
            try audioEngine.start();
        }catch{
            print("audio engine error 2");
        }
        
        tfSearch.text = "Listening...";
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if(available){
            btnSpeak.isEnabled = true;
        }else{
            btnSpeak.isEnabled = false;
        }
    }
    
    
}
