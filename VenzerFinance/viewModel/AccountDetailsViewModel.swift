//
//  AccountDetailsViewModel.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
//
import Foundation
import Combine
import CoreData

class AccountDetailsViewModel: ObservableObject {
    @Published var accountNo: String = ""
    @Published var bankName: String = ""
    @Published var balanceText: String = ""
    
    var account: Account?

    init() {
        loadAccount()
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
        // when nil keep empty — view shows modern empty state
    }

    func saveAccountDetails() {
        account = DbService.shared.saveAccountDetails(
            accountNo: accountNo,
            bankName: bankName,
            balanceText: balanceText,
            for: AppState.shared.user,
            existingAccount: account
        )
    }

    func isValid() -> Bool {
        Helper.isFormValid(for: [accountNo, bankName, balanceText])
    }
}
