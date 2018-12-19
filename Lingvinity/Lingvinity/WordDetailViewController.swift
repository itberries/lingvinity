//
//  WordDetailViewController.swift
//  Lingvinity
//
//  Created by Anastasia Puchnina on 19/12/2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import Foundation
import UIKit

class WordDetailViewController: UIViewController {
    
    var word : WordModel?
    
    @IBOutlet weak var wordValueLabel: UILabel!
    @IBOutlet weak var translationValueLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let databaseService = StorageService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Word"
        
        if self.word != nil {
            self.wordValueLabel.text = word!.value
            self.translationValueLabel.text = word!.translation
            self.imageView.image = word!.image
        }
        
    }
}
