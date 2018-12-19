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
    @IBOutlet weak var choosePhotoLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    let imageStorage = ImageStorageService()
    let predictionService = PredictionService()
    var dataBaseService : StorageService?
    
    typealias Word = (value: String, translatedValue: String, imageName: String, image: UIImage)
    
    var selectedWord : Word?
    var valyeAndTranslation: [(word: String, translation: String)] = []
    var selectedWordIndex : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataBaseService = StorageService.sharedInstance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        predictionService.loadModel()
    }
    
    @IBAction func openPhotoLibrary(_ sender: UIButton) {
        baseOpenFunction(target: .photoLibrary)
    }
    
    @IBAction func openCamera(_ sender: UIButton) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        baseOpenFunction(target: .camera)
    }
    
    func baseOpenFunction(target: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = target
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func saveToDictionary(_ sender: Any) {
        if (selectedWord != nil) {
            if let wordId = dataBaseService!.addValueToTableWords(wordValue: selectedWord!.value, wordDefinition: selectedWord!.translatedValue, image: selectedWord!.imageName) {
                // MARK: помещаем в альбом Все
                dataBaseService!.addValueToTableWordsToGroups(wordId: wordId, groupId: 1)
                imageStorage.save(image: selectedWord!.image, withName: selectedWord!.imageName)
                print("Saved word '\(selectedWord!.value)' to dictionary")
            } else {
                print("Can't save word '\(selectedWord!.value)' to dictionary")
            }
        }
    }
    
    @IBAction func leftButtonAction(_ sender: Any) {
        selectedWordIndex = selectedWordIndex - 1
        if selectedWordIndex <= 0 {
            selectedWordIndex = valyeAndTranslation.count
        }
        setResultWord(index: selectedWordIndex - 1)
    }
    
    @IBAction func rightButtonAction(_ sender: Any) {
        selectedWordIndex = (selectedWordIndex + 1) % (valyeAndTranslation.count)
        if selectedWordIndex == 0 {
            selectedWordIndex = 1
        }
        setResultWord(index: selectedWordIndex - 1)
    }
    
}

extension AddWordTabViewController : UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        DispatchQueue.main.async {
            self.recognitionResult.text = "Analyzing Image..."
        }
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        let predictionResult = predictionService.getTopPredictionResults(for: image)
        
        if let convertedImage = predictionResult?.convertedImage, let predictions = predictionResult?.predictions {
            
            var wordsValues = [String]()
            photoImageView.image = convertedImage
            
            choosePhotoLabel.isHidden = true
            saveButton.isHidden = false
            
            for (prediction, _) in zip(predictions, 1...5) {
                wordsValues += prediction.0.components(separatedBy: ", ")
            }
            translateWords(wordsArray: wordsValues, finished:  { translatedValues in
                self.valyeAndTranslation.removeAll()
                for (word, translation) in zip(wordsValues, translatedValues) {
                    self.valyeAndTranslation.append((word, translation))
                }
                DispatchQueue.main.async {
                    self.recognitionResult.text = self.valyeAndTranslation.first!.translation + " (" + self.valyeAndTranslation.first!.word + ")"
                    self.leftButton.isHidden = false
                    self.rightButton.isHidden = false
                }
                if let word = self.valyeAndTranslation.first {
                    let uuid = UUID().uuidString
                    // print("unique id for imageName: \(uuid)")
                    self.selectedWord = Word(value: word.word, translatedValue: word.translation, imageName: uuid, image: convertedImage)
                    self.selectedWordIndex = 1
                }
            })
        }
    }
    
    func setResultWord(index: Int) {
        let currentWord = valyeAndTranslation[index]
        selectedWord?.value = currentWord.word
        selectedWord?.translatedValue = currentWord.translation
        DispatchQueue.main.async {
            self.recognitionResult.text = currentWord.translation + " (" + currentWord.word + ")"
        }
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
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
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
