//
//  FakeCountryService.swift
//  WalmartChallengeTests
//
//  Created by Created by Froylan Almeida on 3/6/25.
//

import Foundation
import Combine
@testable import WalmartChallenge

class FakeCountryService: Service {
    var isSuccess = false
    func fetchCountries(url: String) -> AnyPublisher<[WalmartChallenge.Country], any Error> {
        if isSuccess {
            return Just([WalmartChallenge.Country]([Country(name:"Test", region: "Test", code: "Test", capital: "Test")]))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: ApiError.invalidUrl).eraseToAnyPublisher()
    }
}
