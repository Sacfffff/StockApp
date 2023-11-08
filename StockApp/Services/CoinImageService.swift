//
//  CoinImageService.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 27.10.23.
//

import SwiftUI
import Combine

class CoinImageService: ObservableObject {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable? = nil
    private let fileManager = LocalFileManager.shared
    private let coin: CoinModel
    
    private let folderName: String = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
        
    }
    
}


private extension CoinImageService {
    
    func getCoinImage() {
        
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadCoinImage(urlString: coin.image)
        }
        
    }
    
    
    func downloadCoinImage(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data in
                return UIImage(data: data)
            })
            .replaceError(with: nil)
            .sink(receiveValue: { [weak self] image in
                if let self, let image {
                    self.image = image
                    self.imageSubscription?.cancel()
                    self.fileManager.saveImage(image: image, imageName: self.imageName, folderName: self.folderName)
                }
            })
        
    }
    
}
