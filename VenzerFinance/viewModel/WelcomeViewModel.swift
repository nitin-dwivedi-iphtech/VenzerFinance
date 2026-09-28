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
    
    func refresh() {
        user = AppState.shared.user
        fetchAccount()
    }
    
    private func fetchAccount() {
        self.account = DbService.shared.fetchAccount(for: user)
        
    }
}
