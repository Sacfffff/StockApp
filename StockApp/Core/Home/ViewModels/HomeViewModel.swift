//
//  HomeViewModel.swift
//  StockApp
//
//  Created by Alexandra Kravtsova on 24.10.23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var filteredCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    @Published var paginationState: PaginationState = .loading
    @Published var hasMoreResults: Bool = true
    
    private var cancelBag: Set<AnyCancellable> = []
    
    private var dataService = CoinDataService()
    
    init() {
        
        setup()
        
    }
    
    
    private func setup() {
        
        dataService.$allCoins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateState()
            }
            .store(in: &cancelBag)
        
        dataService.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateState()
            }
            .store(in: &cancelBag)
        
        dataService.$hasMoreResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.hasMoreResults = value
            }
            .store(in: &cancelBag)
        
        $searchText
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard !text.isEmpty else {
                    self?.filteredCoins = []
                    return
                }
                self?.filteredCoins = self?.allCoins.filterCoins(by: text.lowercased()) ?? []
            }
            .store(in: &cancelBag)
        
    }
    
    
    private func updateState() {
        
        if dataService.allCoins.isEmpty {
            if let error = dataService.error {
                paginationState = .error(error)
                print(error.localizedDescription)
            } else if dataService.hasMoreResults == false {
                paginationState = .idle
            } else {
                paginationState = .loading
            }
        } else {
            allCoins.merge(newModel: dataService.allCoins)
        }
        
    }
    
}


extension HomeViewModel {
    
    func getMoreModels() {
        
        dataService.getMoreCoins()
        
    }
    
    
    func refreshModels() {
        
        dataService.performUpdate()
        
    }
    
}


extension HomeViewModel {
    
    enum PaginationState {
        
        case loading
        case error(_ error: Error)
        case idle
        
    }
    
}


fileprivate extension Array where Element == CoinModel {
    
    mutating func merge(newModel: [CoinModel]) {
      
        self.append(contentsOf: newModel.reduce(into: []) { partialResult, coin in
            if !self.contains(where: { coin.id == $0.id }) {
                partialResult.append(coin)
            }
        })
        
    }
    
    
    func filterCoins(by text: String) -> [CoinModel] {
        
        return self.filter{ $0.name.lowercased().contains(text) ||
            $0.symbol.lowercased().contains(text) ||
            $0.id.lowercased().contains(text)}
        
    }
    
}
