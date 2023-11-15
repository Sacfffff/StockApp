//
//  LocalNetworkingManager.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 26.10.23.
//

import Foundation

class LocalNetworkingManager {
    
    static let shared = LocalNetworkingManager()
    
    private let folderName: String = "CryptoApp_LocalData"
    
    private init() {}
    
    
    private func filePath(for name: String) -> URL? {
        
        createFolderIfNeeded()
        
        guard let urlForFolder else { return nil }
        
        return urlForFolder.appendingPathComponent(name)
        
    }
    
    
    private func createFolderIfNeeded() {
        
        guard let urlForFolder else { return }
        
        if !FileManager.default.fileExists(atPath: urlForFolder.path()) {
            try? FileManager.default.createDirectory(at: urlForFolder, withIntermediateDirectories: true)
        }
        
    }
    
    
    private var urlForFolder: URL? {
        
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return url.appendingPathComponent(folderName, conformingTo: .folder)
        
    }
    
}


extension LocalNetworkingManager {
    
    func read<T: Codable>(from type: FileName) -> T? {

        if let filePath = filePath(for: type.fileName), let data = try? Data(contentsOf: filePath) {
            return try? JSONDecoder().decode(T.self, from: data)
        }

        return nil
        
    }
    
    
    func write<T: Codable>(data: T, to type: FileName) {
        
        if let filePath = filePath(for: type.fileName) {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            do {
                try encoder.encode(data).write(to: filePath)
            } catch {
                print("Couldn’t save new entry to \(filePath), \(error.localizedDescription)")
            }
        }
        
    }
    
}

extension LocalNetworkingManager {
    
    enum FileName {
        
        case coinModels
        case marketData
        case custom(fileName: String)
        
        var fileName: String {
            
            return switch self {
                case .custom(fileName: let name):
                    name
                default:
                    "\(self)"
            }
            
        }
        
    }
    
}
