//
//  AddWordTabViewController.swift
//  Lingvinity
//
//  Created by Ivan Nemshilov on 24/10/2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import UIKit
import CoreML

class AddWordTabViewController :
    UIViewController,
    UINavigationControllerDelegate {
    
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var photoLibrary: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var recognitionResult: UILabel!
    
    let imageStorage = ImageStorageService()
    let predictionService = PredictionService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        predictionService.loadModel()
    }
    
    @IBAction func openPhotoLibrary(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func openCamera(_ sender: UIButton) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        
        present(picker, animated: true, completion: nil)
    }
    
}

extension AddWordTabViewController : UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        recognitionResult.text = "Analyzing Image..."
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        let predictionResult = predictionService.getTopPredictionResults(for: image)
        if let convertedImage = predictionResult?.convertedImage,
            let prediction = predictionResult?.predictions.first {
            photoImageView.image = convertedImage
            // TODO: добавить выбор одного слова для сохранения в словарь из топ 5
            recognitionResult.text = prediction.0
            imageStorage.save(image: convertedImage, withName: "1")
        }
    }
    
}
