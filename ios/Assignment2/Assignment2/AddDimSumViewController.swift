//
//  AddDimSumViewController.swift
//  Assignment2
//
//  Created by YuTing Lai on 10/1/2022.
//

import UIKit

class AddDimSumViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tvInfo: UITextView!
    @IBOutlet weak var tvHist: UITextView!
    @IBOutlet weak var tvIngr: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tvTutor: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAddClick(_ sender: Any) {
        if(tfName.text! == "" || tvInfo.text! == "" || tvHist.text! == "" || tvIngr.text! == "" || tvTutor.text! == ""){
            showOkAlert(view: self, title: "Fail", msg: "Please enter all info", callback: nil);
            return;
        }
        addDimSum(name: tfName.text!,
                  info: tvInfo.text!,
                  history: tvHist.text!,
                  ingredients: tvIngr.text!,
                  tutorial: tvTutor.text!,
                  img: (imgView.image?.jpegData(compressionQuality: 0.8))!, handler: {
            result in
            if(result.status == 0){
                DispatchQueue.main.async{
                    showOkAlert(view: self, title: "Success", msg: result.msg, callback: {
                        self.dismiss(animated: true, completion: nil);
                    });
                }
            }else{
                DispatchQueue.main.async{
                    showOkAlert(view: self, title: "Fail", msg: result.msg, callback: nil);
                }
            }
        })
    }
    
    @IBAction func btnCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func btnSelectImageClick(_ sender: Any) {
        showImagePicker();
    }
    
    @IBAction func btnCamClick(_ sender: Any) {
        showCamera();
    }
    
    
    func showCamera(){
        let controller = UIImagePickerController();
        controller.delegate = self;
        controller.sourceType = .camera;
        present(controller, animated: true, completion: nil);
    }
    
    func showImagePicker(){
        let controller = UIImagePickerController();
        controller.delegate = self;
        controller.sourceType = .photoLibrary;
        present(controller, animated: true, completion: nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage;
        imgView.image = image;
        picker.dismiss(animated: true, completion: nil);
    }
    
}
