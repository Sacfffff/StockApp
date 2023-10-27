//
//  CoinImageService.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 27.10.23.
//

import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable? = nil
    
    init(url: String) {
        
        getCoinImage(urlString: url)
        
    }
    
}


private extension CoinImageService {
    
    func getCoinImage(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data in
                return UIImage(data: data)
            })
            .replaceError(with: nil)
            .sink(receiveValue: { [weak self] image in
                self?.image = image
                self?.imageSubscription?.cancel()
            })
        
    }
    
}
