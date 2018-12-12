//
//  AlbumDetailViewController.swift
//  Lingvinity
//
//  Created by Anastasia Puchnina on 12/12/2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import Foundation
import UIKit

class AlbumDetailViewController: UIViewController {
    
    var album : AlbumModel?
    var words = [AlbumModel]() // TODO: change to WordModel
    
    let databaseService = StorageService()
    
    let wordCellIdentifier = "AlbumWordTableViewCell"
    
    @IBOutlet weak var wordsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(album!.name ?? "")"
        
        words = databaseService.getAlbums() // TODO: change to getWords
        
        wordsTableView.dataSource = self
        wordsTableView.delegate = self
        
        wordsTableView.register(UINib.init(nibName: "AlbumWordTableViewCell", bundle: nil), forCellReuseIdentifier: wordCellIdentifier)
        
    }
    
}

extension AlbumDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let word = self.words[indexPath.row]
        let cell = wordsTableView.dequeueReusableCell(withIdentifier: self.wordCellIdentifier, for: indexPath)
        if let castedCell = cell as? AlbumWordTableViewCell {
            castedCell.fillCell(with: word)
        }
        return cell
    }
    
    
}

extension AlbumDetailViewController : UITableViewDelegate {
    
}


