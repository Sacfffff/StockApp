//
//  LocalFileManager.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 30.10.23.
//

import SwiftUI

class LocalFileManager {
    
    static let shared = LocalFileManager()
    
    private init() {}
    
    
    private func getURLForFolder(name: String) -> URL? {
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        return url.appendingPathComponent(name, conformingTo: .folder)
        
    }
    
    
    private func getURLForImage(name: String, folderName: String) -> URL? {
        
        createFolderIfNeeded(folderName: folderName)
        
        guard let folderURL = getURLForFolder(name: folderName) else { return nil }
        
        return folderURL.appendingPathComponent(name, conformingTo: .png)
        
    }
    
    
    private func createFolderIfNeeded(folderName: String) {
        
        guard let url = getURLForFolder(name: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path()) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        
    }
    
}


extension LocalFileManager {
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        guard let data = image.pngData(), let url = getURLForImage(name: imageName, folderName: folderName) else { return }
        
        try? data.write(to: url)
        
    }
    
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        
        guard let path = getURLForImage(name: imageName, folderName: folderName)?.path(), FileManager.default.fileExists(atPath: path) else { return nil }
        
        return UIImage(contentsOfFile: path)
        
    }
    
}
