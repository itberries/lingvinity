//
//  WordModel.swift
//  Lingvinity
//
//  Created by Anastasia Puchnina on 12/12/2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import Foundation
import UIKit

class WordModel {
    var id : Int?
    var value : String?
    var translation : String?
    var image : UIImage?
    var imageName : String?
    
    init(id: Int?, value: String?, translation: String?, imageName: String?) {
        self.id = id
        self.value = value
        self.translation = translation
        self.imageName = imageName
        
        let imageStorage = ImageStorageService()
        if imageName != nil {
            if let image = imageStorage.getImage(withName: imageName!) {
                self.image = image
            } else {
                print("Can't find word image with imageName \(imageName!)")
                self.image = UIImage(named: "albumCover")
            }
        } else {
            self.image = UIImage(named: "albumCover")
        }
    }
}
