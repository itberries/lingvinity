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
    
    var score : Int = 0
    var index : Int = 0
    
    @IBOutlet weak var scoreGame: UILabel!
    let storage = StorageModel()
    
    let dataBaseService = StorageService()//сервис для работы с базой данных
    
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
    }
  
    
    
    @IBAction func buttonYesClick(_ sender: UIButton) {
        print(word.text!)
        print(correctWordBatch[word.text!]!)
        if(value.text == correctWordBatch[word.text!]!){
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
        if(value.text != correctWordBatch[word.text!]!){
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
