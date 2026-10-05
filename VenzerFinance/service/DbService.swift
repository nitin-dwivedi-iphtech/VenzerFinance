//
//  Service.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//

import Combine
import CoreData
import Foundation

class DbService: ObservableObject {
    static var shared = DbService()
    var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    func fetchAccount(for user: User?) -> Account? {
        if let selectedId = AppState.shared.selectedAccountId,
           let selected = fetchAccounts(for: user).first(where: { $0.id == selectedId }) {
            return selected
        }
        return fetchPrimaryAccount(for: user) ?? fetchAccounts(for: user).first
    }

    func fetchAccounts(for user: User?) -> [Account] {
        guard let userID = user?.id else { return [] }
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        request.predicate = NSPredicate(format: "user_id == %@", userID as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "bankName", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }

    // Primary account

    func isPrimary(_ account: Account?) -> Bool {
        (account?.value(forKey: "isPrimary") as? Bool) ?? false
    }

    func fetchPrimaryAccount(for user: User?) -> Account? {
        let all = fetchAccounts(for: user)
        if let primary = all.first(where: { isPrimary($0) }) { return primary }
        if let first = all.first {
            setPrimaryAccount(first, for: user)
            return first
        }
        return nil
    }

    func setPrimaryAccount(_ account: Account?, for user: User?) {
        guard let account else { return }
        let siblings = fetchAccounts(for: user)
        for item in siblings {
            item.setValue(item.objectID == account.objectID, forKey: "isPrimary")
        }
        account.setValue(true, forKey: "isPrimary")
        context.saveData()
        NotificationCenter.default.post(name: .balanceDidChange, object: nil)
    }
    
    func getAccountDetails(for account_no:String) -> Account? {
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        request.predicate = NSPredicate(format: "account_no == %@", account_no)
        request.fetchLimit = 1
        let data = try? context.fetch(request)
        return data?.first
    }
    
    // Accounts
    func defaultCurrencyCode(for user: User?) -> String {
        if let raw = user?.country, let country = Country(rawValue: raw) {
            return country.currencyCode
        }
        return "USD"
    }

    @discardableResult
    func saveAccountDetails(accountNo: String, bankName: String, balanceText: String, for user: User?, existingAccount: Account?) -> Account {
        let account: Account
        let isNew: Bool
        if let existing = existingAccount {
            account = existing
            isNew = false
        } else {
            account = Account(context: context)
            account.id = UUID().uuidString
            account.user_id = user?.id
            isNew = true
        }
        account.account_no = accountNo.trimmingCharacters(in: .whitespacesAndNewlines)
        account.bankName = bankName.trimmingCharacters(in: .whitespacesAndNewlines)
        if let value = Double(balanceText.trimmingCharacters(in: .whitespacesAndNewlines)) {
            account.balance = value
        }
        if account.currency == nil || account.currency?.isEmpty == true {
            account.currency = defaultCurrencyCode(for: user)
        }
        // First account becomes primary automatically.
        if isNew {
            let hadSiblings = !fetchAccounts(for: user).filter({ $0.objectID != account.objectID }).isEmpty
            account.setValue(!hadSiblings, forKey: "isPrimary")
        }
        context.saveData()
        NotificationCenter.default.post(name: .balanceDidChange, object: nil)
        return account
    }

    @discardableResult
    func addAccount(accountNo:String, bankName:String, balanceText:String) -> Account? {
        let trimmedNo = accountNo.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedNo.isEmpty { return nil }
        if (getAccountDetails(for: trimmedNo) != nil) { return nil }

        let user = AppState.shared.user
        let isFirst = fetchAccounts(for: user).isEmpty
        let account = Account(context: context)
        if let value = Double(balanceText.trimmingCharacters(in: .whitespacesAndNewlines)) {
            account.balance = value
        }
        account.id = UUID().uuidString
        account.user_id = user?.id
        account.account_no = accountNo.trimmingCharacters(in: .whitespacesAndNewlines)
        account.bankName = bankName.trimmingCharacters(in: .whitespacesAndNewlines)
        account.currency = defaultCurrencyCode(for: user)
        account.setValue(isFirst, forKey: "isPrimary")
        context.saveData()
        NotificationCenter.default.post(name: .balanceDidChange, object: nil)
        return account
    }

    func deleteAccount(_ account: Account) {
        let wasPrimary = isPrimary(account)
        let ownerId = account.user_id
        context.delete(account)
        context.saveData()
        if wasPrimary, let ownerId {
            let request: NSFetchRequest<Account> = Account.fetchRequest()
            request.predicate = NSPredicate(format: "user_id == %@", ownerId as CVarArg)
            request.fetchLimit = 1
            if let next = (try? context.fetch(request))?.first {
                next.setValue(true, forKey: "isPrimary")
                context.saveData()
            }
        }
        NotificationCenter.default.post(name: .balanceDidChange, object: nil)
    }
    
    // Personal Details
    func updatePersonalDetails(for user: User, fullName: String, email: String, phone: String) {
        user.name = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        user.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        user.phone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        context.saveData()
        NotificationCenter.default.post(name: .balanceDidChange, object: nil)
    }

    func updateProfilePhoto(_ data: Data?, for user: User) {
        user.image = data
        context.saveData()
        NotificationCenter.default.post(name: .balanceDidChange, object: nil)
    }

    // Users (recipients = all users other than current)
    func fetchAllUsers(excluding user: User?, limit: Int = 100) -> [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()
        if let id = user?.id {
            request.predicate = NSPredicate(format: "id != %@", id as CVarArg)
        }
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.fetchBatchSize = 50
        request.fetchLimit = limit
        request.returnsObjectsAsFaults = true
        return (try? context.fetch(request)) ?? []
    }

    func fetchAccountsByUserIds(_ userIds: [String]) -> [String: Account] {
        guard !userIds.isEmpty else { return [:] }
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        request.predicate = NSPredicate(format: "user_id IN %@", userIds)
        request.fetchBatchSize = 50
        let accounts = (try? context.fetch(request)) ?? []
        var map: [String: Account] = [:]
        for account in accounts {
            if let key = account.user_id { map[key] = account }
        }
        return map
    }

    // Transactions (send money)
    func fetchTransactions(for user: User?, limit: Int = 50) -> [Transaction] {
        guard let userID = user?.id else { return [] }
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "user_id == %@", userID as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.fetchBatchSize = 50
        request.fetchLimit = limit
        request.returnsObjectsAsFaults = true
        return (try? context.fetch(request)) ?? []
    }

    func fetchTransactions(for user: User?, account: Account?, limit: Int = 50) -> [Transaction] {
        guard let accountId = account?.id else {
            return fetchTransactions(for: user, limit: limit)
        }
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "account_id == %@", accountId as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.fetchBatchSize = 50
        request.fetchLimit = limit
        request.returnsObjectsAsFaults = true
        return (try? context.fetch(request)) ?? []
    }

    @discardableResult
    func recordTransaction(amount: Double, from account: Account?, for user: User?, forUserId: String? = nil, type: String = "debit") -> Transaction? {
        guard let account else { return nil }
        let tx = Transaction(context: context)
        tx.id = UUID().uuidString
        tx.amount = String(format: "%.2f", amount)
        tx.account_id = account.id
        tx.user_id = forUserId ?? user?.id ?? account.user_id
        tx.timestamp = Date()
        tx.setValue(type, forKey: "type")
        context.saveData()
        return tx
    }

    @discardableResult
    func applyCurrencyConversion(account: Account?, convertedAmount: Double, toCurrencyCode: String) -> Bool {
        guard let account else { return false }
        account.balance = convertedAmount
        account.currency = toCurrencyCode
        context.saveData()
        NotificationCenter.default.post(name: .balanceDidChange, object: nil)
        return true
    }

    @discardableResult
    func sendMoney(amount: Double, from account: Account?, for user: User?, to recipientUserId: String? = nil) -> Bool {
        guard let account, amount > 0, account.balance >= amount else { return false }
        account.balance -= amount
        if let recipientId = recipientUserId {
            let request: NSFetchRequest<Account> = Account.fetchRequest()
            request.predicate = NSPredicate(format: "user_id == %@", recipientId as CVarArg)
            request.fetchLimit = 1
            if let recipientAccount = (try? context.fetch(request))?.first {
                recipientAccount.balance += amount
                recordTransaction(
                    amount: amount,
                    from: recipientAccount,
                    for: nil,
                    forUserId: recipientAccount.user_id ?? recipientId,
                    type: "credit"
                )
            }
        }
        recordTransaction(amount: amount, from: account, for: user, type: "debit")
        context.saveData()
        NotificationCenter.default.post(name: .balanceDidChange, object: nil)
        return true
    }

    @discardableResult
    func depositMoney(amount: Double, to account: Account?, for user: User?) -> Bool {
        guard let account, amount > 0 else { return false }
        account.balance += amount
        recordTransaction(amount: amount, from: account, for: user, type: "credit")
        context.saveData()
        NotificationCenter.default.post(name: .balanceDidChange, object: nil)
        return true
    }

    @discardableResult
    func transferMoney(amount: Double, from source: Account?, to destination: Account?, for user: User?) -> Bool {
        guard let source, let destination,
              source.objectID != destination.objectID,
              source.account_no != destination.account_no,
              amount > 0, source.balance >= amount else { return false }
        source.balance -= amount
        destination.balance += amount
        recordTransaction(amount: amount, from: source, for: user, type: "debit")
        recordTransaction(amount: amount, from: destination, for: user, type: "credit")
        context.saveData()
        NotificationCenter.default.post(name: .balanceDidChange, object: nil)
        return true
    }
}
