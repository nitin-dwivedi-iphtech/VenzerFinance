//
//  CurrencyConverterViewModel.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
//
import Foundation
import Combine

class CurrencyConverterViewModel: ObservableObject {
    @Published var rate: Double = 0.0
    
    let maxBalance: Double
    
    @Published var amountText: String = "" {
        didSet {
            if let doubleVal = Double(amountText), doubleVal > maxBalance {
                amountText = String(format: "%.2f", maxBalance)
            }
        }
    }
    
    @Published var isLoading: Bool = false
    
    init() {
        if let balance = DbService.shared.fetchAccount(for: AppState.shared.user)?.balance {
            self.maxBalance = balance
            self.amountText = String(format: "%.2f", balance)
        } else {
            self.maxBalance = 0.0
            self.amountText = "0.00"
        }
    }
    
    func getConvertedValue(from: Country, to: Country) -> String {
        guard let amount = Double(amountText) else { return "0.00" }
        return Helper.ExchangeRateHelper.calculate(
            for: amount,
            rate: rate,
            fromCountry: from,
            toCountry: to
        ) ?? "0.00"
    }
    
    @MainActor
    func fetchRate(from: Country, to: Country) async {
        if from == to {
            self.rate = 1.0
            return
        }
        
        isLoading = true
        if let fetchedRate = await ApiService.shared.fetchCurrencyRates(for: from.currencyCode, to: to.currencyCode) {
            self.rate = fetchedRate
        }
        isLoading = false
    }
}
