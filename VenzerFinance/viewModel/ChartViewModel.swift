//
//  ChartViewModel.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 29/09/26.
//

import Combine
import Foundation

final class ChartViewModel: ObservableObject {

    struct MonthStat: Identifiable {
        let id: String
        let start: Date
        let label: String
        let sent: Double
        let received: Double
        var total: Double { sent + received }
    }

    struct DayStat: Identifiable {
        let id: String
        let date: Date
        let label: String
        let sent: Double
    }

    @Published var rangeMonths = 6
    @Published private(set) var months: [MonthStat] = []
    @Published private(set) var last5Days: [DayStat] = []
    @Published private(set) var currencySymbol = "$"

    @Published private(set) var totalSent = 0.0
    @Published private(set) var totalReceived = 0.0
    @Published private(set) var largestMonthLabel = "—"
    @Published private(set) var largestMonthValue = 0.0
    @Published private(set) var activeDayLabel = "—"

    let rangeOptions = [3, 6, 12]
    private var cancellables = Set<AnyCancellable>()

    init() {
        refresh()
        NotificationCenter.default.publisher(for: .balanceDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.refresh() }
            .store(in: &cancellables)
    }

    var netFlow: Double { totalReceived - totalSent }

    var totalSentDisplay: String { "\(currencySymbol)\(String(format: "%.2f", totalSent))" }
    var totalReceivedDisplay: String { "\(currencySymbol)\(String(format: "%.2f", totalReceived))" }
    var netDisplay: String {
        let sign = netFlow >= 0 ? "+" : "-"
        return "\(sign)\(currencySymbol)\(String(format: "%.2f", abs(netFlow)))"
    }

    var hasData: Bool { totalSent > 0 || totalReceived > 0 }

    func refresh() {
        let user = AppState.shared.user
        currencySymbol = Self.resolveSymbol(for: user)
        let account = DbService.shared.fetchAccount(for: user)
        let records = DbService.shared.fetchTransactions(for: user, account: account, limit: 1000)

        let calendar = Calendar.current
        let now = Date()

        // Monthly buckets for selected range
        let monthFmt = DateFormatter()
        monthFmt.dateFormat = "MMM"
        var monthStats: [MonthStat] = []
        for offset in stride(from: rangeMonths - 1, through: 0, by: -1) {
            guard let monthDate = calendar.date(byAdding: .month, value: -offset, to: now),
                  let start = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate)) else { continue }
            var sent = 0.0
            var received = 0.0
            for tx in records {
                guard let date = tx.timestamp,
                      calendar.isDate(date, equalTo: monthDate, toGranularity: .month),
                      let value = Double(tx.amount ?? "") else { continue }
                if (tx.value(forKey: "type") as? String) == "credit" {
                    received += value
                } else {
                    sent += value
                }
            }
            monthStats.append(MonthStat(
                id: start.ISO8601Format(),
                start: start,
                label: monthFmt.string(from: monthDate),
                sent: sent,
                received: received
            ))
        }
        months = monthStats

        // Daily sent, last 5 days
        let dayFmt = DateFormatter()
        dayFmt.dateFormat = "d MMM"
        var days: [DayStat] = []
        for offset in stride(from: 4, through: 0, by: -1) {
            guard let date = calendar.date(byAdding: .day, value: -offset, to: calendar.startOfDay(for: now)) else { continue }
            let sent = records.reduce(0.0) { sum, tx in
                guard (tx.value(forKey: "type") as? String) != "credit",
                      let d = tx.timestamp,
                      calendar.isDate(d, inSameDayAs: date),
                      let v = Double(tx.amount ?? "") else { return sum }
                return sum + v
            }
            days.append(DayStat(
                id: date.ISO8601Format(),
                date: date,
                label: dayFmt.string(from: date),
                sent: sent
            ))
        }
        last5Days = days

        totalSent = monthStats.reduce(0) { $0 + $1.sent }
        totalReceived = monthStats.reduce(0) { $0 + $1.received }
        if let best = monthStats.max(by: { $0.sent < $1.sent }), best.sent > 0 {
            largestMonthLabel = best.label
            largestMonthValue = best.sent
        } else {
            largestMonthLabel = "—"
            largestMonthValue = 0
        }
        if let peak = days.max(by: { $0.sent < $1.sent }), peak.sent > 0 {
            activeDayLabel = peak.label
        } else {
            activeDayLabel = "—"
        }
    }

    private static func resolveSymbol(for user: User?) -> String {
        if let account = DbService.shared.fetchAccount(for: user),
           let code = account.currency,
           let country = Country.fromCurrencyCode(code) {
            return country.currencySymbol
        }
        guard let raw = user?.country, let country = Country(rawValue: raw) else { return "$" }
        return country.currencySymbol
    }
}
