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
    
    @Published var fullName: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""
    
    @Published var accountNo: String = ""
    @Published var bankName: String = ""
    @Published var balanceText: String = ""
    
    init() {
        refresh()
        loadUser()
        loadAccount()
    }
    
    func refresh() {
        self.user = AppState.shared.user
        self.account = DbService.shared.fetchAccount(for: user)
    }
    
    func getBalanceText() -> String {
        guard let bal = account?.balance else { return "—" }
        let value = bal
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

    private func loadUser() {
        let user = AppState.shared.user
        fullName = user?.name ?? ""
        phone = user?.phone ?? ""
        email = user?.email ?? ""
    }

    func savePersonalDetails() {
        guard let user = AppState.shared.user else { return }
        DbService.shared.updatePersonalDetails(
            for: user,
            fullName: fullName,
            email: email,
            phone: phone
        )
    }

    func isValid() -> Bool {
        Helper.isFormValid(for: [fullName, email, phone])
    }

    private func loadAccount() {
        if let user = AppState.shared.user,
           let fetched = DbService.shared.fetchAccount(for: user) {
            self.account = fetched
        }
    }

    func saveAccountDetails() {
        self.account = DbService.shared.saveAccountDetails(
            accountNo: accountNo,
            bankName: bankName,
            balanceText: balanceText,
            for: AppState.shared.user,
            existingAccount: account
        )
    }
    
    func addAccount(accountNo:String, bankName:String, balanceText:String) -> Bool {
        self.account = DbService.shared.addAccount(accountNo: accountNo, bankName: bankName, balanceText: balanceText)
        if self.account == nil {
            return false
        }
        return true
    }

}
