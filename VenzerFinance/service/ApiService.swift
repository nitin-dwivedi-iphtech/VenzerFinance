//
//  ApiService.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//

import Combine
import Foundation

class ApiService:ObservableObject {
    static let shared:ApiService = ApiService()
    
    private init() {}
    
    func fetchCurrencyRates(for fromCurrency:String, to toCurrency:String ) async -> Double? {
        guard let url = URL(string: "\(Constants.currencyConversionBaseUrl.rawValue)\(fromCurrency)") else {
            return nil
        }
        do{
            let (jsonData, _) = try await URLSession.shared.data(from: url)
            let res = try JSONDecoder().decode(CurrencyExchange.self, from: jsonData)
            return res.conversionRates[toCurrency]
        } catch {
            print(error)
        }
        return nil
    }
}
