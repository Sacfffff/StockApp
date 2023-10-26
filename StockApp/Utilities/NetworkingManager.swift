//
//  NetworkingManager.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 26.10.23.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        
        case badUrlResponce(url: URL?)
        case unknown
        
        var errorDescription: String? {
            
            var result: String?
            
            switch self {
                case .badUrlResponce(let url):
                    if let url {
                        result = "[🔥] Bad responce from URL. URL: \(url))"
                    }
                case .unknown:
                    result = "[⚠️] Unknown error occured"
            }
            
            return result
            
        }
        
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap(handleUrlResponce(_:))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    
    private static func handleUrlResponce(_ output: URLSession.DataTaskPublisher.Output) throws -> Data {
    
        guard let responce = output.response as? HTTPURLResponse, 200...299 ~= responce.statusCode else {
            throw NetworkingError.badUrlResponce(url: output.response.url)
        }
        return output.data
        
    }
    
    
}
