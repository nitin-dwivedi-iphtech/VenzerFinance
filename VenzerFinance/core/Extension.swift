//
//  Extension.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 21/09/26.
//

import CoreData
import Foundation
import SwiftUI

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

extension UIImage {
    func scaledToMax(_ maxLength: CGFloat) -> UIImage {
        let longest = max(size.width, size.height)
        guard longest > maxLength, longest > 0 else { return self }
        
        let scale = maxLength / longest
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

extension View {
    func transactionCard() -> some View {
        modifier(TransactionCardModifier())
    }
    
    func transactionInnerBox() -> some View {
        modifier(TransactionInnerBoxModifier())
    }
    func settingInset(_ opacity: Double = 0.38, radius: CGFloat = 16) -> some View {
        modifier(SettingInsetModifier(opacity: opacity, radius: radius))
    }
}


extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .list, .sound]
    }

}
