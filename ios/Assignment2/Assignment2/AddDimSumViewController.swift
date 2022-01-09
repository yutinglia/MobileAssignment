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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAddClick(_ sender: Any) {
        
    }
    
    @IBAction func btnCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func btnSelectImageClick(_ sender: Any) {
        showImagePicker();
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
