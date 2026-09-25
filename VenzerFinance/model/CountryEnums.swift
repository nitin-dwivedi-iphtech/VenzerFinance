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
    case euro = "EURO"
    case aus = "AUSTRALIA"
    case nigeria = "NIGERIA"
    case canada = "CANADA"
    
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
        case .euro:
            return "EURO"
        case .aus:
            return "AUS Dollar"
        case .nigeria:
            return "Nigerian Naira"
        case .canada:
            return "Candian Dollar"
        }
    }
    
    var currencyCode: String {
        switch self {
        case .india: return "INR"
        case .usa: return "USD"
        case .china: return "CNY"
        case .japan: return "JPY"
        case .euro: return "EUR"
        case .aus: return "AUD"
        case .nigeria: return "NGN"
        case .canada: return "CAD"
        }
    }
    
    var flagImageName: String {
        switch self {
        case .india: return "indiaFlagImage"
        case .usa: return "usaFlagImage"
        case .china: return "chinaFlagImage"
        case .japan: return "japanFlagImage"
        case .euro: return "european-union"
        case .aus: return "australia"
        case .nigeria: return "nigeria"
        case .canada: return "canada"
        }
    }
    
    var currencySymbol: String {
        switch self {
        case .india: return "₹"
        case .usa, .aus, .canada: return "$"
        case .china, .japan: return "¥"
        case .euro: return "€"
        case .nigeria: return "₦"
        }
    }
}
