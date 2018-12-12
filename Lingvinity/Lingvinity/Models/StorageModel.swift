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
        
        createArrayWithWords(tempArray: tempArray)
    }
    
    func createArrayWithWords(tempArray : [String]  ) {
        var i = 0;
        for batch in gameWordBatch1 {
            if(isPrime(i) == true){
                gameWordBatch += [(name: batch.name, value: tempArray[i])]
            }else{
                gameWordBatch += [(name: batch.name, value: batch.value)]
            }
            i = i + 1
        }
    }
    
    func isPrime(_ number: Int) -> Bool {
        return number > 1 && !(2..<number).contains { number % $0 == 0 }
    }
    
}
