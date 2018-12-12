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
    
    let dataBaseService = StorageService()//сервис для работы с базой данных
    
    func runTimer() {
        seconds = 10;
        score = 0;
        scoreGame.text = String(score)
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TrainingTabViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    

    
    func stopTimer() {
        gameTimer.invalidate()
        print("stop timer!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        word.text = storage.gameWordBatch[index].name
        value.text = storage.gameWordBatch[index].value
        result.text = "...."
        //dataBaseService.addValueToTableWords(wordValue: "cat", wordDefinition: "кошка", image : "image.png")
        
        //Список всех записей из БД с названиями групп/названий альбомов
        dataBaseService.listGroups()
        
        //Список всех записей из БД с имеющимся словарем
        dataBaseService.listWords()
        
        //запуск таймера
        runTimer()
    }
  
    @objc func updateTimer() {
        if seconds < 1 {
            gameTimer.invalidate()
            //Send alert to indicate "time's up!"
            showAlert()
            //начинать игру заново?
            runTimer()
        } else {
            seconds -= 1   //This will decrement(count down)the seconds.
            timerLabel.text = "\(seconds)"
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Поздравляем!", message: "Ваш результат: \(score) ", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func buttonYesClick(_ sender: UIButton) {
        print(word.text!)
        print(storage.correctWordBatch[word.text!]!)
        if(value.text == storage.correctWordBatch[word.text!]!){
            score = score + 1
            result.text = "٩(｡•́‿•̀｡)۶"
        }else{
            score = score - 1
            result.text = "(︶︹︺)"
        }
        scoreGame.text = String(score)
        index = (index + 1) % storage.gameWordBatch.count
        word.text = storage.gameWordBatch[index].name
        value.text = storage.gameWordBatch[index].value
    }
    
    @IBAction func buttonNoClick(_ sender: UIButton) {
        if(value.text != storage.correctWordBatch[word.text!]!){
            score = score + 1
            result.text = "٩(｡•́‿•̀｡)۶"
        }else{
            score = score - 1
            result.text = "(︶︹︺)"
        }
        scoreGame.text! = String(score)
        index = (index + 1) % storage.gameWordBatch.count
        word.text = storage.gameWordBatch[index].name
        value.text = storage.gameWordBatch[index].value
    }
    
}
