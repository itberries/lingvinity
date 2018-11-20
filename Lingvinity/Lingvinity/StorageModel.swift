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
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

//var gameWordBatch = ["dog": "собака",
//                     "cat": "слоник",
//                     "table": "стол",
//                     "laptop": "принтер"]




var correctWordBatch = ["dog": "собака",
                        "sky": "небо",
                        "key": "ключ",
                        "mother": "мама"]
