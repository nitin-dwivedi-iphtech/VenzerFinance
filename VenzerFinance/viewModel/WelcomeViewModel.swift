//
//  WelcomeViewModel.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 22/09/26.
//

import Combine
import CoreData
import Foundation

class WelcomeViewModel:ObservableObject {
    @Published var user = AppState.shared.user
    @Published var account:Account?
    @Published var avatarData: Data?
    @Published var transactionItems: [TransactionItem] = []
    @Published var heatmapCounts: [[Int]] = Array(repeating: Array(repeating: 0, count: 20), count: 7)
    @Published var heatmapMonthColumns: [(month: String, weeks: Int)] = []
    var context:NSManagedObjectContext = PersistenceController.shared.container.viewContext
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        refresh()
        NotificationCenter.default.publisher(for: .balanceDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.refresh() }
            .store(in: &cancellables)
    }
    
    func refresh() {
        user = AppState.shared.user
        avatarData = user?.image
        fetchAccount()
        fetchTransactions()
    }
    
    private func fetchAccount() {
        self.account = DbService.shared.fetchAccount(for: user)
        
    }

    private static let heatmapWeekCount = 20
    private static let heatmapBlockWeeks = 4

    private func fetchTransactions() {
        let records = DbService.shared.fetchTransactions(for: user, account: account, limit: 1000)
        transactionItems = records.prefix(50).map { Self.mapToItem($0, currencySymbol: currencySymbol) }
        buildHeatmap(from: records)
    }

    private func buildHeatmap(from records: [Transaction]) {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday-first rows
        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today) // 1=Sun … 7=Sat
        let daysSinceMonday = (weekday + 5) % 7
        guard let thisMonday = calendar.date(byAdding: .day, value: -daysSinceMonday, to: today) else { return }

        var dayCounts: [Date: Int] = [:]
        dayCounts.reserveCapacity(records.count)
        for tx in records {
            guard let date = tx.timestamp else { continue }
            let day = calendar.startOfDay(for: date)
            if day > today { continue }
            dayCounts[day, default: 0] += 1
        }

        var counts = Array(repeating: Array(repeating: 0, count: Self.heatmapWeekCount), count: 7)
        var weekStarts: [Date] = []
        weekStarts.reserveCapacity(Self.heatmapWeekCount)
        for col in 0..<Self.heatmapWeekCount {
            guard let weekStart = calendar.date(
                byAdding: .day,
                value: (col - (Self.heatmapWeekCount - 1)) * 7,
                to: thisMonday
            ) else { continue }
            weekStarts.append(weekStart)
            for row in 0..<7 {
                guard let date = calendar.date(byAdding: .day, value: row, to: weekStart) else { continue }
                counts[row][col] = dayCounts[calendar.startOfDay(for: date)] ?? 0
            }
        }
        heatmapCounts = counts

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        var columns: [(month: String, weeks: Int)] = []
        let blockCount = Self.heatmapWeekCount / Self.heatmapBlockWeeks
        for block in 0..<blockCount {
            let midCol = min(block * Self.heatmapBlockWeeks + 1, weekStarts.count - 1)
            columns.append((month: formatter.string(from: weekStarts[midCol]), weeks: Self.heatmapBlockWeeks))
        }
        heatmapMonthColumns = columns
    }

    var currencySymbol: String {
        if let code = account?.currency, let country = Country.fromCurrencyCode(code) {
            return country.currencySymbol
        }
        guard let raw = user?.country, let country = Country(rawValue: raw) else { return "$" }
        return country.currencySymbol
    }

    var currencyCode: String {
        if let code = account?.currency, !code.isEmpty {
            return code
        }
        guard let raw = user?.country, let country = Country(rawValue: raw) else { return "USD" }
        return country.currencyCode
    }

    var monthExpenseTotal: String {
        let calendar = Calendar.current
        let now = Date()
        let total = DbService.shared.fetchTransactions(for: user, account: account, limit: 1000).reduce(0.0) { sum, tx in
            guard (tx.value(forKey: "type") as? String) != "credit",
                  let date = tx.timestamp,
                  calendar.isDate(date, equalTo: now, toGranularity: .month),
                  let value = Double(tx.amount ?? "") else { return sum }
            return sum + value
        }
        return String(format: "%.2f", total)
    }

    var monthExpenseDisplay: String {
        "\(currencySymbol)\(monthExpenseTotal)"
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()

    private static func mapToItem(_ tx: Transaction, currencySymbol: String) -> TransactionItem {
        let value = Double(tx.amount ?? "") ?? 0
        let dateText = tx.timestamp.map { dateFormatter.string(from: $0) } ?? ""
        let isCredit = (tx.value(forKey: "type") as? String) == "credit"
        return TransactionItem(
            id: tx.id ?? UUID().uuidString,
            title: isCredit ? "Money Received" : "Money Sent",
            detail: dateText.isEmpty ? "Transfer" : "Transfer • \(dateText)",
            icon: isCredit ? "arrow.down.left.circle.fill" : "paperplane.fill",
            amount: String(format: "%@%@%.2f", isCredit ? "+" : "-", currencySymbol, value),
            isCredit: isCredit
        )
    }
}
