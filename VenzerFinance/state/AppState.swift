//
//  AppState.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//

import Combine
import SwiftUI
import CoreData

class AppState: ObservableObject {
    static var shared = AppState()

    @Published var user:User?
    @Published var isLoggedIn:Bool = false
    @Published var selectedAccountId: String?
    var context:NSManagedObjectContext?

    private init(context:NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        self.isLoggedIn = fetchUser()
        self.selectedAccountId = storedSelectedAccountId()
    }
    
    private func fetchUser() -> Bool {
        guard let id = UserDefaults.standard.string(forKey: Constants.appStateUserKey.rawValue) else { return false }
        let request = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        guard let data = try? context?.fetch(request), let fetched = data.first else { return false}
        self.user = fetched
        return true
    }
    
    func updateUser(user:User?, isLoggedIn:Bool) {
        self.user = user
        self.isLoggedIn = isLoggedIn
        if isLoggedIn {
            self.selectedAccountId = storedSelectedAccountId()
        } else {
            self.selectedAccountId = nil
        }
    }

    private func selectedAccountKey() -> String {
        "selected_account_\(user?.id ?? "none")"
    }

    private func storedSelectedAccountId() -> String? {
        UserDefaults.standard.string(forKey: selectedAccountKey())
    }

    func selectAccount(_ account: Account?) {
        selectedAccountId = account?.id
        if let id = account?.id {
            UserDefaults.standard.set(id, forKey: selectedAccountKey())
        } else {
            UserDefaults.standard.removeObject(forKey: selectedAccountKey())
        }
        NotificationCenter.default.post(name: .balanceDidChange, object: nil)
    }

}
