//
//  StorageModel.swift
//  Lingvinity
//
//  Created by Elena Oshkina on 20.11.2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import UIKit

class StorageModel{

    
    let dataBaseService = StorageService()//сервис для работы с базой данных
    
    var gameWordBatch1:[(name: String, value: String)] = []
    var gameWordBatch:[(name: String, value: String)] = [] //с перемешенными словами
    var correctWordBatch = [String : String]()
    
    init()  {
        gameWordBatch1 = dataBaseService.listWords()
        var  tempArray = [String] ()
        for batch in gameWordBatch1 {
            correctWordBatch[batch.name] = batch.value
            tempArray.append(batch.value)
        }
        
        tempArray.shuffle()
        var i = 0;
        for batch in gameWordBatch1 {
            gameWordBatch += [(name: batch.name, value: tempArray[i])]
            i = i + 1
        }
        
        
        
//        //необходимо заполнить массив из базы данных словами
//        gameWordBatch += [(name: "dog", value: "собака")]
//        gameWordBatch += [(name: "sky", value: "небо")]
//        gameWordBatch += [(name: "key", value: "собака")]
//        gameWordBatch += [(name: "mother", value: "мама")]
//        gameWordBatch += [(name: "wednesday", value: "среда")]
        
        //необходимо сформировать массив с корректными ответами
        
        
        //перемешать в словаре значения и перевод
        
    }
    
    
}

//var correctWordBatch = ["dog": "собака",
//                        "sky": "небо",
//                        "key": "ключ",
//                        "mother": "мама",
//                        "wednesday": "среда"]
