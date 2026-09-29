//
//  Extension.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//

import CoreData
import Foundation

extension NSManagedObjectContext {
    func saveData() {
        guard self.hasChanges else { return }
        
        if persistentStoreCoordinator == nil {
            print("Core Data Save Error: context has no persistentStoreCoordinator (not injected via .environment)")
        }
        if persistentStoreCoordinator?.persistentStores.isEmpty == true {
            print("Core Data Save Error: context has no persistentStores")
        }
        
        do {
            try self.save()
        } catch {
            let nsError = error as NSError
            print(" Core Data Save Error: \(nsError.localizedDescription)")
        }
    }
}

extension Notification.Name {
    static let balanceDidChange = Notification.Name("balanceDidChange")
}

extension String {
    func fromStringToDouble(value: String) -> Double {
        if let integerValue = Double(value) {
            return (integerValue * 100).rounded() / 100
        }
        return 0
    }
}
