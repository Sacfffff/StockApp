//
//  LocalNetworkingManager.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 26.10.23.
//

import Foundation

class LocalNetworkingManager {
    
    static let shared = LocalNetworkingManager()
    
    private init() {}
    
    private let fileName: String = "coinModels"
    
    private var filePath: URL? {
        
        return try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(fileName)
    }
    
    
    func read<T: Codable>() -> T? {

        if let filePath, let data = try? Data(contentsOf: filePath) {
            return try? JSONDecoder().decode(T.self, from: data)
        }

        return nil
        
    }
    
    
    func write<T: Codable>(array: [T]) {
        
        if let filePath {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            do {
                try encoder.encode(array).write(to: filePath)
            } catch {
                print("Couldn’t save new entry to \(filePath), \(error.localizedDescription)")
            }
        }
        
    }
    
}
