//
//  AlbumModel.swift
//  Lingvinity
//
//  Created by Anastasia Puchnina on 21/11/2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import Foundation
import UIKit

class AlbumModel {
    var id: Int?
    var name: String?
    var numberOfWords: Int?
    var cover: UIImage?
    var coverName: String?
    
    init(name: String?, coverName: String? ) {
        self.name = name
        self.coverName = coverName
        self.numberOfWords = 0
        
        let imageStorage = ImageStorageService()
        if coverName != nil {
            if let cover = imageStorage.getImage(withName: coverName!) {
                self.cover = cover
            } else {
                print("Can't find album image cover with coverName \(coverName!)")
                self.cover = UIImage(named: "albumCover")
            }
        } else {
            self.cover = UIImage(named: "albumCover")
        }
    }
    
    convenience init(id: Int?, name: String?, coverName: String? ) {
        self.init(name: name, coverName: coverName)
        self.id = id
    }
}
