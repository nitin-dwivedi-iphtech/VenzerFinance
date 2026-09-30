//
//  CurrencyConverterViewModel.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 24/09/26.
//
//
import Foundation
import Combine

class CurrencyConverterViewModel: ObservableObject {
    @Published var rate: Double = 0.0

    @Published var accountBalance: Double = 0.0
    @Published var accountCurrencyCode: String = "USD"

    var accountCurrencySymbol: String {
        if let country = Country.fromCurrencyCode(accountCurrencyCode) {
            return country.currencySymbol
        }
        if let raw = AppState.shared.user?.country,
           let country = Country(rawValue: raw) {
            return country.currencySymbol
        }
        return "$"
    }

    var accountBalanceText: String {
        String(format: "%.2f", accountBalance)
    }

    var fullBalanceDisplay: String {
        "\(accountCurrencySymbol)\(accountBalanceText)"
    }

    @Published var isLoading: Bool = false

    init() {
        refreshBalances()
    }

    func refreshBalances() {
        if let account = DbService.shared.fetchAccount(for: AppState.shared.user) {
            accountBalance = account.balance
            if let code = account.currency, !code.isEmpty {
                accountCurrencyCode = code
            }
        } else {
            accountBalance = 0.0
        }
    }

    func getConvertedValue(from: Country, to: Country) -> String {
        Helper.ExchangeRateHelper.calculate(
            for: accountBalance,
            rate: rate,
            fromCountry: from,
            toCountry: to
        ) ?? "0.00"
    }

    @discardableResult
    func applyConversion(from: Country, to: Country) -> Bool {
        guard let account = DbService.shared.fetchAccount(for: AppState.shared.user) else { return false }
        let balance = account.balance
        guard balance > 0 else { return false }
        guard let convertedStr = Helper.ExchangeRateHelper.calculate(
            for: balance,
            rate: rate,
            fromCountry: from,
            toCountry: to
        ), let converted = Double(convertedStr) else { return false }
        let ok = DbService.shared.applyCurrencyConversion(
            account: account,
            convertedAmount: converted,
            toCurrencyCode: to.currencyCode
        )
        if ok { refreshBalances() }
        return ok
    }

    @MainActor
    func fetchRate(from: Country, to: Country) async {
        if from == to {
            self.rate = 1.0
            return
        }

        isLoading = true
        if let fetchedRate = await ApiService.shared.fetchCurrencyRates(for: from.currencyCode, to: to.currencyCode) {
            self.rate = fetchedRate
        }
        isLoading = false
    }
}
