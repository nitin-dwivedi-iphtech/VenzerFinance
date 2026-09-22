//
//  Service.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 22/09/26.
//

import Combine
import CoreData

class DbService:ObservableObject {
    static var shared = DbService()
    var context:NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    func fetchAccount(for user:User?) -> Account? {
        guard let userID = user?.id else { return nil }
        
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        request.predicate = NSPredicate(format: "user_id == %@", userID as CVarArg)
        request.fetchLimit = 1
        let data = try? context.fetch(request)
        return data?.first
    }
}
