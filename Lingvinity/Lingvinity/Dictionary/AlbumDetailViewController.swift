//
//  AlbumDetailViewController.swift
//  Lingvinity
//
//  Created by Anastasia Puchnina on 12/12/2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import Foundation
import UIKit

class AlbumDetailViewController: UIViewController{
    
    var selectedAlbum : AlbumModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: заполнение массива слов словами из базы данных
    }
    
}

extension AlbumDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension AlbumDetailViewController : UITableViewDelegate {
    
}


