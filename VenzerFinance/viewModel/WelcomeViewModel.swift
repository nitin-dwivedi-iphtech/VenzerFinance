//
//  WelcomeViewModel.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 22/09/26.
//

import Combine
import CoreData

class WelcomeViewModel:ObservableObject {
    @Published var user = AppState.shared.user
    @Published var account:Account?
    var context:NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    init() {
        fetchAccount()
    }
    
    private func fetchAccount() {
        guard let userID = user?.id else { return }
        
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        request.predicate = NSPredicate(format: "user_id == %@", userID as CVarArg)
        request.fetchLimit = 1
        let data = try? context.fetch(request)
        self.account = data?.first
        
    }
}
