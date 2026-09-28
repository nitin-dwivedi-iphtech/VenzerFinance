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
        
        static func calculate(for amount: Double?, rate: Double?, fromCountry: Country, toCountry: Country) -> String? {
            guard let amount = amount, let rate = rate else { return nil }
            
            let fee = rawConversionFee(for: fromCountry, to: toCountry)
            let result = (amount * rate) - fee
            let roundedResult = (max(0, result) * 100).rounded() / 100
            
            return String(format: "%.2f", roundedResult)
        }
        
        static func rawConversionFee(for fromCountry: Country, to toCountry: Country) -> Double {
            if fromCountry == toCountry { return 0.0 }
            
            switch fromCountry {
            case .india:
                return 2.35
            case .japan:
                return 1.85
            case .china:
                return 5.25
            case .usa:
                return 0.35
            case .aus:
                return 0.84
            case .canada:
                return 0.24
            case .nigeria:
                return 3.85
            case .euro:
                return 1.25
            }
        }
        
        static func currencyConversionCharges(for fromCountry: Country, to toCountry: Country) -> String {
            let fee = rawConversionFee(for: fromCountry, to: toCountry)
            return String(format: "%.2f", fee)
        }
    }
}
