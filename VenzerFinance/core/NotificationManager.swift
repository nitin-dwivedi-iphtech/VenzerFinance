//
//  NotificationManager.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 5/10/26.
//

import Combine
import UserNotifications

final class NotificationManager: NSObject, ObservableObject {
    static let shared = NotificationManager()

    static let debitNotificationsKey = "debitNotificationsEnabled"

    @Published private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        refreshAuthorizationStatus()
    }

    var debitNotificationsEnabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: Self.debitNotificationsKey) == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: Self.debitNotificationsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Self.debitNotificationsKey)
        }
    }

    func refreshAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.authorizationStatus = settings.authorizationStatus
            }
        }
    }

    @discardableResult
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            await MainActor.run { refreshAuthorizationStatus() }
            return granted
        } catch {
            return false
        }
    }

    func requestAuthorizationIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            guard settings.authorizationStatus == .notDetermined else {
                DispatchQueue.main.async { self?.authorizationStatus = settings.authorizationStatus }
                return
            }
            Task { await self?.requestAuthorization() }
        }
    }

    func notifyDebit(amount: Double, from account: Account, detail: String? = nil) {
        guard debitNotificationsEnabled else { return }
        guard amount > 0 else { return }

        let symbol = Country.fromCurrencyCode(account.currency)?.currencySymbol ?? "$"
        let code = account.currency ?? "USD"
        let bank = (account.bankName?.isEmpty == false ? account.bankName : nil) ?? "Account"
        let lastFour: String = {
            guard let no = account.account_no, no.count >= 4 else { return account.account_no ?? "" }
            return "•••• \(no.suffix(4))"
        }()
        let amountText = "\(symbol)\(String(format: "%.2f", amount))"
        let balanceText = "\(symbol)\(String(format: "%.2f", account.balance))"

        var body = "\(amountText) debited from \(bank) \(lastFour)"
        if let detail, !detail.isEmpty {
            body += " \(detail)"
        }
        body += ". Avl bal: \(balanceText) (\(code))"

        let content = UNMutableNotificationContent()
        content.title = "Amount Debited"
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "debit-\(account.id ?? UUID().uuidString)-\(UUID().uuidString)",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized
                    || settings.authorizationStatus == .provisional
                    || settings.authorizationStatus == .ephemeral else { return }
            UNUserNotificationCenter.current().add(request)
        }
    }
}

