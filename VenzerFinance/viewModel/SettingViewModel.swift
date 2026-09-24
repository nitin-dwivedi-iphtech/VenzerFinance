//
//  SettingViewModel.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
//
import Foundation
import Combine

class SettingViewModel: ObservableObject {
    @Published var account: Account?
    @Published var user: User?

    init() {
        self.user = AppState.shared.user
        self.account = DbService.shared.fetchAccount(for: user)
    }

    func getBalanceText() -> String {
        guard let bal = account?.balance else { return "—" }
        let value = bal.doubleValue
        if value == 0 { return "0.00" }
        return String(format: "%.2f", value)
    }

    func getShortAccountNo() -> String {
        guard let no = account?.account_no, !no.isEmpty else { return "—" }
        if no.count > 12 {
            return "•••• \(no.suffix(4))"
        }
        return no
    }

    func getCurrencyCode() -> String {
        if let raw = user?.country, let c = Country(rawValue: raw) {
            return c.currencyCode
        }
        return "USD"
    }
}
