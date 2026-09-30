//
//  AmountCardView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 28/09/26.
//

import SwiftUI

struct AmountCardView: View {
    @ObservedObject var viewModel: TransactionViewModel
    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(spacing: 10) {
            TransactionSectionLabel(text: "Amount", step: "02", centered: true)

            HStack(spacing: 2) {
                Text(viewModel.currencySymbol)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color("CardText").opacity(0.35))
                TextField("0.00", text: $viewModel.amount)
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(Color("CardText"))
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .focused($isFocused)
                    .submitLabel(.done)
                    .onSubmit { isFocused = false }
                    .onChange(of: viewModel.amount) { _, newValue in
                        viewModel.amount = sanitized(newValue)
                    }
                    .frame(minWidth: 60)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .onTapGesture { isFocused = true }

            Text(viewModel.amountErrorMessage ?? "Enter amount above")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(viewModel.amountErrorMessage != nil ? Color(red: 0.78, green: 0.22, blue: 0.22) : .gray)

            HStack(spacing: 8) {
                ForEach(viewModel.quickAmounts, id: \.self) { value in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.setQuickAmount(value)
                        }
                    } label: {
                        let isSelected = viewModel.amount == value
                        Text("\(viewModel.currencySymbol)\(value)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(
                                isSelected ? .white
                                : (scheme == .dark ? Color.white.opacity(0.85) : Color("CardColor"))
                            )
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                isSelected ? Color("CardColor")
                                : (scheme == .dark
                                   ? Color.white.opacity(0.1)
                                   : Color("InsideCarTopColor").opacity(0.6)),
                                in: Capsule()
                            )
                    }
                }
            }
            .padding(.top, 2)
        }
        .transactionCard()
        .padding(.vertical, 2)
        .shadow(
            color: isFocused ? Color("CardColor").opacity(0.22) : Color.black.opacity(0.05),
            radius: isFocused ? 16 : 12, x: 0, y: 6
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { isFocused = false }
            }
        }
    }

    private func sanitized(_ value: String) -> String {
        var filtered = value.filter { $0.isNumber || $0 == "." }
        var dotSeen = false
        filtered = filtered.filter {
            if $0 == "." {
                if dotSeen { return false }
                dotSeen = true
                return true
            }
            return true
        }
        if filtered.hasPrefix(".") { filtered = "0" + filtered }
        if let dotIndex = filtered.firstIndex(of: ".") {
            let decimals = filtered[filtered.index(after: dotIndex)...]
            if decimals.count > 2 {
                let end = filtered.index(dotIndex, offsetBy: 3)
                filtered = String(filtered[..<end])
            }
        }
        if filtered.count > 10 { filtered = String(filtered.prefix(10)) }
        return filtered
    }
}
