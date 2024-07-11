//
//  CurrencyResponse.swift
//  PriceChanger
//
//  Created by Melih Yaşar SÖZEN on 11.07.2024.
//

import Foundation

struct CurrencyResponse: Decodable {
    let success: Bool
    let result: [Currency]
}
