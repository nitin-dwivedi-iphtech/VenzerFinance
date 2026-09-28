//
//  Service.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
//

import Combine
import CoreData
import Foundation

class DbService: ObservableObject {
    static var shared = DbService()
    var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    func fetchAccount(for user: User?) -> Account? {
        guard let userID = user?.id else { return nil }
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        request.predicate = NSPredicate(format: "user_id == %@", userID as CVarArg)
        request.fetchLimit = 1
        let data = try? context.fetch(request)
        return data?.first
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
        if let existing = existingAccount {
            account = existing
        } else {
            account = Account(context: context)
            account.id = UUID().uuidString
            account.user_id = user?.id
        }
        account.account_no = accountNo.trimmingCharacters(in: .whitespacesAndNewlines)
        account.bankName = bankName.trimmingCharacters(in: .whitespacesAndNewlines)
        if let value = Double(balanceText.trimmingCharacters(in: .whitespacesAndNewlines)) {
            account.balance = value
        }
        // Keep existing currency on edit; default from user's country for legacy rows.
        if account.currency == nil || account.currency?.isEmpty == true {
            account.currency = defaultCurrencyCode(for: user)
        }
        context.saveData()
        NotificationCenter.default.post(name: .balanceDidChange, object: nil)
        return account
    }
    
    @discardableResult
    func addAccount(accountNo:String, bankName:String, balanceText:String) -> Account? {
        if (getAccountDetails(for: accountNo) != nil) { return nil }
        
        let account = Account(context: context)
        if let value = Double(balanceText.trimmingCharacters(in: .whitespacesAndNewlines)) {
            account.balance = value
        }
        account.id = UUID().uuidString
        account.user_id = AppState.shared.user?.id
        account.account_no = accountNo.trimmingCharacters(in: .whitespacesAndNewlines)
        account.bankName = bankName.trimmingCharacters(in: .whitespacesAndNewlines)
        account.currency = defaultCurrencyCode(for: AppState.shared.user)
        context.saveData()
        NotificationCenter.default.post(name: .balanceDidChange, object: nil)
        return account
    }
    
    // Personal Details
    func updatePersonalDetails(for user: User, fullName: String, email: String, phone: String) {
        user.name = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        user.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        user.phone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        context.saveData()
        
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

    @discardableResult
    func recordTransaction(amount: Double, from account: Account?, for user: User?) -> Transaction? {
        guard let account else { return nil }
        let tx = Transaction(context: context)
        tx.id = UUID().uuidString
        tx.amount = String(format: "%.2f", amount)
        tx.account_id = account.id
        tx.user_id = user?.id ?? account.user_id
        tx.timestamp = Date()
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
            }
        }
        recordTransaction(amount: amount, from: account, for: user)
        context.saveData()
        NotificationCenter.default.post(name: .balanceDidChange, object: nil)
        return true
    }
}
