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
    
    let databaseService = StorageService()
    let imageStorage = ImageStorageService()
    
    var albums = [AlbumModel]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        albums = databaseService.getAlbums()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib.init(nibName: "DictionaryAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: dictionaryAlbumCellIdentifier)
        collectionView.register(UINib.init(nibName: "CreateNewAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: createNewAlbumCellIdentifier)
    }
    
    func saveNewAlbumToAlbums(newAlbum album: AlbumModel) {
        self.albums.append(album)
        databaseService.addValueToTableGroups(groupValue: album.name!, groupCover: album.coverName)
        self.collectionView.reloadData()
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
        else {
             performSegue(withIdentifier: "albumDetailSegue", sender: self)
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
                self.saveNewAlbumToAlbums(newAlbum: AlbumModel(name: name, coverName: nil))
            }
        }))
        
        self.present(alert, animated: true)
    }
    
}
