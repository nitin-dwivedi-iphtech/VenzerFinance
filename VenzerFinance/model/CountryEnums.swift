//
//  CountryEnums.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//
import Foundation

enum Country: String, CaseIterable, Identifiable {
    
    case india = "INDIA"
    case usa = "USA"
    case china = "CHINA"
    case japan = "JAPAN"
    
    var id:String { self.rawValue }
    
    var currency:String {
        switch self {
        case .india:
            return "Ruppe"
        case .usa:
            return "Dollar"
        case .china:
            return "Yuan"
        case .japan:
            return "Yen"
        }
    }
    
    var currencyCode: String {
        switch self {
        case .india: return "INR"
        case .usa: return "USD"
        case .china: return "CNY"
        case .japan: return "JPY"
        }
    }
    
    var flagImageName: String {
        switch self {
        case .india: return "indiaFlagImage"
        case .usa: return "usaFlagImage"
        case .china: return "chinaFlagImage"
        case .japan: return "japanFlagImage"
        }
    }
    
    var currencySymbol: String {
        switch self {
        case .india: return "₹"
        case .usa: return "$"
        case .china: return "¥"
        case .japan: return "¥"
        }
    }
}
