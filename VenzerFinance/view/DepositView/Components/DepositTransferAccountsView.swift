//
//  DepositTransferAccountsView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 30/09/26.
//

import SwiftUI

enum DepositPickerSide {
    case from, to
}

struct DepositTransferAccountsView: View {
    @ObservedObject var viewModel: DepositViewModel
    @Binding var pickerSide: DepositPickerSide?
    @Environment(\.colorScheme) private var scheme
    @State var showAlert:Bool = false

    private var accent: Color {
        scheme == .dark ? Color("InsideCarBottomColor") : Color("CardColor")
    }

    var body: some View {
        VStack(spacing: 0) {
            selectorRow(
                label: "From",
                caption: "Deduct from",
                account: viewModel.fromAccount,
                icon: "arrow.up.circle.fill"
            ) { pickerSide = .from }

            // Swap connector
            HStack {
                Rectangle()
                    .fill(Color("CardText").opacity(0.1))
                    .frame(width: 1, height: 14)
            }
            .frame(maxWidth: .infinity)
            .overlay(alignment: .center) {
                Button(action: { viewModel.swapAccounts() }) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
                        .background(Color("CardColor"), in: Circle())
                        .overlay(Circle().stroke(Color.white.opacity(scheme == .dark ? 0.35 : 0), lineWidth: 1))
                        .shadow(color: Color("CardColor").opacity(scheme == .dark ? 0.6 : 0.3), radius: 6, x: 0, y: 3)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 2)

            selectorRow(
                label: "To",
                caption: "Add to",
                account: viewModel.toAccount,
                icon: "arrow.down.circle.fill"
            ) { pickerSide = .to }
        }.onChange(of: [viewModel.fromAccount, viewModel.toAccount]){ _, newValue in
            if (newValue[0] == newValue[1]) {
                showAlert = true
                viewModel.fromAccount = nil
                viewModel.toAccount = nil
            }
        }
        .alert("Error", isPresented: $showAlert) {
            Button(action:{
                showAlert = false
            }) {
                Text("Ok")
            }
        } message: {
            Text("Same account selected")
        }
        .transactionCard()
    }

    private func selectorRow(label: String, caption: String, account: Account?, icon: String, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Circle()
                    .fill(accent.opacity(scheme == .dark ? 0.22 : 0.12))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(accent)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(caption) • \(label)")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.gray)
                    Text(viewModel.title(for: account))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color("CardText"))
                        .lineLimit(1)
                    Text(viewModel.balanceText(for: account))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.gray)
                        .monospacedDigit()
                }

                Spacer(minLength: 8)

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color("CardText").opacity(0.6))
            }
            .padding(12)
            .background(Color("CardText").opacity(0.03), in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

struct DepositAccountPickerSheet: View {
    @ObservedObject var viewModel: DepositViewModel
    let side: DepositPickerSide
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) private var scheme

    private var accent: Color {
        scheme == .dark ? Color("InsideCarBottomColor") : Color("CardColor")
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.accounts, id: \.id) { account in
                    Button {
                        if side == .from {
                            viewModel.selectFrom(account)
                        } else {
                            viewModel.selectTo(account)
                        }
                        isPresented = false
                    } label: {
                        HStack(spacing: 12) {
                            Text(String((account.bankName ?? "A").prefix(1)).uppercased())
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 38, height: 38)
                                .background(Color("CardColor"), in: Circle())

                            VStack(alignment: .leading, spacing: 1) {
                                Text(viewModel.title(for: account))
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color("CardText"))
                                Text(viewModel.balanceText(for: account))
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                                    .monospacedDigit()
                            }

                            Spacer()

                            if isSelected(account) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(accent)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle(side == .from ? "From account" : "To account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { isPresented = false }
                }
            }
        }
    }

    private func isSelected(_ account: Account?) -> Bool {
        guard let account, let id = account.id else { return false }
        if side == .from { return viewModel.fromAccount?.id == id }
        return viewModel.toAccount?.id == id
    }
}
