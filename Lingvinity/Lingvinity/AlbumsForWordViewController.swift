//
//  AlbumsForWordViewController.swift
//  Lingvinity
//
//  Created by Anastasia Puchnina on 19/12/2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import Foundation
import UIKit

class AlbumsForWordViewController: UIViewController {
    
    var word : WordModel?
    var albums = [AlbumModel]()
    var selectedAlbums = [AlbumModel]()
    
    var databaseService : StorageService?
    
    let wordCellIdentifier = "AlbumWordTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select albums.."
        
        databaseService = StorageService.sharedInstance
        
        albums = databaseService!.findAllAlbumsByWordId(wordId: (self.word?.id)!)
        
        print(albums)
        
        //wordsTableView.dataSource = self
        //wordsTableView.delegate = self
        
        //wordsTableView.register(UINib.init(nibName: "AlbumWordTableViewCell", bundle: nil), forCellReuseIdentifier: wordCellIdentifier)
        
    }

}
