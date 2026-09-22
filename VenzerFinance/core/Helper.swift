//
//  Helper.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//

import Foundation

enum Helper {
    static func isFormValid(for fields: [String]) -> Bool {
        fields.allSatisfy { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    enum ExchangeRateHelper {
        
        private static let baseRatesInUSD: [Country: Double] = [
            .usa: 1.0,
            .india: 83.25,
            .china: 7.24,
            .japan: 150.0
        ]
        
        // Calculate Cross Exchange Rate
        
        static func rate(from source: Country, to target: Country) -> Double {
            guard let sourceRateUSD = baseRatesInUSD[source],
                  let targetRateUSD = baseRatesInUSD[target],
                  sourceRateUSD > 0 else { return 1.0 }
            
            return targetRateUSD / sourceRateUSD
        }
        
        
        // Convert Arbitrary Amounts
        
        static func convert(_ amount: Double, from source: Country, to target: Country) -> Double {
            guard amount >= 0 else { return 0.0 }
            let currentRate = rate(from: source, to: target)
            return amount * currentRate
        }
        
        
        // Unit Directional Formatted String
        static func formatOneUnit(from source: Country, to target: Country) -> String {
            let currentRate = rate(from: source, to: target)
            let sourceFormatted = formatCurrency(1, country: source)
            
            // Adapt precision for small rates (like JPY -> USD)
            if currentRate < 0.01 {
                let formattedValue = String(format: "%.6f", currentRate)
                return "\(sourceFormatted) = \(target.currencySymbol)\(formattedValue) \(target.currencyCode)"
            } else {
                let targetFormatted = formatCurrency(currentRate, country: target)
                return "\(sourceFormatted) = \(targetFormatted) \(target.currencyCode)"
            }
        }
        
        
        // Bi-Directional Rate Comparison (Vice-Versa Pair)
        
        static func formatViceVersa(between countryA: Country, and countryB: Country) -> (direct: String, inverse: String) {
            let direct = formatOneUnit(from: countryA, to: countryB)
            let inverse = formatOneUnit(from: countryB, to: countryA)
            return (direct, inverse)
        }
        
        
        // Currency Formatting (Handles JPY zero-decimals)
        
        static func formatCurrency(_ value: Double, country: Country) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = country.currencyCode
            formatter.currencySymbol = country.currencySymbol
            
            if country == .japan {
                formatter.maximumFractionDigits = 0
                formatter.minimumFractionDigits = 0
            } else {
                formatter.maximumFractionDigits = 2
                formatter.minimumFractionDigits = 2
            }
            
            return formatter.string(from: NSNumber(value: value)) ?? "\(country.currencySymbol)\(value)"
        }
        
        static func currencyConversionCharges(for country: Country) -> String {
            let rate: Double
            switch country {
            case .india:
                rate = 2.35
            case .japan:
                rate = 1.85
            case .china:
                rate = 5.25
            case .usa:
                rate = 0.35
            }
            
            return String(format: "%.2f", rate)
        }
    }
}
