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
    let numberOfAlbums = 3
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib.init(nibName: "DictionaryAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: dictionaryAlbumCellIdentifier)
        collectionView.register(UINib.init(nibName: "CreateNewAlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: createNewAlbumCellIdentifier)
    }

}

extension DictionaryTabViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfAlbums + 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row != (numberOfAlbums)) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dictionaryAlbumCellIdentifier, for: indexPath) as! DictionaryAlbumCollectionViewCell
            cell.albumNameLabel.text = "Album name \(indexPath.row + 1)"
            cell.numberOfWordsLabel.text = "\(indexPath.row + 1) words"
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
