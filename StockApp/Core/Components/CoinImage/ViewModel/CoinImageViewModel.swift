//
//  CoinImageViewModel.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 27.10.23.
//

import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = true
    
    private let dataService: CoinImageService
    private var cancelBag: Set<AnyCancellable> = []
    
    init(coin: CoinModel) {
        
        dataService = CoinImageService(coin: coin)
        setup()
        
    }
    
}


private extension CoinImageViewModel {
    
    func setup() {
        
        dataService.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.image = image
                self?.isLoading = false
            }
            .store(in: &cancelBag)
        
    }
    
}
