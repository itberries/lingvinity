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
            let album = AlbumModel()
            album.name = "Album name \(i)"
            album.numberOfWords = i
            album.cover = UIImage(named: "albumCover")
            albums.append(album)
        }
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
        print("Selected item \(indexPath.item + 1)")
    }
    
}
