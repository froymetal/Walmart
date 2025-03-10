//
//  Country.swift
//  WalmartChallenge
//
//  Created by Froylan Almeida on 3/6/25.
//


import Foundation

struct Country: Decodable {
    let name: String
    let region: String
    let code: String
    let capital: String?
}

