//
//  DepositViewModel.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 30/09/26.
//

import Combine
import CoreData
import Foundation
import SwiftUI

class DepositViewModel: ObservableObject {
    @Published var user: User?
    @Published var accounts: [Account] = []
    @Published var fromAccount: Account?
    @Published var toAccount: Account?
    @Published var amount: String = ""

    let quickAmounts = ["50", "100", "200", "500"]

    private var cancellables = Set<AnyCancellable>()

    init() {
        refresh()
        NotificationCenter.default.publisher(for: .balanceDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.refresh() }
            .store(in: &cancellables)
    }

    func refresh() {
        user = AppState.shared.user
        // From defaults to my primary account; To = any account so money moves between accounts.
        let mine = DbService.shared.fetchAccounts(for: user)
        let primary = DbService.shared.fetchPrimaryAccount(for: user)
        var all = mine
        all.sort {  ($0.bankName ?? "") < ($1.bankName ?? "") }
        accounts = all

        if let current = fromAccount, let match = all.first(where: { $0.id == current.id }) {
            fromAccount = match
        } else {
            fromAccount = primary ?? all.first
        }
        if let current = toAccount, let match = all.first(where: { $0.id == current.id }) {
            toAccount = match
        } else {
            toAccount = all.first(where: { $0.id != fromAccount?.id })
        }
    }

    // MARK: - Derived

    var country: Country? {
        guard let raw = user?.country else { return nil }
        return Country(rawValue: raw)
    }

    var currencySymbol: String {
        if let code = fromAccount?.currency, let c = Country.fromCurrencyCode(code) { return c.currencySymbol }
        if let code = toAccount?.currency, let c = Country.fromCurrencyCode(code) { return c.currencySymbol }
        return country?.currencySymbol ?? "$"
    }

    var hasAccounts: Bool { accounts.count >= 1 }
    var canTransfer: Bool { accounts.count >= 2 }

    var fromBalance: Double { fromAccount?.balance ?? 0 }
    var depositValue: Double { Double(amount) ?? 0 }

    func money(_ value: Double) -> String {
        "\(currencySymbol)\(String(format: "%.2f", value))"
    }

    var formattedAmountWithSymbol: String { money(depositValue) }

    func title(for account: Account?) -> String {
        guard let account else { return "Select account" }
        let bank = (account.bankName?.isEmpty == false) ? account.bankName! : "Account"
        if let no = account.account_no, !no.isEmpty {
            return "\(bank) • \(String(no.suffix(4)))"
        }
        return bank
    }

    func balanceText(for account: Account?) -> String {
        money(account?.balance ?? 0)
    }

    var amountErrorMessage: String? {
        guard !amount.isEmpty else { return nil }
        guard let value = Double(amount) else { return "Enter a valid amount" }
        if value <= 0 { return "Amount must be greater than \(currencySymbol)0" }
        if let from = fromAccount, value > from.balance {
            return "Exceeds balance in \(title(for: from))"
        }
        return nil
    }

    var isMoveDisabled: Bool {
        guard let from = fromAccount, let to = toAccount,
              from.id != to.id,
              let value = Double(amount), value > 0, value <= from.balance else { return true }
        return false
    }

    // MARK: - Actions

    func setQuickAmount(_ value: String) { amount = value }

    func swapAccounts() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
            let tmp = fromAccount
            fromAccount = toAccount
            toAccount = tmp
        }
    }

    func selectFrom(_ account: Account) { fromAccount = account }
    func selectTo(_ account: Account) { toAccount = account }

    func validate() -> String? {
        guard canTransfer else { return "Need at least 2 accounts to move money." }
        guard let from = fromAccount, let to = toAccount else { return "Select both accounts." }
        guard from.id != to.id else { return "Pick two different accounts." }
        guard let value = Double(amount), value > 0 else {
            return "Enter an amount greater than \(currencySymbol)0."
        }
        guard value <= from.balance else { return "Insufficient balance in \(title(for: from))." }
        return nil
    }

    @discardableResult
    func move() -> Bool {
        if validate() != nil { return false }
        let ok = DbService.shared.transferMoney(amount: depositValue, from: fromAccount, to: toAccount, for: user)
        if ok { refresh() }
        return ok
    }

    func resetAfterSuccess() { amount = "" }

    // MARK: - Helpers

    static func sanitized(_ value: String) -> String {
        var filtered = value.filter { $0.isNumber || $0 == "." }
        var dotSeen = false
        filtered = filtered.filter {
            if $0 == "." {
                if dotSeen { return false }
                dotSeen = true
                return true
            }
            return true
        }
        if filtered.hasPrefix(".") { filtered = "0" + filtered }
        if let dotIndex = filtered.firstIndex(of: ".") {
            let decimals = filtered[filtered.index(after: dotIndex)...]
            if decimals.count > 2 {
                let end = filtered.index(dotIndex, offsetBy: 3)
                filtered = String(filtered[..<end])
            }
        }
        if filtered.count > 10 { filtered = String(filtered.prefix(10)) }
        return filtered
    }
}
