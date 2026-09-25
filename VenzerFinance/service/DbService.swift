//
//  Service.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
//

import Combine
import CoreData

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
        context.saveData()
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
        context.saveData()
        return account
    }
    
    // Personal Details
    func updatePersonalDetails(for user: User, fullName: String, email: String, phone: String) {
        user.name = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        user.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        user.phone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        context.saveData()
        
    }
}
