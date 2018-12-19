//
//  TrainingTabViewController.swift
//  Lingvinity
//
//  Created by Ivan Nemshilov on 05/11/2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import UIKit
import SQLite

class TrainingTabViewController: UIViewController {
    @IBOutlet weak var value: UILabel!
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var word: UILabel!
    
    @IBOutlet weak var buttonYes: UIButton!
    
    @IBOutlet weak var buttonNo: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!

    //-----------------------
    var gameTimer = Timer()
    var seconds = 10;
    var isTimerRuninh = false;
    //------------------------
    var score : Int = 0
    var index : Int = 0
    
    @IBOutlet weak var scoreGame: UILabel!
    let storage = StorageModel()
    
    var dataBaseService : StorageService? //сервис для работы с базой данных
    
    func runTimer() {
        seconds = 10
        score = 0;
        timerLabel.text = "\(seconds)"
        scoreGame.text = String(score)
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TrainingTabViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    

    
    func stopTimer() {
        gameTimer.invalidate()
        print("stop timer!")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("tab training is disapearing")
        stopTimer()
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("tab training is appearing")
        word.text = storage.gameWordBatch[index].name
        value.text = storage.gameWordBatch[index].value
        result.text = "...."
        runTimer()
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Список всех записей из БД с названиями групп/названий альбомов
        dataBaseService = StorageService.sharedInstance
        dataBaseService!.listGroups()
    }
  
    @objc func updateTimer() {
        if seconds < 1 {
            gameTimer.invalidate()
            showAlert()
        } else {
            seconds -= 1
            timerLabel.text = "\(seconds)"
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Поздравляем!", message: "Ваш результат: \(score) ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            print("Yay! You clicked OK!")
            self.runTimer()
        }))
        self.present(alert, animated: true)
    }
    
    func setFunnySmile() {
        score = score + 1
        result.text = "٩(｡•́‿•̀｡)۶"
    }
    
    func setSadSmile() {
        score = score - 1
        result.text = "(︶︹︺)"
    }
    
    func nextStep() {
        scoreGame.text = String(score)
        index = (index + 1) % storage.gameWordBatch.count
        word.text = storage.gameWordBatch[index].name
        value.text = storage.gameWordBatch[index].value
    }
    
    
    @IBAction func buttonYesClick(_ sender: UIButton) {
        checkAnswer(answer: value.text!, correctAnswer: storage.correctWordBatch[word.text!]!, button: true);
    }
    
    @IBAction func buttonNoClick(_ sender: UIButton) {
        checkAnswer(answer: value.text!, correctAnswer: storage.correctWordBatch[word.text!]!, button: false);
    }
    
    func checkAnswer(answer: String, correctAnswer : String , button: Bool) {
        if(answer == correctAnswer){
            if(button == true){
                setFunnySmile()
            }else{
                setSadSmile()
            }
        }else{
            if(button == true){
                setSadSmile()
            }else{
                setFunnySmile()
            }
        }
        nextStep()
    }
    
}
