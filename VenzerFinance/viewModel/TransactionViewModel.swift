//
//  TransactionViewModel.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import Foundation
import Combine
import SwiftUI
import CoreData

class TransactionViewModel: ObservableObject {
    @Published var user: User? = AppState.shared.user
    @Published var account: Account?

    @Published var amount: String = ""
    @Published var selectedRecipient: RecipientItem?

    var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    let quickAmounts = ["50", "100", "200", "500"]

    @Published var recipients: [RecipientItem] = []

    private let recipientTints: [Color] = [
        Color("CardColor"),
        Color(red: 0.2, green: 0.5, blue: 0.85),
        Color(red: 0.55, green: 0.35, blue: 0.85),
        Color(red: 0.13, green: 0.52, blue: 0.28)
    ]

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
        account = DbService.shared.fetchAccount(for: user)
        loadRecipients()
    }

    private func loadRecipients() {
        let users = DbService.shared.fetchAllUsers(excluding: user)
        let accountsByUserId = DbService.shared.fetchAccountsByUserIds(users.compactMap { $0.id })
        recipients = users.enumerated().map { index, recipientUser in
            let displayName: String = {
                if let name = recipientUser.name, !name.trimmingCharacters(in: .whitespaces).isEmpty {
                    return name
                }
                return recipientUser.email ?? "Unknown"
            }()
            let detail: String = {
                if let no = accountsByUserId[recipientUser.id ?? ""]?.account_no,
                   !no.isEmpty {
                    let bank = accountsByUserId[recipientUser.id ?? ""]?.bankName ?? "Account"
                    return "\(bank) ••\(String(no.suffix(4)))"
                }
                return recipientUser.email ?? recipientUser.phone ?? ""
            }()
            return RecipientItem(
                id: recipientUser.id ?? UUID().uuidString,
                name: displayName,
                detail: detail,
                initials: Self.initials(for: displayName),
                tint: recipientTints[index % recipientTints.count]
            )
        }
        if let selected = selectedRecipient, !recipients.contains(selected) {
            selectedRecipient = nil
        }
    }

    private static func initials(for name: String) -> String {
        let parts = name.split(separator: " ").map(String.init)
        if parts.count >= 2 {
            return String((parts[0].prefix(1) + parts[1].prefix(1)).uppercased())
        }
        return String(name.prefix(2).uppercased())
    }

    var country: Country? {
        guard let raw = user?.country else { return nil }
        return Country(rawValue: raw)
    }

    var currencySymbol: String {
        if let code = account?.currency, let country = Country.fromCurrencyCode(code) {
            return country.currencySymbol
        }
        return country?.currencySymbol ?? "$"
    }

    var currencyCode: String {
        if let code = account?.currency, !code.isEmpty {
            return code
        }
        return country?.currencyCode ?? "USD"
    }

    func money(_ value: Double) -> String {
        "\(currencySymbol)\(String(format: "%.2f", value))"
    }

    var hasAccount: Bool {
        account != nil
    }

    var balance: Double {
        account?.balance ?? 0
    }

    var userInitial: String {
        String((user?.name ?? "V").prefix(1)).uppercased()
    }

    var accountTitle: String {
        guard let account, let no = account.account_no, !no.isEmpty else {
            return "Everyday account"
        }
        return "\(account.bankName ?? "Everyday account") • \(String(no.suffix(4)))"
    }

    var availableText: String {
        "Available \(money(balance)) (\(currencyCode))"
    }

    var formattedAmount: String {
        guard let value = Double(amount), !amount.isEmpty else { return "0.00" }
        return String(format: "%.2f", value)
    }

    var formattedAmountWithSymbol: String {
        guard let value = Double(amount), !amount.isEmpty else { return "\(currencySymbol)0.00" }
        return money(value)
    }

    var remainingBalanceText: String {
        money(max(0, balance - (Double(amount) ?? 0)))
    }

    var amountErrorMessage: String? {
        guard !amount.isEmpty, let value = Double(amount) else { return nil }
        if value <= 0 { return "Amount must be greater than \(currencySymbol)0" }
        if value > balance { return "Exceeds available balance" }
        return nil
    }

    var isSendDisabled: Bool {
        guard let value = Double(amount), value > 0, value <= balance else { return true }
        return selectedRecipient == nil
    }

    func setQuickAmount(_ value: String) {
        amount = value
    }

    func select(_ recipient: RecipientItem) {
        selectedRecipient = recipient
    }

    func validate() -> String? {
        guard account != nil else {
            return "No account found. Add an account first."
        }
        guard let value = Double(amount), value > 0 else {
            return "Enter an amount greater than \(currencySymbol)0."
        }
        guard selectedRecipient != nil else {
            return "Please select a recipient first."
        }
        guard value <= balance else {
            return "Insufficient balance for this transfer."
        }
        return nil
    }

    @discardableResult
    func send() -> Bool {
        if validate() != nil { return false }
        guard let value = Double(amount) else { return false }
        let ok = DbService.shared.sendMoney(
            amount: value,
            from: account,
            for: user,
            to: selectedRecipient?.id
        )
        if ok { refresh() }
        return ok
    }

    func resetAfterSuccess() {
        amount = ""
    }
}
