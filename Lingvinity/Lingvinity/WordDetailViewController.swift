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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Word"
        
        if self.word != nil {
            self.wordValueLabel.text = word!.value
            self.translationValueLabel.text = word!.translation
            self.imageView.image = word!.image
        }
        
    }
    @IBAction func addWordToAlbums(_ sender: Any) {
        performSegue(withIdentifier: "albumsForWordSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let albumsForWordController = segue.destination as? AlbumsForWordViewController else { return }
        albumsForWordController.word = word
    }
}
