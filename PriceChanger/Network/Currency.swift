//
//  Currency.swift
//  PriceChanger
//
//  Created by Melih Yaşar SÖZEN on 11.07.2024.
//

import Foundation

struct Currency: Decodable {
    let name: String
    let code: String
    let buying: Double
    let buyingstr: String
    let selling: Double
    let sellingstr: String
    let rate: Double
    let time: String
    let date: String
    let datetime: String
    let calculated: Int
}
