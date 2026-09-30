//
//  AccountPickerView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 30/09/26.
//

import SwiftUI

struct AccountHeaderButton: View {
    @ObservedObject private var appState = AppState.shared
    @Environment(\.colorScheme) private var scheme
    @State private var refreshTick = 0
    @State private var showSheet = false

    private var accounts: [Account] {
        _ = refreshTick
        return DbService.shared.fetchAccounts(for: appState.user)
    }

    private var selected: Account? {
        if let id = appState.selectedAccountId, let match = accounts.first(where: { $0.id == id }) {
            return match
        }
        return accounts.first(where: { DbService.shared.isPrimary($0) }) ?? accounts.first
    }

    var body: some View {
        Group {
            if let current = selected {
                Button {
                    showSheet = true
                } label: {
                    HStack(spacing: 5) {
                        Text(String((current.bankName ?? "A").prefix(1)).uppercased())
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 22, height: 22)
                            .background(Color("CardColor"), in: Circle())
                        Text("••\(String((current.account_no ?? "").suffix(4)))")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color("CardText"))
                            .monospacedDigit()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(Color("CardText").opacity(0.5))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(Color("CardBackground"), in: Capsule())
                    .overlay(Capsule().stroke(Color.black.opacity(0.07), lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: 0, y: 2)
                }
                .buttonStyle(.plain)
            }
        }
        .onAppear { refreshTick += 1 }
        .onReceive(NotificationCenter.default.publisher(for: .balanceDidChange)) { _ in refreshTick += 1 }
        .onChange(of: appState.user?.id) { _, _ in refreshTick += 1 }
        .sheet(isPresented: $showSheet) {
            AccountSwitcherSheet(accounts: accounts, selectedId: selected?.id)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct AccountSwitcherSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme
    let accounts: [Account]
    let selectedId: String?

    private var accent: Color {
        scheme == .dark ? Color("InsideCarBottomColor") : Color("CardColor")
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(accounts, id: \.id) { account in
                    let isSelected = account.id == selectedId
                    Button {
                        AppState.shared.selectAccount(account)
                        dismiss()
                    } label: {
                        HStack(spacing: 12) {
                            Text(String((account.bankName ?? "A").prefix(1)).uppercased())
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .background(Color("CardColor"), in: Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 6) {
                                    Text(title(for: account))
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(Color("CardText"))
                                        .lineLimit(1)
                                    if DbService.shared.isPrimary(account) {
                                        Text("PRIMARY")
                                            .font(.system(size: 8, weight: .bold))
                                            .foregroundStyle(scheme == .dark ? Color.black : .white)
                                            .padding(.horizontal, 7).padding(.vertical, 2)
                                            .background(accent, in: Capsule())
                                    }
                                }
                                Text(balanceText(for: account))
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(.gray)
                                    .monospacedDigit()
                            }

                            Spacer(minLength: 8)

                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 20))
                                .foregroundStyle(isSelected ? accent : Color("CardText").opacity(0.25))
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Select account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func title(for account: Account) -> String {
        let bank = (account.bankName?.isEmpty == false) ? account.bankName! : "Account"
        if let no = account.account_no, !no.isEmpty {
            return "\(bank) ••\(String(no.suffix(4)))"
        }
        return bank
    }

    private func balanceText(for account: Account) -> String {
        let code = account.currency?.isEmpty == false ? account.currency! : "USD"
        let symbol = Country.fromCurrencyCode(code)?.currencySymbol ?? "$"
        return "\(symbol)\(String(format: "%.2f", account.balance))"
    }
}
