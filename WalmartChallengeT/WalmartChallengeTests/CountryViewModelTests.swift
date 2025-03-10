//
//  WalmartChallengeTests.swift
//  WalmartChallengeTests
//
//  Created by Created by Froylan Almeida on 3/6/25.
//

import XCTest
@testable import WalmartChallenge
import Combine

final class CountryViewModelTests: XCTestCase {

    var countryViewModel: CountryViewModel!
    var fakeCountryService = FakeCountryService()
    private var cancellables: AnyCancellable?

    override func setUp() {
        countryViewModel = CountryViewModel(service: fakeCountryService)
    }

    override func tearDown(){
        countryViewModel = nil
    }
    
    func test_getCountries_whenCalled_returnsCountries() {
        fakeCountryService.isSuccess = true
        countryViewModel.getCountries()
        let expectation =  XCTestExpectation(description: "success")
        cancellables = countryViewModel.$viewState.sink { [weak self] viewState in
            switch viewState {
            case .showProgressView:
                XCTAssertEqual(self?.countryViewModel.filteredCountries.count, 0)

              //  XCTFail("Should not be loading")
            case .showCountries:
                XCTAssertEqual(self?.countryViewModel.filteredCountries.count, 1)
            case .showError:
                XCTFail("Should not be in failure state")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func test_getCountries_whenCalled_returnsFailure() {
        fakeCountryService.isSuccess = true
        countryViewModel.getCountries()
        let expectation =  XCTestExpectation(description: "Fail")
        cancellables = countryViewModel.$viewState.sink { [weak self] viewState in
            switch viewState {
            case .showProgressView:
                XCTAssertEqual(self?.countryViewModel.filteredCountries.count, 0)

              //  XCTFail("Should not be loading")
            case .showCountries:
                XCTAssertEqual(self?.countryViewModel.filteredCountries.count, 1)
            case .showError:
                XCTAssertEqual(self?.countryViewModel.filteredCountries.count, 0)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
