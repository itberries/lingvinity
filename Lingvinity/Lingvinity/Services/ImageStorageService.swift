//
//  ImageStorageService.swift
//  Lingvinity
//
//  Created by Anastasia Puchnina on 11/12/2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import Foundation
import UIKit

class ImageStorageService {
    
    func save(image: UIImage, withName imageName: String) {
        // Save imageData to filePath
        
        // Get access to shared instance of the file manager
        let fileManager = FileManager.default
        
        // Get the URL for the users home directory
        let documentsURL =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Create filePath URL by appending final path component (name of image)
        let filePath = documentsURL.appendingPathComponent("\(imageName).png")
        
        // Create imageData and write to filePath
        do {
            if let pngImageData = image.pngData() {
                try pngImageData.write(to: filePath, options: .atomic)
            }
        } catch {
            print("Couldn't write image with name \(imageName)")
        }
    }
    
    func getImage(withName imageName: String) -> UIImage? {
        // Get access to shared instance of the file manager
        let fileManager = FileManager.default
        
        // Get the URL for the users home directory
        let documentsURL =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Get the document URL as a string
        let documentPath = documentsURL.path
        
        // Create filePath URL by appending final path component (name of image)
        let filePath = documentsURL.appendingPathComponent("\(imageName).png")
        
        // Check for existing image data
        do {
            // Look through array of files in documentDirectory
            let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            
            // TODO: need to optimize image searching
            for file in files {
                if "\(documentPath)/\(file)" == filePath.path {
                    print("Image with this name exists.")
                    let image = UIImage(contentsOfFile: filePath.path)
                    return image
                }
            }
        } catch {
            print("Could not get image with name \(imageName) from document directory: \(error)")
        }
        return nil
    }
    
}

