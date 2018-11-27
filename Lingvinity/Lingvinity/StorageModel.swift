//
//  StorageModel.swift
//  Lingvinity
//
//  Created by Elena Oshkina on 20.11.2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import UIKit

class StorageModel{

    var gameWordBatch:[(name: String, value: String)] = []
    
    init()  {
        gameWordBatch += [(name: "dog", value: "собака")]
        gameWordBatch += [(name: "sky", value: "небо")]
        gameWordBatch += [(name: "key", value: "собака")]
        gameWordBatch += [(name: "mother", value: "мама")]
        gameWordBatch += [(name: "wednesday", value: "среда")]
    }
    
}

var correctWordBatch = ["dog": "собака",
                        "sky": "небо",
                        "key": "ключ",
                        "mother": "мама",
                        "wednesday": "среда"]
