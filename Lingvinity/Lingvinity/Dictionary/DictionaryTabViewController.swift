//
//  DictionaryTabViewController.swift
//  Lingvinity
//
//  Created by Anastasia Puchnina on 21/11/2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import UIKit

class DictionaryTabViewController: UIViewController {

    let dictionaryAlbumCellIdentifier = "dictionaryAlbumCollectionViewCell"
    let createNewAlbumCellIdentifier = "createNewAlbumCollectionViewCell"
    
    var albums = [AlbumModel]()
    let imageStorage = ImageStorageService()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fillAlbums()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib.init(nibName: "DictionaryAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: dictionaryAlbumCellIdentifier)
        collectionView.register(UINib.init(nibName: "CreateNewAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: createNewAlbumCellIdentifier)
    }

    func fillAlbums() {
        for i in 1...3 {
            let album = createNewAlbum(withName: "Album name \(i)", withWords: i)
            albums.append(album)
        }
    }
    
    func createNewAlbum(withName name: String, withWords words: Int) -> AlbumModel {
        let album = AlbumModel()
        album.name = name
        album.numberOfWords = words
        if let cover = imageStorage.getImage(withName: "1") {
            album.cover = cover
        } else {
            album.cover = UIImage(named: "albumCover")
        }
        return album
    }
    
}

extension DictionaryTabViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count + 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row != (albums.count)) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dictionaryAlbumCellIdentifier, for: indexPath) as! DictionaryAlbumCollectionViewCell
            let album = albums[indexPath.row]
            cell.albumNameLabel.text = album.name
            cell.numberOfWordsLabel.text = "\(String(describing: album.numberOfWords!)) words"
            cell.albumCover.image = album.cover
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: createNewAlbumCellIdentifier, for: indexPath) as! CreateNewAlbumCollectionViewCell
            return cell
        }
    }
    
}

extension DictionaryTabViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected item \(indexPath.item)")
        
        if (indexPath.row == albums.count) {
            showCreateNewAlbumPopUp();
        }
        
    }
    
    func showCreateNewAlbumPopUp() {
        
        let alert = UIAlertController(title: "Create new album", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input album name here..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                let newAlbum = self.createNewAlbum(withName: name, withWords: 0)
                self.albums.append(newAlbum)
                self.collectionView.reloadData()
            }
        }))
        
        self.present(alert, animated: true)
    }
    
}
