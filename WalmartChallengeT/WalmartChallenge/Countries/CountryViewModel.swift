//
//  CountryViewModel.swift
//  WalmartChallenge
//
//  Created by Created by Froylan Almeida on 3/6/25.
//

import Foundation
import Combine

enum CountryViewState {
    case showProgressView
    case showCountries
    case showError
}

final class CountryViewModel {
    private let service: Service
    var anyCancellable: AnyCancellable?
    @Published var viewState: CountryViewState = .showProgressView
    
    private var countries = [Country]() {
        didSet {
            self.filteredCountries = countries
        }
    }
    private(set) var filteredCountries = [Country]()
   
    init(service: Service = CountryService()) {
        self.service = service
    }
    
    func getCountries() {
        let publisher = service.fetchCountries(url: EndPoint.url)
        anyCancellable = publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .finished:
                print("finished")
            case .failure(_):
                self?.countries = []
                self?.viewState = .showError
            }
        }, receiveValue: { [weak self] countries in
            self?.countries = countries
            self?.viewState = .showCountries

        })
    }
    
    func searchCountry(text: String) {
        if text.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter { country in
                country.name.lowercased().contains(text.lowercased()) ||
                country.capital?.lowercased().contains(text.lowercased()) ?? false
            }
        }
         viewState = .showCountries
    }
}
