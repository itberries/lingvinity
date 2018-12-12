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
    let dataBaseService = StorageService()
    
    typealias Word = (value: String, translatedValue: String, imageName: String, image: UIImage)
    
    var selectedWord : Word?
    var valyeAndTranslation: [(word: String, translation: String)] = []
    var selectedWordIndex : Int = 0
    
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
    
    @IBAction func saveToDictionary(_ sender: Any) {
        if (selectedWord != nil) {
            if let wordId = dataBaseService.addValueToTableWords(wordValue: selectedWord!.value, wordDefinition: selectedWord!.translatedValue, image: selectedWord!.imageName) {
                // MARK: помещаем в альбом Все
                dataBaseService.addValueToTableWordsToGroups(wordId: wordId, groupId: 1)
                imageStorage.save(image: selectedWord!.image, withName: selectedWord!.imageName)
                print("Saved word '\(selectedWord!.value)' to dictionary")
            } else {
                print("Can't save word '\(selectedWord!.value)' to dictionary")
            }
        }
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
        if let convertedImage = predictionResult?.convertedImage, let predictions = predictionResult?.predictions {
            
            var wordsValues = [String]()
            photoImageView.image = convertedImage
            for (prediction, _) in zip(predictions, 1...5) {
                wordsValues += prediction.0.components(separatedBy: ", ")
            }
            translateWords(wordsArray: wordsValues, finished:  { translatedValues in
                for (word, translation) in zip(wordsValues, translatedValues) {
                    self.valyeAndTranslation.append((word, translation))
                }
                DispatchQueue.main.async {
                    self.recognitionResult.lineBreakMode = .byWordWrapping
                    self.recognitionResult.numberOfLines = 0
                    self.recognitionResult.text = self.valyeAndTranslation.first!.translation + " (" + self.valyeAndTranslation.first!.word + ")"
                    self.recognitionResult.sizeToFit()
                    
                    let switchHight = 600
                    
                    self.addSwitchButton(xPos: 50, yPos: switchHight, text: "Left", buttonFunc: #selector(self.leftButtonAction))
                    self.addSwitchButton(xPos: Int(UIScreen.main.bounds.width - 150)  , yPos: switchHight, text: "Right", buttonFunc: #selector(self.rightButtonAction))
                }
                // TODO: добавить выбор одного слова для сохранения в словарь из топ 5
                // MARK: recognitionResult.text здесь - это выбранное пользователем слово
                if let word = self.valyeAndTranslation.first {
                    self.selectedWord = Word(value: word.word, translatedValue: word.translation, imageName: "1", image: convertedImage)
                }
            })
        }

    }
    
    func addSwitchButton(xPos: Int, yPos: Int, text: String, buttonFunc: Selector) {
        
        let button = UIButton(frame: CGRect(x: xPos, y: yPos, width: 100, height: 50))
        button.backgroundColor = .purple
        button.setTitle(text, for: .normal)
        button.addTarget(self, action: buttonFunc, for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    
    func setResultWord(index: Int) {
        let currentWord = valyeAndTranslation[index]
        selectedWord?.value = currentWord.word
        selectedWord?.translatedValue = currentWord.translation
        self.recognitionResult.text = currentWord.translation + " (" + currentWord.word + ")"
    }
        
    @objc func rightButtonAction(sender: UIButton!) {
        selectedWordIndex = (selectedWordIndex + 1) % (valyeAndTranslation.count - 1)
        setResultWord(index: selectedWordIndex)
    }
    
    @objc func leftButtonAction(sender: UIButton!) {
        selectedWordIndex = (selectedWordIndex + 1) % (valyeAndTranslation.count - 1)
        if selectedWordIndex < 0 {
            selectedWordIndex = valyeAndTranslation.count
        }
        setResultWord(index: selectedWordIndex)
    }
    
    func convertImageFormat(for image: UIImage) -> (newImage: UIImage, pixelBuffer: CVPixelBuffer)? {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        photoImageView.image = newImage
        
        return (newImage, pixelBuffer!)
	
    }
    
    func translateWords(wordsArray: [String], finished: @escaping (([String]) -> Void)) {
        let url = URL(string: "https://translate.yandex.net/api/v1.5/tr.json/translate?lang=ru&key=trnsl.1.1.20181205T100748Z.63ceec24b0413b7b.3da3dd7fc83a0cdcbb8bd4ae6a4d733316e054a9&")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        var postString = ""
        for word in wordsArray {
            postString += "&text=\(word)"
        }
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let response = json as! NSDictionary
                let text = response["text"] as! [String]
                var translatedValues = [String]()
                for value in text {
                    translatedValues.append(value)
                }
                finished(translatedValues)
            } catch {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
}
