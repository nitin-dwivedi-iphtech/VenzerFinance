//
//  SettingViewModel.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import Foundation
import Combine

class SettingViewModel: ObservableObject {
    @Published var account: Account?
    @Published var accounts: [Account] = []
    @Published var user: User?

    @Published var fullName: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""

    @Published var accountNo: String = ""
    @Published var bankName: String = ""
    @Published var balanceText: String = ""

    @Published var profileImageData: Data?
    @Published var avatarData: Data?

    private var cancellables = Set<AnyCancellable>()
    private var loadedUserId: String?
    
    init() {
        refresh()
        loadUser()
        loadAccount()
        NotificationCenter.default.publisher(for: .balanceDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.refresh() }
            .store(in: &cancellables)
    }
    
    func refresh() {
        self.user = AppState.shared.user
        if loadedUserId != user?.id {
            loadedUserId = user?.id
            loadUser()
        }
        avatarData = user?.image
        let all = DbService.shared.fetchAccounts(for: user)
        self.accounts = all
        let primary = DbService.shared.fetchPrimaryAccount(for: user)
        if let currentId = account?.id,
           let match = all.first(where: { $0.id == currentId }) {
            self.account = match
        } else {
            self.account = primary ?? all.first
        }
    }

    var primaryAccount: Account? {
        DbService.shared.fetchPrimaryAccount(for: user) ?? account
    }

    func isPrimary(_ item: Account) -> Bool {
        DbService.shared.isPrimary(item)
    }

    func setPrimary(_ item: Account) {
        DbService.shared.setPrimaryAccount(item, for: user)
        refresh()
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
        if let code = account?.currency, !code.isEmpty {
            return code
        }
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
        profileImageData = user?.image
        avatarData = user?.image
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

    func saveProfilePhoto() {
        guard let user = AppState.shared.user else { return }
        if user.image != profileImageData {
            DbService.shared.updateProfilePhoto(profileImageData, for: user)
            avatarData = profileImageData
        }
    }

    func isValid() -> Bool {
        Helper.isFormValid(for: [fullName, email, phone])
    }

    private func loadAccount() {
        if let user = AppState.shared.user {
            let all = DbService.shared.fetchAccounts(for: user)
            self.accounts = all
            self.account = all.first
        }
    }

    func selectAccount(_ selected: Account) {
        account = selected
        accountNo = selected.account_no ?? ""
        bankName = selected.bankName ?? ""
        balanceText = String(format: "%.2f", selected.balance)
    }

    func saveAccountDetails() {
        self.account = DbService.shared.saveAccountDetails(
            accountNo: accountNo,
            bankName: bankName,
            balanceText: balanceText,
            for: AppState.shared.user,
            existingAccount: account
        )
        refresh()
    }

    func addAccount(accountNo:String, bankName:String, balanceText:String) -> Bool {
        guard let created = DbService.shared.addAccount(accountNo: accountNo, bankName: bankName, balanceText: balanceText) else {
            return false
        }
        refresh()
        // Select the newly created account so UI follows it.
        if let match = accounts.first(where: { $0.id == created.id }) {
            selectAccount(match)
        }
        return true
    }

    func deleteAccount(_ target: Account) {
        DbService.shared.deleteAccount(target)
        if account?.id == target.id { account = nil }
        refresh()
    }
}
