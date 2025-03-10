//
//  ViewController.swift
//  WalmartChallenge
//
//  Created by Froylan Almeida on 3/6/25.
//

import UIKit
import Combine

final class CountryViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    private let viewModel = CountryViewModel()
    private var anyCancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        searchBar.delegate = self
        
        // Get countries at load
        fetchCountries()
    }
    
    // Función to get countries
    private func fetchCountries() {
        viewModel.getCountries()
        anyCancellable = viewModel.$viewState.sink { [weak self] state in
            switch state {
            case .showProgressView:
                print("")
            case .showCountries:
                self?.tableView.reloadData()
            case .showError:
                self?.showError()
            }
        }
    }
    
    private func showError() {
        let vc = UIAlertController(title: "Error", message: "Something went wrong while fetching data", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive)
        vc.addAction(action)
        self.present(vc, animated: true)
    }
}

extension CountryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        
        let country = viewModel.filteredCountries[indexPath.row]
        cell.textLabel?.text = "\(country.name),\(country.region) - \(country.code) - \(country.capital ?? "")"
        return cell
    }
}

extension CountryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchCountry(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.searchCountry(text: "")
    }
}
