//
//  DepositAmountCardView.swift
//  VenzerFinance
//
//  Created by iPHTech 40 on 30/09/26.
//

import SwiftUI

struct DepositAmountCardView: View {
    @ObservedObject var viewModel: DepositViewModel
    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(spacing: 10) {
            Text("Amount")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.gray)
                .tracking(0.4)

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
                        let clean = DepositViewModel.sanitized(newValue)
                        if clean != newValue { viewModel.amount = clean }
                    }
                    .frame(minWidth: 60)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .onTapGesture { isFocused = true }

            Text(viewModel.amountErrorMessage ?? "Enter amount to move")
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
                                : (scheme == .dark ? Color("InsideCarBottomColor") : Color("CardColor"))
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
                            .overlay(
                                Capsule().stroke(
                                    isSelected && scheme == .dark ? Color.white.opacity(0.35) : Color.clear,
                                    lineWidth: 1
                                )
                            )
                    }
                }
            }
            .padding(.top, 2)
        }
        .transactionCard()
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { isFocused = false }
            }
        }
    }
}
