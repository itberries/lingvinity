//
//  DictionaryAlbumCollectionViewCell.swift
//  Lingvinity
//
//  Created by Anastasia Puchnina on 21/11/2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import UIKit

class DictionaryAlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var numberOfWordsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.darkGray.cgColor
    }

}
