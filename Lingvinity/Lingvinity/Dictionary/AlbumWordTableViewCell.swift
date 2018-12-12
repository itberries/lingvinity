//
//  AlbumWordTableViewCell.swift
//  Lingvinity
//
//  Created by Anastasia Puchnina on 12/12/2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import UIKit

class AlbumWordTableViewCell: UITableViewCell {

    @IBOutlet weak var wordImageView: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var translationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func fillCell(with model: AlbumModel) { // TODO: change to WordModel
        wordImageView.image = model.cover
        valueLabel.text = model.name
        translationLabel.text = model.name
    }
    
}
