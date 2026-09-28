//
//  CurrencyExchange.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
import Foundation

struct CurrencyExchange: Codable {
    let baseCurrency:String
    let conversionRates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case baseCurrency = "base_code"
        case conversionRates = "conversion_rates"
    }
}
