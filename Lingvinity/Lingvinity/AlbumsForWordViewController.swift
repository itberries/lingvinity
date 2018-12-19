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
    
    @IBOutlet weak var albumsForWordTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select albums.."
        
        databaseService = StorageService.sharedInstance
        
        albums = databaseService!.getAlbums()
        selectedAlbums = databaseService!.findAllAlbumsByWordId(wordId: (self.word?.id)!)
        print(selectedAlbums)
        
        albumsForWordTableView.dataSource = self
        albumsForWordTableView.delegate = self
        albumsForWordTableView.allowsMultipleSelection = true
    }

}

extension AlbumsForWordViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = self.albums[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = album.name
        if self.selectedAlbums.first(where: { return $0.id ==  albums[indexPath.row].id } ) != nil {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        return cell
    }
    
}

extension AlbumsForWordViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedAlbums.first(where: { return $0.id ==  albums[indexPath.row].id } ) != nil {
            self.selectedAlbums.removeAll(where: { return $0.id ==  albums[indexPath.row].id })
        } else {
            self.selectedAlbums.append(albums[indexPath.row])
        }
    }
    
}


