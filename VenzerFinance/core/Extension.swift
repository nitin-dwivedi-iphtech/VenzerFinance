//
//  Extension.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//
import CoreData

extension NSManagedObjectContext {
    func saveData() {
        guard self.hasChanges else { return } // Avoid unnecessary save calls
        
        // Diagnostic - will reveal the `GenericObjCError 0` root cause
        if persistentStoreCoordinator == nil {
            print("❌ Core Data Save Error: context has no persistentStoreCoordinator (not injected via .environment)")
        }
        if persistentStoreCoordinator?.persistentStores.isEmpty == true {
            print("❌ Core Data Save Error: context has no persistentStores")
        }
        
        do {
            try self.save()
        } catch {
            let nsError = error as NSError
            print("❌ Core Data Save Error: \(nsError.localizedDescription)")
            print("UserInfo: \(nsError.userInfo)")
            print("Full error: \(nsError)")
            if let detailed = nsError.userInfo[NSDetailedErrorsKey] as? [NSError] {
                for e in detailed { print("  -> detailed: \(e), \(e.userInfo)") }
            }
        }
    }
}
