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
    
    var gameWordBatch:[(name: String, value: String)] = []
    var correctWordBatch = [String : String]()
    
    init()  {
        gameWordBatch = dataBaseService.listWords()
        for batch in gameWordBatch {
            correctWordBatch[batch.name] = batch.value
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
