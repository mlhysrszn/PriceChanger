//
//  ViewController.swift
//  PriceChanger
//
//  Created by Melih Yaşar SÖZEN on 9.07.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    var usdCurrency: Currency?
    var eurCurrency: Currency?
    var gbpCurrency: Currency?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchInitialCurrencies()
    }
    
    func fetchInitialCurrencies() {
        NetworkManager.shared.fetchCurrencies { [weak self] result in
            switch result {
            case .success(let currencies):
                DispatchQueue.main.async {
                    print("Currencies fetched successfully: \(currencies)")
                    self?.storeCurrencies(currencies: currencies)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.resultLabel.text = "Error fetching currencies: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func storeCurrencies(currencies: [Currency]) {
        self.usdCurrency = currencies.first(where: { $0.code == "USD" })
        self.eurCurrency = currencies.first(where: { $0.code == "EUR" })
        self.gbpCurrency = currencies.first(where: { $0.code == "GBP" })
        
        guard let usd = usdCurrency, let eur = eurCurrency, let gbp = gbpCurrency else {
            resultLabel.text = "Currency data not available"
            return
        }
        
        currencyLabel.text = String(format: """
                Current currencies
                USD: %.2f
                EUR: %.2f
                GBP: %.2f
                """, usd.buying, eur.buying, gbp.buying)
    }
    
    @IBAction func convertTapped(_ sender: Any) {
        guard let amountText = textField.text, let amount = Double(amountText) else {
            resultLabel.text = "Please enter a valid number"
            return
        }
        
        guard let currencies = NetworkManager.shared.getCurrencies() else {
            resultLabel.text = "Currency data not available"
            return
        }
        
        updateLabel(with: amount, currencies: currencies)
    }
    
    func updateLabel(with amount: Double, currencies: [Currency]) {
        guard let usd = usdCurrency,
                let eur = eurCurrency,
                let gbp = gbpCurrency else {
            resultLabel.text = "Currency data not available"
            return
        }
        
        let usdValue = amount / usd.buying
        let eurValue = amount / eur.buying
        let gbpValue = amount / gbp.buying
        
        resultLabel.text = String(format: """
                Converted amount
                USD: %.2f
                EUR: %.2f
                GBP: %.2f
                """, usdValue, eurValue, gbpValue)
    }
}

