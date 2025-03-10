//
//  CountryService.swift
//  WalmartChallenge
//
//  Created by Froylan Almeida on 3/6/25.
//


import Foundation
import Combine

enum ApiError: Error {
    case invalidUrl
    case decodingFailed
    case networkError(Error)
}

protocol Service {
    func fetchCountries(url: String) -> AnyPublisher<[Country], Error>
}

final class CountryService: Service {
    func fetchCountries(url: String) -> AnyPublisher<[Country], Error> {
        guard let url = URL(string: url) else {
            return Fail(error: ApiError.invalidUrl).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Country].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
