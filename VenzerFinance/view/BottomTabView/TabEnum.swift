//
//  TabEnum.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//
import Foundation

enum Tab: String, CaseIterable, Identifiable {
    case home = "house.fill"
    case balanceOverview = "wallet.pass.fill"
    case chart = "chart.bar.fill"
    case setting = "gearshape.2.fill"
    
    var id:String { self.rawValue }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .balanceOverview: return "Stats"
        case .chart: return "Wallet"
        case .setting: return "Profile"
        }
    }
}
