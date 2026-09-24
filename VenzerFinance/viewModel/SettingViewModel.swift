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
    @Published var dateOfBirth: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""
    @Published var residentialAddress: String = ""
    
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

    private func loadUser() {
        if let user = AppState.shared.user {
            fullName = user.name ?? ""
            phone = user.phone ?? ""
            email = user.email ?? ""
            if fullName.isEmpty { fullName = "Maya Thompson" }
            if dateOfBirth.isEmpty { dateOfBirth = "18 Jun 1992" }
            if phone.isEmpty { phone = "+44 7700 900 184" }
            if email.isEmpty { email = "maya.thompson@example.com" }
            if residentialAddress.isEmpty { residentialAddress = "24 Willow Lane, Bristol BS1 4DA" }
        } else {
            fullName = "Maya Thompson"
            dateOfBirth = "18 Jun 1992"
            phone = "+44 7700 900 184"
            email = "maya.thompson@example.com"
            residentialAddress = "24 Willow Lane, Bristol BS1 4DA"
        }
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
            account = fetched
            accountNo = fetched.account_no ?? ""
            bankName = fetched.bankName ?? ""
            if let bal = fetched.balance {
                balanceText = String(format: "%.2f", bal.doubleValue)
            }
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

}
