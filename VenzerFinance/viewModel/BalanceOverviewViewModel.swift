//
//  BalanceOverviewViewModel.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import Combine
import CoreData
import Foundation

class BalanceOverviewViewModel: ObservableObject {
    struct Metric: Identifiable, Hashable {
        let id: String
        let icon: String
        let title: String
    }

    let metrics: [Metric] = [
        Metric(id: "overview", icon: "chart.bar.fill", title: "Overview"),
        Metric(id: "breakdown", icon: "chart.pie.fill", title: "Breakdown"),
        Metric(id: "activity", icon: "waveform.path.ecg", title: "Activity"),
        Metric(id: "rates", icon: "percent", title: "Rates"),
        Metric(id: "accounts", icon: "wallet.pass.fill", title: "Accounts")
    ]

    @Published var user = AppState.shared.user
    @Published var account: Account?
    @Published var selectedMetricID: String = "activity" {
        didSet {
            if selectedMetricID == "rates" {
                Task { await loadRate() }
            }
        }
    }

    @Published var balanceDisplay: String = "$0.00"
    @Published var monthSpentDisplay: String = "$0.00"
    @Published var monthTransactionCount: String = "0"
    @Published var largestTransferDisplay: String = "$0.00"
    @Published var monthName: String = ""
    
    @Published var monthSpentValue: Double = 0
    @Published var monthTransferCount: Int = 0
    @Published var balanceValue: Double = 0

    @Published var rateText: String = "—"
    @Published var isLoadingRate: Bool = false

    var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    private var cancellables = Set<AnyCancellable>()

    init() {
        refresh()
        NotificationCenter.default.publisher(for: .balanceDidChange)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.refresh() }
            .store(in: &cancellables)
    }

    var hasAccount: Bool {
        account != nil
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

    func refresh() {
        user = AppState.shared.user
        account = DbService.shared.fetchAccount(for: user)

        let balance = account?.balance ?? 0
        balanceValue = balance
        balanceDisplay = money(balance)

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        monthName = formatter.string(from: Date())

        let records = DbService.shared.fetchTransactions(for: user, limit: 1000)
        let calendar = Calendar.current
        let now = Date()
        let monthValues = records.compactMap { tx -> Double? in
            guard let date = tx.timestamp,
                  calendar.isDate(date, equalTo: now, toGranularity: .month),
                  let value = Double(tx.amount ?? "") else { return nil }
            return value
        }
        monthSpentValue = monthValues.reduce(0, +)
        monthTransferCount = monthValues.count
        monthSpentDisplay = money(monthSpentValue)
        monthTransactionCount = "\(monthTransferCount)"
        largestTransferDisplay = money(monthValues.max() ?? 0)

        if selectedMetricID == "rates" {
            Task { await loadRate() }
        }
    }

    var spentShare: Double {
        let total = monthSpentValue + balanceValue
        guard total > 0 else { return 0 }
        return min(1, monthSpentValue / total)
    }

    var spentPercentText: String {
        "\(Int((spentShare * 100).rounded()))%"
    }

    var accountBankName: String {
        account?.bankName ?? "Account"
    }

    var accountLastFour: String {
        guard let no = account?.account_no, !no.isEmpty else { return "••••" }
        return String(no.suffix(4))
    }

    @MainActor
    func loadRate() async {
        let code = currencyCode
        guard code != "USD" else {
            rateText = "Base currency"
            return
        }
        isLoadingRate = true
        if let rate = await ApiService.shared.fetchCurrencyRates(for: code, to: "USD") {
            rateText = String(format: "= %.4f USD", rate)
        } else {
            rateText = "Unavailable"
        }
        isLoadingRate = false
    }


    private func money(_ value: Double) -> String {
        "\(currencySymbol)\(Self.grouped(value))"
    }

    private static let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private static func grouped(_ value: Double) -> String {
        amountFormatter.string(from: NSNumber(value: value)) ?? String(format: "%.2f", value)
    }
}
