//
//  NetworkManager.swift
//  PriceChanger
//
//  Created by Melih Yaşar SÖZEN on 9.07.2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private let baseURL = "https://api.collectapi.com/economy/allCurrency"
    private let apiKey = "apikey 64YbvGiZtc2ZBGoATbZBV0:6ZnNe5AsSjkZ7FItCvhmRl"
    private var currencies: [Currency]?
    
    private init() {}
    
    func fetchCurrencies(completion: @escaping (Result<[Currency], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(CurrencyResponse.self, from: data)
                if decodedResponse.success {
                    self.currencies = decodedResponse.result
                    completion(.success(decodedResponse.result))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "API call unsuccessful"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getCurrencies() -> [Currency]? {
        return currencies
    }
}

