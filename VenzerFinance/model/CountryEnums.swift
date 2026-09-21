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
}
