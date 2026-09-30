//
//  AllTransactionsViewModel.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 29/09/26.
//

import Combine
import Foundation

final class AllTransactionsViewModel: ObservableObject {

    enum TimeFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case week = "This Week"
        case month = "This Month"
        var id: String { rawValue }
    }

    struct TxRow: Identifiable {
        let id: String
        let amount: Double
        let date: Date
        let title: String
        let detail: String
        let isCredit: Bool
    }

    struct DayGroup: Identifiable {
        let id: String
        let title: String
        let subtitle: String
        let rows: [TxRow]
        let dayTotal: Double
    }

    @Published var searchText = ""
    @Published var selectedFilter: TimeFilter = .all
    @Published private(set) var rows: [TxRow] = []
    @Published private(set) var currencySymbol = "$"

    private var cancellables = Set<AnyCancellable>()

    init() {
        refresh()
        NotificationCenter.default.publisher(for: .balanceDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.refresh() }
            .store(in: &cancellables)
    }

    func refresh() {
        let user = AppState.shared.user
        currencySymbol = Self.resolveSymbol(for: user)
        let account = DbService.shared.fetchAccount(for: user)
        let records = DbService.shared.fetchTransactions(for: user, account: account, limit: 1000)
        rows = records.map { tx in
            let value = Double(tx.amount ?? "") ?? 0
            let date = tx.timestamp ?? Date()
            let isCredit = (tx.value(forKey: "type") as? String) == "credit"
            return TxRow(
                id: tx.id ?? UUID().uuidString,
                amount: value,
                date: date,
                title: isCredit ? "Money Received" : "Money Sent",
                detail: Self.detailText(for: date),
                isCredit: isCredit
            )
        }
    }

    // Derived

    var filteredRows: [TxRow] {
        let calendar = Calendar.current
        let now = Date()
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        return rows.filter { row in
            switch selectedFilter {
            case .all:
                break
            case .week:
                guard calendar.isDate(row.date, equalTo: now, toGranularity: .weekOfYear) else { return false }
            case .month:
                guard calendar.isDate(row.date, equalTo: now, toGranularity: .month) else { return false }
            }
            if !query.isEmpty {
                let hay = "\(row.title) \(row.detail) \(String(format: "%.2f", row.amount))".lowercased()
                guard hay.contains(query) else { return false }
            }
            return true
        }
    }

    var grouped: [DayGroup] {
        let calendar = Calendar.current
        let dict = Dictionary(grouping: filteredRows) { calendar.startOfDay(for: $0.date) }
        return dict.keys.sorted(by: >).map { day in
            let dayRows = (dict[day] ?? []).sorted { $0.date > $1.date }
            let net = dayRows.reduce(0) { $0 + ($1.isCredit ? $1.amount : -$1.amount) }
            return DayGroup(
                id: day.ISO8601Format(),
                title: Self.dayTitle(for: day),
                subtitle: Self.daySubtitle(for: day),
                rows: dayRows,
                dayTotal: net
            )
        }
    }

    var totalSpent: Double { filteredRows.filter { !$0.isCredit }.reduce(0) { $0 + $1.amount } }

    var sentCount: Int { filteredRows.filter { !$0.isCredit }.count }
    var receivedCount: Int { filteredRows.filter { $0.isCredit }.count }

    var totalSpentDisplay: String {
        "\(currencySymbol)\(String(format: "%.2f", totalSpent))"
    }

    var countText: String {
        if sentCount > 0 && receivedCount > 0 {
            return "\(sentCount) sent • \(receivedCount) received"
        }
        if receivedCount > 0 && sentCount == 0 {
            return receivedCount == 1 ? "1 received" : "\(receivedCount) received"
        }
        return sentCount == 1 ? "1 transaction" : "\(sentCount) transactions"
    }

    // Helpers

    private static func resolveSymbol(for user: User?) -> String {
        if let account = DbService.shared.fetchAccount(for: user),
           let code = account.currency,
           let country = Country.fromCurrencyCode(code) {
            return country.currencySymbol
        }
        guard let raw = user?.country, let country = Country(rawValue: raw) else { return "$" }
        return country.currencySymbol
    }

    private static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy"
        return f
    }()

    private static func detailText(for date: Date) -> String {
        "Transfer • \(dayFormatter.string(from: date))"
    }

    private static func dayTitle(for day: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(day) { return "Today" }
        if calendar.isDateInYesterday(day) { return "Yesterday" }
        return dayFormatter.string(from: day)
    }

    private static func daySubtitle(for day: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE"
        return f.string(from: day)
    }
}
