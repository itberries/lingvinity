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
    var words = [WordModel]()
    var selectedWord : WordModel?
    
    var databaseService : StorageService?
    
    let wordCellIdentifier = "AlbumWordTableViewCell"
    
    @IBOutlet weak var wordsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "\(album!.name ?? "")"
        
        databaseService = StorageService.sharedInstance
        
        words = databaseService!.findAllWordsByAlbumId(groupId: (self.album?.id)!) // TODO: change to getWords
        
        wordsTableView.dataSource = self
        wordsTableView.delegate = self
        
        wordsTableView.register(UINib.init(nibName: "AlbumWordTableViewCell", bundle: nil), forCellReuseIdentifier: wordCellIdentifier)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let wordDetailController = segue.destination as? WordDetailViewController else { return }
        wordDetailController.word = selectedWord
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWord = self.words[indexPath.row]
        performSegue(withIdentifier: "wordDetailSegue", sender: self)
    }
    
}


